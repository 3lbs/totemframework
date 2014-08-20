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
	import totem.core.TotemDestroyable;
	import totem.math.MathUtils;
	import totem.math.Vector2D;

	public class DisplayObjectRenderer extends TotemDestroyable implements IDisplay2DRenderer
	{

		protected var _alpha : Number = 1;

		protected var _displayObject : DisplayObject;

		protected var _transformMatrix : Matrix = new Matrix();

		private var _offset : Vector2D = new Vector2D();

		private var _position : Vector2D = new Vector2D();

		private var _positionOffset : Vector2D = new Vector2D();

		private var _rotation : Number = 0;

		private var _scale : Vector2D = new Vector2D( 1, 1);

		private var _scene : DisplayObjectSceneLayer;

		private var _transformDirty : Boolean;

		private var _visible : Boolean = true;

		private var _zIndex : Number = 1;

		public function DisplayObjectRenderer( name : String )
		{
			super( name );
		}

		public function get alpha() : Number
		{
			return _alpha;
		}

		public function set alpha( value : Number ) : void
		{

			if ( value == _alpha )
				return;

			_alpha = value;
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
			_displayObject = value;
		}

		public function get position() : Vector2D
		{
			return _position;
		}

		public function set position( value : Vector2D ) : void
		{
			_position.x = value.x;
			_position.y = value.y;

			updateTransform();
		}

		public function get positionOffset() : Vector2D
		{
			return _positionOffset;
		}

		public function set positionOffset( value : Vector2D ) : void
		{
			_positionOffset.x = value.x;
			_positionOffset.y = value.y;

			updateTransform();
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

		public function setPosition( x : Number, y : Number ) : void
		{
			_position.x = x;
			_position.y = y;

			updateTransform();
		}

		public function setRotation( value : Number ) : void
		{
			 _rotation = value;

			updateTransform();
		}

		public function setScale( _scaleX : Number, _scaleY : Number ) : void
		{

			_scale.x = _scaleX;
			_scale.y = _scaleY;

			updateTransform();
		}

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

			updateTransform();
		}

		public function get zIndex() : Number
		{
			return _zIndex;
		}

		public function set zIndex( value : Number ) : void
		{
			if ( _zIndex == value )
				return;

			_zIndex = value;
		}
	}
}
