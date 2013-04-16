
package totem.components
{

	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	
	import totem.core.time.TickedComponent;

	public class DisplayStarlingComponent extends TickedComponent
	{
		public var snapToNearestPixels : Boolean = true;

		private var _displayObject : DisplayObject;

		private var _scene : DisplayObjectContainer;

		protected var _positionOffset : Point = new Point();

		protected var _position : Point = new Point();

		protected var _inScene : Boolean = false;

		protected var _scale : Point = new Point( 1, 1 );

		protected var _transformDirty : Boolean = true;

		protected var _transformMatrix : Matrix = new Matrix();

		protected var _alpha : Number = 1;

		public function DisplayStarlingComponent( name : String = null )
		{
			super( name );
		}

		public function get displayObject() : DisplayObject
		{
			return _displayObject;
		}

		public function set displayObject( value : DisplayObject ) : void
		{
			_displayObject = value;
		}

		public function get position() : Point
		{
			return _position.clone();
		}

		/**
		 * Position of the renderer in scene space.
		 *
		 * @see worldPosition
		 */
		public function set position( value : Point ) : void
		{
			var posX : Number;
			var posY : Number;

			if ( snapToNearestPixels )
			{
				posX = int( value.x );
				posY = int( value.y );
			}
			else
			{
				posX = value.x;
				posY = value.y;
			}

			if ( posX == _position.x && posY == _position.y )
				return;

			_position.x = posX;
			_position.y = posY;
			_transformDirty = true;
		}

		/**
		 * The x value of our scene space position.
		 */
		public function get x() : Number
		{
			return _position.x;
		}

		public function set x( value : Number ) : void
		{
			var posX : Number;

			if ( snapToNearestPixels )
			{
				posX = int( value );
			}
			else
			{
				posX = value;
			}

			if ( posX == _position.x )
				return;

			_position.x = posX;
			_transformDirty = true;
		}

		/**
		 * The y component of our scene space position. Used for sorting.
		 */
		public function get y() : Number
		{
			return _position.y;
		}

		/**
		 *
		 * @param value
		 *
		 */
		public function set y( value : Number ) : void
		{
			var posY : Number;

			if ( snapToNearestPixels )
			{
				posY = int( value );
			}
			else
			{
				posY = value;
			}

			if ( posY == _position.y )
				return;

			_position.y = posY;
			_transformDirty = true;
		}

		public function get alpha() : Number
		{
			return _alpha;
		}

		/**
		 * Transparency, 0 being completely transparent and 1 being opaque.
		 */
		public function set alpha( value : Number ) : void
		{
			if ( value == _alpha )
				return;

			_alpha = value;
			_transformDirty = true;
		}

		public function get scale() : Point
		{
			return _scale.clone();
		}

		/**
		 * You can scale things on the X and Y axes.
		 */
		public function set scale( value : Point ) : void
		{
			if ( value.x == _scale.x && value.y == _scale.y )
				return;

			_scale.x = value.x;
			_scale.y = value.y;
			_transformDirty = true;
		}

		override protected function onAdd() : void
		{
			super.onAdd();

			addToScene();

			// Make sure we start with a correct transform.
			updateTransform();
		}

		override protected function onRemove() : void
		{
			super.onRemove();

			// Remove ourselves from the scene when we are removed.
			removeFromScene();
		}

		protected function removeFromScene() : void
		{
			if ( _scene && _displayObject && _inScene )
			{
				_scene.removeChild( _displayObject );
				_inScene = true;
			}
		}

		protected function addToScene() : void
		{
			if ( _scene && _displayObject && !_inScene )
			{
				_scene.addChild( _displayObject );
				_inScene = false;
			}
		}

		override public function onTick() : void
		{
			
			if ( _transformDirty )
				updateTransform();
		}

		public function get positionOffset() : Point
		{
			return _positionOffset.clone();
		}

		/**
		 * Sets a position offset that will offset the sprite.
		 *
		 * Please note: This is unaffected by rotation.
		 */
		public function set positionOffset( value : Point ) : void
		{

			if ( value.equals( _positionOffset ))
				return;

			_positionOffset.x = value.x;
			_positionOffset.y = value.y;
			_transformDirty = true;
		}

		/**
		 * Update the object's transform based on its current state. Normally
		 * called automatically, but in some cases you might have to force it
		 * to update immediately.
		 * @param updateProps Read fresh values from any mapped properties.
		 */
		public function updateTransform() : void
		{
			if ( !displayObject )
				return;

			_transformMatrix.identity();
			//_transformMatrix.scale( tmpScaleX, tmpScaleY );
			//_transformMatrix.translate( -_registrationPoint.x * tmpScaleX, -_registrationPoint.y * tmpScaleY );
			//_transformMatrix.rotate( PBUtil.getRadiansFromDegrees( _rotation ) + _rotationOffset );
			_transformMatrix.translate( _position.x + _positionOffset.x, _position.y + _positionOffset.y );

			displayObject.transformationMatrix = _transformMatrix;
			displayObject.visible = ( alpha > 0 );

			_transformDirty = false;
		}
		
		override public function destroy():void
		{
			super.destroy();
			
			
			removeFromScene();
			
			_displayObject = null;
	
			_scene = null;
		}
	}
}
