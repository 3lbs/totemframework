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

	import AI.params.BoidParam;
	import AI.steering.SteeringBehavior;
	import AI.steering.behaviors.ABehavior;
	
	import totem.components.spatial.ISpatialManager;
	import totem.components.motion.Moving2DComponent;
	import totem.math.Vector2D;
	
	import totem3d.components.Animator3DComponent;

	public class Boid2DComponent extends Moving2DComponent implements IBoid
	{
		public static const NAME : String = "BoidComponent";

		[Inject]
		public var animatorComponent : Animator3DComponent;

		public var steering : SteeringBehavior;

		private var _neighborDistance : Number = 0;

		public function Boid2DComponent( boidParam : BoidParam = null, name : String = "" )
		{
			super( boidParam, name || NAME );

			//steering = new SteeringBehavior( this, null );
		}
		
		public function addBehavior( behavior : ABehavior ) : void
		{
			if ( steering )
				steering.addBehavior( behavior );
		}

		override public function addSpatialManager( spatialDatabase : ISpatialManager ) : void
		{
			super.addSpatialManager( spatialDatabase );

			//steering.addSpatialDatabase( spatialDatabase );
		}

		public function calculateTimeToReachTarget( position : Vector2D ) : int
		{
			return Number.POSITIVE_INFINITY;
		}

		public function isAtPosition( position : Vector2D ) : Boolean
		{
			return position.isAtPositon( position, 10 );
		}

		public function get neighborDistance() : Number
		{
			return _neighborDistance;
		}

		public function set neighborDistance( value : Number ) : void
		{
			_neighborDistance = value;
		}

		override public function onTick() : void
		{

			canDispatch = false;

			setInitialValues( 1 );

			calculateForces()

			calculateSteering();

			calculateFinalVelocity();

			updateHeading();

			updatePosition();

			canDispatch = true;

			// update assets
			dispatchUpdate();
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

		}

		override protected function onRemove() : void
		{
			super.onRemove();

			steering.destroy();
			steering = null;

		}
	}
}

