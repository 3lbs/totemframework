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
//   3lbs Copyright 2014 
//   For more information see http://www.3lbs.com 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package totem.components.motion
{

	import totem.components.spatial.SpatialComponent;
	import totem.core.time.TimeManager;
	import totem.math.Vector2D;

	public class MovingComponent extends SpatialComponent implements IMovingObject
	{

		public static const NAME : String = "moving2dcomponent";

		//public var acc : Vector2D; // Keeping this as a public so it can be visible for debug etc

		public var damping : Number = 1; // Amount to slow down the velocity by each tick

		public var doesRotMatchHeading : Boolean; // Will the rotation be locked to the direction the entity is "heading"

		public var friction : Number = 1; // Amount to slow down velocity when hitting things

		public var heading : Vector2D; // The direction this entity is going

		public var maxTurnRate : Number = 0; // Degrees per second, 0 for unlimited rotation speed

		public var radius : Number = 1;

		public var side : Vector2D; // Parallel to heading

		protected var _oldVelocity : Vector2D;

		protected var _stepSize : Number;

		//protected var newPos : Vector2D = new Vector2D();

		private var _maxAcceleration : Number = 5; // Speed per second to accelerate

		private var _maxSpeed : Number = 15; // Max speed per second

		private var _neighborDistance : Number = 0;

		private var _velocity : Vector2D; // Speed per second

		public function MovingComponent( data : MovingParam, name : String = "" )
		{
			super( name || NAME, data );

			// set from data 

			if ( data )
			{
				//_maxAcceleration = data.maxAccelleration;
				//_maxSpeed = data.maxSpeed;
				//maxTurnRate = data.maxTurnRate;
				//friction = data.friction;
				//damping = data.damping;
				doesRotMatchHeading = data.doesRotMatchHeading;
			}

			velocity = new Vector2D();
			heading = new Vector2D( 1, 0 );
			side = heading.getPerp();
			_oldVelocity = new Vector2D();
		}

		public function get maxAcceleration() : Number
		{
			return _maxAcceleration;
		}

		public function set maxAcceleration( value : Number ) : void
		{
			_maxAcceleration = value;
		}

		public function get maxSpeed() : Number
		{
			return _maxSpeed;
		}

		public function set maxSpeed( value : Number ) : void
		{
			_maxSpeed = value;
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
			setInitialValues();

			calculateFinalVelocity();

			updatePosition();

			updateHeading();

			dispatchUpdate();
		}

		public function rotateToPosition( a_target : Vector2D ) : void
		{
			rotation = Math.atan2( a_target.y - y, a_target.x - x );
		}

		/*override public function setPosition( x : Number, y : Number ) : void
		{
			super.setPosition( x, y );

			newPos.x = x;
			newPos.y = y;
		}*/

		/**
		 * This should never be set externally, unless there is a good reason...
		 */
		public function get velocity() : Vector2D
		{
			return _velocity;
		}

		/**
		 * @private
		 */
		public function set velocity( value : Vector2D ) : void
		{
			_velocity = value;
		}

		protected function calculateFinalVelocity() : void
		{

			/// this is rotation
			/*if ( maxTurnRate > 0 && _oldVelocity.angleTo( velocity ) > ( maxTurnRate * MathUtils.DEG_TO_RAD ) * _stepSize )
			{
				var mat : Matrix2D = Matrix2D.create();
				mat.rotate((( maxTurnRate * MathUtils.DEG_TO_RAD ) * _stepSize ) * heading.sign( velocity ));
				mat.transformVector( _oldVelocity );
				mat.transformVector( heading );
				velocity.x = _oldVelocity.x;
				velocity.y = _oldVelocity.y;
				mat.dispose();
			}*/

			/*velocity.x *= damping;
			velocity.y *= damping;*/

			velocity.truncate( maxSpeed );
		}

		override protected function onRemove() : void
		{
			_oldVelocity = null;
			velocity = null;
			heading = null;
			side = null;
			super.onRemove();
		}

		protected function setInitialValues() : void
		{
			_stepSize = TimeManager.TICK_RATE; //.06; // * 0.001;
			_position.x = _x;
			_position.y = _y;

			//trace( TimeManager.TICK_RATE, TimeManager.TICK_RATE_MS );
			_oldVelocity.x = velocity.x;
			_oldVelocity.y = velocity.y;
		}

		protected function updateHeading() : void
		{
			if (( velocity.x * velocity.x + velocity.y * velocity.y ) > 0.001 )
			{
				heading = velocity.getNormalized();
				side.x = -heading.y;
				side.y = heading.x;

				if ( doesRotMatchHeading )
				{
					var x : Number = heading.x;
					var y : Number = heading.y;
					var ang : Number = Math.atan( y / x );

					if ( y < 0 && x > 0 )
					{
						rotation = ang;
					}
					else if (( y < 0 && x < 0 ) || ( y > 0 && x < 0 ))
					{
						rotation = ang + 3.141592653589793;
					}
					else
					{
						rotation = ang + 6.283185307179586;
					}
				}
			}
			else
			{
				velocity.x = 0;
				velocity.y = 0;
			}
		}

		protected function updatePosition() : void
		{
			//trace( "<MovingEntity> Acc: " + acc );
			var dx : Number = velocity.x * _stepSize;
			var dy : Number = velocity.y * _stepSize;

			x += dx;
			y += dy;

		/*switch ( boundsBehavior )
		{
			case BOUNDS_WRAP:
				wrapOnBounds();
				break;
			case BOUNDS_BOUNCE:
				bounceOnBounds();
				break;
		}*/

			// need to update position here
			//newPos.x = x;
			//newPos.y = y;
		}
	}
}

