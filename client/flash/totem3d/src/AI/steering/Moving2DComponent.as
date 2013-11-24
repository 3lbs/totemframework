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

package AI.steering
{

	import AI.params.MovingParam;

	import flash.utils.Dictionary;

	import totem.math.AABBox;
	import totem.math.MathUtils;
	import totem.math.Matrix2D;
	import totem.math.Vector2D;

	import totem3d.components.spatial.Spatial3DComponent;

	public class Moving2DComponent extends Spatial3DComponent
	{

		public static const BOUNDS_BOUNCE : String = "bounce";

		public static const BOUNDS_NONE : String = "none";

		public static const BOUNDS_WRAP : String = "wrap";

		public static const NAME : String = "moving2dcomponent";

		public var acc : Vector2D; // Keeping this as a public so it can be visible for debug etc

		public var boundsBehavior : String = BOUNDS_BOUNCE; // What to do when this entity passes edges

		public var damping : Number = 1; // Amount to slow down the velocity by each tick

		public var doesRotMatchHeading : Boolean; // Will the rotation be locked to the direction the entity is "heading"

		public var friction : Number = 1; // Amount to slow down velocity when hitting things

		public var heading : Vector2D; // The direction this entity is going

		public var maxTurnRate : Number = 0; // Degrees per second, 0 for unlimited rotation speed

		public var side : Vector2D; // Parallel to heading

		protected var _constantForces : Dictionary;

		protected var _forces : Array;

		protected var _oldVelocity : Vector2D;

		protected var _stepSize : Number;

		protected var newPos : Vector2D = new Vector2D();

		private const BOUNCE_STOP_SPEED : Number = 50;

		private var _maxAcceleration : Number; // Speed per second to accelerate

		private var _maxSpeed : Number = 10; // Max speed per second

		private var _velocity : Vector2D; // Speed per second

		private var _worldBounds : AABBox;

		public function Moving2DComponent( data : MovingParam, name : String = "" )
		{
			super( name || NAME, data );

			// set from data 
			_maxAcceleration = data.maxAccelleration;
			_maxSpeed = data.maxSpeed;
			maxTurnRate = data.maxTurnRate;
			friction = data.friction;
			damping = data.damping;
			doesRotMatchHeading = data.doesRotMatchHeading;
			boundsBehavior = data.boundsBehavior;

			velocity = new Vector2D();
			heading = new Vector2D( 1, 0 );
			side = heading.getPerp();
			_forces = [];
			_constantForces = new Dictionary();
			_oldVelocity = new Vector2D();
			_worldBounds = new AABBox( new Vector2D(), 100, 100 );
			_forces = new Array();
		}

		public function addConstantForce( a_force : Vector2D, a_id : String ) : void
		{
			_constantForces[ a_id ] = a_force;
		}

		public function applyForce( a_force : Vector2D ) : void
		{
			_forces.push( a_force );
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

		override public function onTick() : void
		{
			canDispatch = false;

			setInitialValues( 0 );

			// might move the regulator to here
			calculateForces();

			calculateFinalVelocity();

			updatePosition();

			updateHeading();

			canDispatch = true;
			// update assets
			dispatchUpdate();
			//updateChildren( a_timePassed );
		}

		public function removeForce( a_id : String ) : void
		{
			delete _constantForces[ a_id ];
			_constantForces[ a_id ] = null;
		}

		public function rotateToPosition( a_target : Vector2D ) : void
		{
			rotationY = Math.atan2( a_target.y - y, a_target.x - x );
		}

		override public function setPosition( x : Number, y : Number, z : Number ) : void
		{
			super.setPosition( x, y, z );

			newPos.x = x;
			newPos.y = y;
		}

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

		public function get worldBounds() : AABBox
		{
			return _worldBounds;
		}

		public function set worldBounds( value : AABBox ) : void
		{
			_worldBounds = value;
		}

		protected function bounceOnBounds() : void
		{
			// right wall
			if ( x > worldBounds.width - radius )
			{
				velocity.x *= -1;
				velocity.x *= friction;
				velocity.y *= friction;

				if ( velocity.x <= BOUNCE_STOP_SPEED && velocity.x >= -BOUNCE_STOP_SPEED )
				{
					velocity.x = 0;
				}

				if ( velocity.y <= BOUNCE_STOP_SPEED && velocity.y >= -BOUNCE_STOP_SPEED )
				{
					velocity.y = 0;
				}
				x = worldBounds.width - radius;
			}
			// left wall
			else if ( x < radius )
			{
				velocity.x *= -1;
				velocity.x *= friction;
				velocity.y *= friction;

				if ( velocity.x <= BOUNCE_STOP_SPEED && velocity.x >= -BOUNCE_STOP_SPEED )
				{
					velocity.x = 0;
				}

				if ( velocity.y <= BOUNCE_STOP_SPEED && velocity.y >= -BOUNCE_STOP_SPEED )
				{
					velocity.y = 0;
				}
				x = radius;
			}

			// bottem wall
			if ( y > worldBounds.height - radius )
			{
				velocity.y *= -1;
				velocity.x *= friction;
				velocity.y *= friction;

				if ( velocity.x <= BOUNCE_STOP_SPEED && velocity.x >= -BOUNCE_STOP_SPEED )
				{
					velocity.x = 0;
				}

				if ( velocity.y <= BOUNCE_STOP_SPEED && velocity.y >= -BOUNCE_STOP_SPEED )
				{
					velocity.y = 0;
				}
				y = worldBounds.height - radius;
			}

			// top wall
			else if ( y < radius )
			{
				velocity.y *= -1;
				velocity.x *= friction;
				velocity.y *= friction;

				if ( velocity.x <= BOUNCE_STOP_SPEED && velocity.x >= -BOUNCE_STOP_SPEED )
				{
					velocity.x = 0;
				}

				if ( velocity.y <= BOUNCE_STOP_SPEED && velocity.y >= -BOUNCE_STOP_SPEED )
				{
					velocity.y = 0;
				}
				y = radius;
			}
		}

		protected function calculateFinalVelocity() : void
		{
			if ( maxTurnRate > 0 && _oldVelocity.angleTo( velocity ) > ( maxTurnRate * MathUtils.DEG_TO_RAD ) * _stepSize )
			{
				var mat : Matrix2D = Matrix2D.create();
				mat.rotate((( maxTurnRate * MathUtils.DEG_TO_RAD ) * _stepSize ) * heading.sign( velocity ));
				mat.transformVector( _oldVelocity );
				mat.transformVector( heading );
				velocity.x = _oldVelocity.x;
				velocity.y = _oldVelocity.y;
				mat.dispose();
			}

			velocity.x *= damping;
			velocity.y *= damping;

			velocity.truncate( maxSpeed );
		}

		protected function calculateForces() : void
		{
			acc = new Vector2D();

			var force : Vector2D;
			var i : int = _forces.length;

			while ( --i >= 0 )
			{
				force = _forces[ i ];
				acc.x += force.x;
				acc.y += force.y;
			}

			// was forces == new Array();
			_forces.length = 0;

			for each ( force in _constantForces )
			{
				acc.x += force.x;
				acc.y += force.y;
			}

			velocity.x += acc.x;
			velocity.y += acc.y;
		}

		override protected function onRemove() : void
		{
			_forces = null;
			_constantForces = null;
			_oldVelocity = null;
			velocity = null;
			heading = null;
			side = null;
			super.onRemove();
		}

		// -- PRIVATE --

		protected function setInitialValues( a_timePassed : Number ) : void
		{
			_stepSize = a_timePassed; // * 0.001;
			x = newPos.x;
			y = newPos.y;

			// .. Update bounds ...
			/*bounds.center.x = position.x
			bounds.center.y = position.y;
			bounds.left = bounds.center.x - bounds.halfWidth;
			bounds.right = bounds.center.x + bounds.halfWidth;
			bounds.top = bounds.center.y - bounds.halfHeight;
			bounds.bottom = bounds.center.y + bounds.halfHeight;
			bounds.topLeft.x = bounds.left;
			bounds.topLeft.y = bounds.top;
			bounds.bottomRight.x = bounds.right;
			bounds.bottomRight.y = bounds.bottom;
			bounds.topRight.x = bounds.right;
			bounds.topRight.y = bounds.top;
			bounds.bottomLeft.x = bounds.left;
			bounds.bottomLeft.y = bounds.bottom;*/

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
						rotationY = ang;
					}
					else if (( y < 0 && x < 0 ) || ( y > 0 && x < 0 ))
					{
						rotationY = ang + 3.141592653589793;
					}
					else
					{
						rotationY = ang + 6.283185307179586;
					}
				}
			}
			else
			{
				return;
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
			newPos.x = x;
			newPos.y = y;
		}

		protected function wrapOnBounds() : void
		{
		/*if( actualPos.x > _parent.bounds.width + radius )
		{
			actualPos.x = 0-radius + ( actualPos.x - _parent.bounds.width );
		}
		else if( actualPos.y > _parent.bounds.height+radius )
		{
			actualPos.y = 0-radius + ( actualPos.y - _parent.bounds.height );
		}
		else if( actualPos.x < -radius )
		{
			actualPos.x = _parent.bounds.width+radius + actualPos.x;
		}
		else if( actualPos.y < -radius )
		{
			actualPos.y = _parent.bounds.height+radius + actualPos.y;
		}*/
		}
	}
}

