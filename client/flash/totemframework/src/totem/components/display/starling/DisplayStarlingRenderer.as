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

package totem.components.display.starling
{

	import flash.geom.Matrix;

	import starling.display.DisplayObject;

	import totem.components.display.IDisplay2DRenderer;
	import totem.components.display.ISceneRenderer;
	import totem.core.time.TickedComponent;
	import totem.math.Vector2D;

	public class DisplayStarlingRenderer extends TickedComponent implements IDisplay2DRenderer, ISceneRenderer
	{

		public static const NAME : String = "DisplayStarlingRenderer";

		public var snapToNearestPixels : Boolean = true;

		protected var _alpha : Number = 1;

		protected var _inScene : Boolean = false;

		protected var _lastLayerIndex : int = -1;

		protected var _layerIndex : int = 0;

		protected var _layerIndexDirty : Boolean = true;

		protected var _position : Vector2D = new Vector2D();

		protected var _positionOffset : Vector2D = new Vector2D();

		protected var _scale : Vector2D = new Vector2D( 1, 1 );

		protected var _transformMatrix : Matrix = new Matrix();

		private var _displayObject : DisplayObject;

		private var _transformDirty : Boolean = true;

		private var _zIndex : int;

		private var _zIndexDirty : Boolean;

		public function DisplayStarlingRenderer( name : String = null )
		{
			super( name || NAME );
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

		override public function destroy() : void
		{
			super.destroy();

			//removeFromScene();

			_displayObject = null;
		}

		public function get displayObject() : DisplayObject
		{
			return _displayObject;
		}

		public function set displayObject( value : DisplayObject ) : void
		{
			//removeFromScene();

			_displayObject = value;

			if ( getName() && owner && owner.getName())
				_displayObject.name = owner.getName() + "." + getName();

			// Add new scene.
			//addToScene();
		}

		public function get layerIndex() : int
		{
			return _layerIndex;
		}

		/**
		 * In what layer of the scene is this renderer drawn?
		 */
		public function set layerIndex( value : int ) : void
		{
			if ( _layerIndex == value )
				return;

			_layerIndex = value;
		}

		override public function onTick() : void
		{
			if ( _transformDirty )
			{
				updateTransform();
			}
		}

		public function get position() : Vector2D
		{
			return _position;
		}

		/**
		 * Position of the renderer in scene space.
		 *
		 * @see worldPosition
		 */
		public function set position( value : Vector2D ) : void
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
			updateTransform();
		}

		public function get positionOffset() : Vector2D
		{
			return _positionOffset.clone();
		}

		/**
		 * Sets a position offset that will offset the sprite.
		 *
		 * Please note: This is unaffected by rotation.
		 */
		public function set positionOffset( value : Vector2D ) : void
		{

			if ( value.equal( _positionOffset ))
				return;

			_positionOffset.x = value.x;
			_positionOffset.y = value.y;
			_transformDirty = true;
		}

		public function get scale() : Vector2D
		{
			return _scale.clone();
		}

		/**
		 * You can scale things on the X and Y axes.
		 */
		public function set scale( value : Vector2D ) : void
		{
			if ( value.x == _scale.x && value.y == _scale.y )
				return;

			_scale.x = value.x;
			_scale.y = value.y;
			_transformDirty = true;
		}

		public function setPosition( x : Number, y : Number ) : void
		{
			var posX : Number;
			var posY : Number;

			if ( snapToNearestPixels )
			{
				posX = int( x );
				posY = int( y );
			}
			else
			{
				posX = x;
				posY = y;
			}

			if ( posX == _position.x && posY == _position.y )
				return;

			_position.x = posX;
			_position.y = posY;
			_transformDirty = true;
			updateTransform();
		}

		public function setRotation( value : Number ) : void
		{

		}

		public function setScale( _scaleX : Number, _scaleY : Number ) : void
		{

		}

		public function translateX( value : Number ) : void
		{

		}

		public function translateY( value : Number ) : void
		{

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
			displayObject.alpha = alpha;

			_transformDirty = false;
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

		public function get zIndex() : int
		{
			return _zIndex;
		}

		/**
		 * By default, layers are sorted based on the z-index, from small
		 * to large.
		 * @param value Z-index to set.
		 */
		public function set zIndex( value : int ) : void
		{
			if ( _zIndex == value )
				return;

			_zIndex = value;
			_zIndexDirty = true;
		}

		override protected function onActivate() : void
		{
			super.onActivate();
		}

		override protected function onAdd() : void
		{
			super.onAdd();

			// Make sure we start with a correct transform.
			updateTransform();
		}

		override protected function onRemove() : void
		{
			super.onRemove();

		}

		override protected function onRetire() : void
		{
			super.onRetire();

		}
	}
}