//------------------------------------------------------------------------------
//
//     _______ __ __           
//    |   _   |  |  |--.-----. 
//    |___|   |  |  _  |__ --| 
//     _(__   |__|_____|_____| 
//    |:  1   |                
//    |::.. . |                
//    `-------'      
//                       
//   3lbs Copyright 2013 
//   For more information see http://www.3lbs.com 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

// TODO -- create 2nd calculation method which uses percentages

package AI.steering
{

	import flash.geom.Rectangle;
	
	import AI.boid.Boid2DComponent;
	import AI.steering.behaviors.ABehavior;
	import AI.steering.behaviors.IGroupBehavior;
	
	import totem.components.spatial.ISpatial2D;
	import totem.components.spatial.ISpatialManager;
	import totem.events.RemovableEventDispatcher;
	import totem.math.Vector2D;
	
	import totem3d.components.Animator3DComponent;

	public class SteeringBehavior extends RemovableEventDispatcher
	{
		public static const CALCULATE_ACCURACY : int = 2; // Weighted Truncated Running Sum with Prioritization

		public static const CALCULATE_SPEED : int = 1; // Prioritized Dithering

		public static const CALCULATE_SUM : int = 0; //Simply adds up all of the behaviors and truncates them to the max acceleration

		public var behaviors : Array;

		public var calculateMethod : int = CALCULATE_ACCURACY;

		public var neighbors : Vector.<ISpatial2D>;

		private var m_agent : ISpatial2D;

		private var m_force : Vector2D;

		private var m_hasChanged : Boolean;

		private var m_hasGroupBehavior : Boolean;

		private var searchRect : Rectangle;

		private var spatialDatabase : ISpatialManager;

		public function SteeringBehavior( a_agent : ISpatial2D, calculationMethod : int = CALCULATE_ACCURACY )
		{
			this.calculateMethod = calculationMethod;
			m_agent = a_agent;
			m_force = new Vector2D();
			behaviors = [];
			neighbors = new Vector.<ISpatial2D>();

			/*spatialDatabase = a_spatialDatabase;
			spatialDatabase.addItem ( m_agent );*/

			searchRect = new Rectangle();
		}

		public function addBehavior( behavior : ABehavior ) : void
		{
			behaviors.push( behavior );
			behavior.agent = m_agent;
			m_hasChanged = true;

			if ( behavior is IGroupBehavior )
				m_hasGroupBehavior = true;

			searchRect = new Rectangle();
			searchRect.width = m_agent.neighborDistance * 2;
			searchRect.height = m_agent.neighborDistance * 2;

		}

		public function addSpatialDatabase( a_spatialDatabase : ISpatialManager ) : void
		{
			spatialDatabase = a_spatialDatabase;
		}

		public function calculate() : Vector2D
		{
			if ( m_hasChanged )
			{
				sort();
				m_hasChanged = false;
			}
			m_force.x = 0;
			m_force.y = 0;

			if ( m_hasGroupBehavior && spatialDatabase )
			{
				neighbors.length = 0;
				spatialDatabase.getEntitiesOfSameType( neighbors, m_agent );
			}

			switch ( calculateMethod )
			{
				case CALCULATE_SUM:
					runningSum();
					break;
				case CALCULATE_SPEED:
					prioritizedDithering();
					break;
				case CALCULATE_ACCURACY:
					wtrsWithPriorization();
					break;
				default:
					throw new Error( "<SteeringBehavior> Error: '" + calculateMethod + "' is an invalid calculation method." );
			}

			return m_force;
		}

		public function clearBehaviors() : void
		{
			behaviors = [];
			m_hasGroupBehavior = false;
		}

		override public function destroy() : void
		{
			super.destroy();

			spatialDatabase = null;
			
			neighbors.length = 0;
			neighbors = null;

			behaviors = null;
			m_force = null;
			m_agent = null;
		}

		public function getBehavior( behaviorClass : Class ) : ABehavior
		{
			for each ( var behavior : ABehavior in behaviors )
			{
				if ( behavior is behaviorClass )
				{
					return behavior;
				}
			}
			throw new Error( "<SteeringBehavior> Behavior does not exist!" );
		}

		public function getFirstBoidOfType( type : String ) : ISpatial2D
		{
			return spatialDatabase.getFirstBoidOfType( type, m_agent );
		}

		public function getNearestBoids( type : String ) : Vector.<ISpatial2D>
		{
			return null; //spatialDatabase.getNearestEntityOfType( type, m_agent );
		}

		public function removeAllBehaviors() : void
		{
			behaviors.length = 0;
		}

		public function removeBehavior( behavior : Class ) : void
		{
			var behaviorToRemove : ABehavior;

			for ( var i : int = 0; i < behaviors.length; i++ )
			{
				if ( behaviors[ i ] is behavior )
				{
					behaviorToRemove = behaviors[ i ];
					break;
				}
			}

			behaviors.splice( i, 1 );

			if ( m_hasGroupBehavior && behaviorToRemove is IGroupBehavior )
			{
				i = behaviors.length;

				while ( --i >= 0 )
				{
					if ( behaviors[ i ] is IGroupBehavior )
					{
						return;
					}
				}
				m_hasGroupBehavior = false;
			}

		}

		/**
		 * Adds the force to the running total
		 * @param a_runningTotal the total of the steering forces so far
		 * @param a_forceToAdd the next steering force to add
		 * @return Returns false if there is no more force left to use.
		 *
		 */
		private function accumulateForce( a_runningTotal : Vector2D, a_forceToAdd : Vector2D ) : Boolean
		{
			var magnitudeSoFar : Number = a_runningTotal.length;
			var magnitudeRemaining : Number = m_agent.maxAcceleration - magnitudeSoFar;

			if ( magnitudeRemaining <= 0 )
				return false;

			var magnitudeToAdd : Number = a_forceToAdd.length;

			if ( magnitudeToAdd < magnitudeRemaining )
			{
				a_runningTotal.x += a_forceToAdd.x;
				a_runningTotal.y += a_forceToAdd.y;
				return true;
			}
			else
			{
				a_runningTotal.addTo( a_forceToAdd.getNormalized().multipliedBy( magnitudeRemaining ));
				return false;
			}
		}

		private function behaviorsCompare( a : ABehavior, b : ABehavior ) : int
		{
			if ( a.priority < b.priority )
				return 1;

			if ( a.priority == b.priority )
				return 0;
			return -1;
		}

		private function prioritizedDithering() : void
		{
			var i : int = behaviors.length;

			while ( --i >= 0 )
			{
				var behavior : ABehavior = behaviors[ i ];

				if ( Math.random() < behavior.probability )
				{
					m_force.addTo( behavior.calculate().multipliedBy( behavior.weight ));
				}

				if ( !m_force.isZero())
				{
					m_force.truncate( m_agent.maxAcceleration );
					return;
				}
			}
		}

		private function runningSum() : void
		{
			var i : int = behaviors.length;

			while ( --i >= 0 )
			{
				var behavior : ABehavior = behaviors[ i ];
				m_force.addTo( behavior.calculate().multipliedBy( behavior.weight ));
			}

			m_force.truncate( m_agent.maxAcceleration );
		}

		// -- PRIVATE --

		private function sort() : void
		{
			behaviors.sort( behaviorsCompare );
		}

		private function wtrsWithPriorization() : void
		{
			var i : int = behaviors.length;

			while ( --i >= 0 )
			{
				var behavior : ABehavior = behaviors[ i ];

				if ( !accumulateForce( m_force, behavior.calculate().multipliedBy( behavior.weight )))
					return;
			}
		}
	}
}

