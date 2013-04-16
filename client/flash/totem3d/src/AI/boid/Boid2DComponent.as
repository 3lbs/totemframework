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

package AI.boid
{

	import flash.utils.Dictionary;
	
	import AI.spatial.BoidSpatialManager;
	import AI.steering.Moving2DComponent;
	import AI.steering.SteeringBehavior;
	import AI.steering.behaviors.ABehavior;
	
	import totem.core.params.TransformParam;
	import totem.core.time.TickRegulator;
	import totem.math.Vector2D;

	public class Boid2DComponent extends Moving2DComponent implements IBoid
	{
		public static const NAME : String = "BoidComponent";

		public var spatialManager : BoidSpatialManager;

		public var steering : SteeringBehavior;

		public var type : String;

		private var _neighborDistance : Number = 0;

		private var _node : String;

		private var _parentNode : String;

		private var properties : Dictionary;

		private var testActualPos : Vector2D = new Vector2D();

		public function Boid2DComponent( data : TransformParam )
		{
			super( data );

			steering = new SteeringBehavior( this );

			properties = new Dictionary();
		}

		// change this
		public function get actualPos() : Vector2D
		{
			testActualPos.x = x;
			testActualPos.y = y;

			return testActualPos;
		}

		public function addBehavior( behavior : ABehavior ) : void
		{
			steering.addBehavior( behavior );
		}

		public function addSpatialManager( a_spatialDatabase : BoidSpatialManager ) : void
		{
			steering.addSpatialDatabase( a_spatialDatabase );
		}

		public function get neighborDistance() : Number
		{
			return _neighborDistance;
		}

		public function set neighborDistance( value : Number ) : void
		{
			_neighborDistance = value;
		}

		public function get node() : String
		{
			return _node;
		}

		public function set node( value : String ) : void
		{
			_node = value;
		}

		override public function onTick() : void
		{
			///  boid might should extend spatial!~

			return;

			var elaspedTime : Number = tickRegulator.isReady();

			if ( elaspedTime != 0 )
			{
				canDispatch = false;

				setInitialValues( elaspedTime );

				calculateForces()

				// you might just want to wrap this with the regulater?
				calculateSteering();

				calculateFinalVelocity();

				updateHeading();

				updatePosition();

				canDispatch = true;

				// update assets
				dispatchUpdate();
			}
		}

		public function get parentNode() : String
		{
			return _parentNode;
		}

		public function set parentNode( value : String ) : void
		{
			_parentNode = value;
		}

		public function removeAllBehaviors() : void
		{
			steering.removeAllBehaviors();
		}

		public function removeBehavior( classType : Class ) : void
		{
			steering.removeBehavior( classType );
		}

		protected function calculateSteering() : void
		{
			acc = steering.calculate();
			velocity.x += acc.x;
			velocity.y += acc.y;
		}

		override protected function onAdd() : void
		{
			super.onAdd();

			tickRegulator = new TickRegulator( TickRegulator.NO_FREQUENCY );
		}

		override protected function onRemove() : void
		{
			super.onRemove();

			steering.destroy();
			steering = null;

		}
	}
}

