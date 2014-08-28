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

package totem.components.display.starling
{

	import flash.geom.Matrix;

	import starling.display.DisplayObject;

	import totem.components.display.DisplayObjectSceneLayer;
	import totem.components.display.IDisplay2DRenderer;
	import totem.components.spatial.ISpatialObserver;
	import totem.core.TotemEntity;
	import totem.core.time.TickedComponent;
	import totem.math.MathUtils;
	import totem.math.Vector2D;

	public class DisplayObjectComponentRenderer extends TickedComponent implements IDisplay2DRenderer, ISpatialObserver
	{

		public static const NAME : String = "DisplayStarlingRenderer";

		public static function addToSceneLayer( entity : TotemEntity, sceneLayer : DisplayObjectSceneLayer, zIndex : int = -5 ) : void
		{
			var displayRenderer : IDisplay2DRenderer = entity.getComponent( IDisplay2DRenderer );

			if ( zIndex > -5 )
			{
				DisplayObjectComponentRenderer( displayRenderer ).zIndex = zIndex;
			}

			displayRenderer.scene = sceneLayer;
		}

		public var snapToNearestPixels : Boolean = true;

		protected var _alpha : Number = 1;

		protected var _displayObject : DisplayObject;

		protected var _offset : Vector2D = new Vector2D();

		protected var _position : Vector2D = new Vector2D();

		protected var _positionOffset : Vector2D = new Vector2D();

		protected var _scale : Vector2D = new Vector2D( 1, 1 );

		protected var _transformMatrix : Matrix = new Matrix();

		private var _rotation : Number = 0;

		private var _scene : DisplayObjectSceneLayer;

		private var _transformDirty : Boolean = true;

		private var _visible : Boolean = true;

		private var _zIndex : Number;

		private var _zIndexDirty : Boolean;

		public function DisplayObjectComponentRenderer( name : String = null )
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

			scene = null;
			_displayObject = null;
		}

		public function get displayObject() : DisplayObject
		{
			return _displayObject;
		}

		public function set displayObject( value : DisplayObject ) : void
		{

			if ( _scene && _displayObject )
			{
				_scene.remove( this );
			}

			_displayObject = value;

			if ( _scene && _displayObject )
			{
				_scene.add( this );
			}

			_transformDirty = true;

			if ( getName() && owner && owner.getName())
				_displayObject.name = owner.getName() + "." + getName();

		}

		public function get offset() : Vector2D
		{
			return _offset;
		}

		public function set offset( value : Vector2D ) : void
		{
			
			if ( value.equal( _offset ))
				return;
			
			
			if ( getName() == "food" )
			{
				trace( _offset );
				trace( "break" );
			}
			
			_offset.x = value.x;
			_offset.y = value.y;
			_transformDirty = true;
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
			setPosition( value.x, value.y );
		}

		public function get positionOffset() : Vector2D
		{
			return _positionOffset;
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

			
			if ( getName() == "food" )
			{
				trace( _positionOffset );
				trace( "break" );
			}

			_positionOffset.x = value.x;
			_positionOffset.y = value.y;
			_transformDirty = true;
		}

		public function get scale() : Vector2D
		{
			return _scale;
		}

		/**
		 * You can scale things on the X and Y axes.
		 */
		public function set scale( value : Vector2D ) : void
		{
			setScale( value.x, value.y );
		}

		public function set scene( value : DisplayObjectSceneLayer ) : void
		{
			// Remove from old scene if appropriate.
			if ( _scene && _displayObject )
			{
				_scene.remove( this );
			}

			_scene = value;

			// And add to new scene (clearing dirty state).
			if ( _scene && _displayObject )
			{
				_scene.add( this );
			}
		}

		public function setOffset( value : Vector2D ) : void
		{
			if ( value.equal( _positionOffset ))
				return;

			_positionOffset.x = value.x;
			_positionOffset.y = value.y;
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
			//updateTransform();
		}

		public function setRotation( value : Number ) : void
		{
			if ( value == _rotation )
				return;

			_rotation = value;
			_transformDirty = true;
		}

		public function setScale( _scaleX : Number, _scaleY : Number ) : void
		{
			if ( _scaleX == _scale.x && _scaleY == _scale.y )
				return;

			_scale.x = _scaleX;
			_scale.y = _scaleY;
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
			_transformMatrix.scale( _scale.x, _scale.y );
			//_transformMatrix.translate( -_registrationPoint.x * tmpScaleX, -_registrationPoint.y * tmpScaleY );
			//_transformMatrix.rotate( PBUtil.getRadiansFromDegrees( _rotation ) + _rotationOffset );

			_transformMatrix.rotate( _rotation * MathUtils.DEG_TO_RAD );
			_transformMatrix.translate( _position.x + _positionOffset.x + _offset.x, _position.y + _positionOffset.y + _offset.y );

			displayObject.transformationMatrix = _transformMatrix;
			displayObject.visible = _visible;
			displayObject.alpha = alpha;

			if ( getName() == "food" )
			{
				trace( _positionOffset );
				trace( "break" );
			}

			_transformDirty = false;
		}

		public function get visible() : Boolean
		{
			return _visible;
		}

		public function set visible( value : Boolean ) : void
		{
			_visible = value;

			alpha = ( !_visible ) ? 0 : 1;

			if ( displayObject )
			{
				displayObject.visible = _visible;
			}
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

		public function get zIndex() : Number
		{
			return _zIndex;
		}

		/**
		 * By default, layers are sorted based on the z-index, from small
		 * to large.
		 * @param value Z-index to set.
		 */
		public function set zIndex( value : Number ) : void
		{
			if ( _zIndex == value )
				return;

			_zIndex = value;
			_zIndexDirty = true;
		}

		override protected function onActivate() : void
		{
			super.onActivate();
			scene = _scene;
			visible = true;
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
			destroy();
		}

		override protected function onRetire() : void
		{
			super.onRetire();

			scene = null;
		}
	}
}
