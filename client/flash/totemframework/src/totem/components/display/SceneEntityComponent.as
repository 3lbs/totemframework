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

package totem.components.display
{

	import flash.geom.Matrix;

	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;

	import totem.core.TotemEntity;
	import totem.core.time.TickedComponent;
	import totem.data.type.Point2d;
	import totem.math.Vector2D;

	public class SceneEntityComponent extends TickedComponent
	{
		public static const NAME : String = "SceneEntityComponent";

		public static function addToScene( entity : TotemEntity, scene : DisplayObjectContainer ) : void
		{
			var displayComponment : SceneEntityComponent = entity.getComponent( SceneEntityComponent ) as SceneEntityComponent;

			displayComponment.scene = scene;
		}

		public var snapToNearestPixels : Boolean = true;

		protected var _position : Vector2D = new Vector2D();

		protected var _positionOffset : Vector2D = new Vector2D();

		protected var _scene : DisplayObjectContainer;

		protected var _transformMatrix : Matrix = new Matrix();

		private var _alpha : Number;

		private var _inScene : Boolean;

		private var _isDirty : Boolean;

		private var _scaleX : Number;

		private var _scaleY : Number;

		private var _transformDirty : Boolean;

		private var _x : Number;

		private var _y : Number;

		private var _zIndex : int;

		private var _zIndexDirty : Boolean;

		private var rendererList : Vector.<ISceneRenderer> = new Vector.<ISceneRenderer>();

		private var rootSprite : Sprite = new Sprite();

		public function SceneEntityComponent( name : String = "" )
		{
			super( name || NAME );
		}

		public function addDisplayRenderer( renderer : ISceneRenderer ) : void
		{

			if ( rendererList.indexOf( renderer ) > -1 )
				return;

			rendererList.push( renderer );

			rootSprite.addChild( renderer.displayObject );

			_zIndexDirty = true;
		}

		public function get alpha() : Number
		{
			return _alpha;
		}

		public function set alpha( value : Number ) : void
		{
			if ( value != _alpha )
			{
				_alpha = value;
			}
		}

		public function get isDirty() : Boolean
		{
			return _isDirty;
		}

		public function set isDirty( value : Boolean ) : void
		{
			_isDirty = value;
		}

		override public function onTick() : void
		{
			if ( _transformDirty )
			{
				updateTransform();

				_transformDirty = false;
			}

			if ( _zIndexDirty )
			{
				sortRenderers();

				_zIndexDirty = false;
			}
		}

		public function set position( value : Point2d ) : void
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

		public function removeDisplayRenderer( renderer : ISceneRenderer ) : void
		{
			var idx : int = rendererList.indexOf( renderer );

			if ( idx > -1 )
			{
				rendererList.splice( idx, 1 );

				if ( renderer.displayObject.parent )
					renderer.displayObject.parent.removeChild( renderer.displayObject );

				_isDirty = true;
				_zIndexDirty = true;
			}
		}

		public function get scaleX() : Number
		{
			return _scaleX;
		}

		public function set scaleX( value : Number ) : void
		{
			if ( value == _scaleX )
				return;

			_scaleX = value;
			_transformDirty = true;
		}

		public function get scaleY() : Number
		{
			return _scaleY;
		}

		public function set scaleY( value : Number ) : void
		{
			if ( value == _scaleY )
				return;

			_scaleY = value;
			_transformDirty = true;
		}

		public function set scene( value : DisplayObjectContainer ) : void
		{
			// Remove from old scene if appropriate.
			removeFromScene();

			_scene = value;

			// And add to new scene (clearing dirty state).
			addToScene();
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
		}

		public function updateTransform( updateProps : Boolean = false ) : void
		{

			_transformMatrix.identity();
			//_transformMatrix.scale( tmpScaleX, tmpScaleY );
			//_transformMatrix.translate( -_registrationPoint.x * tmpScaleX, -_registrationPoint.y * tmpScaleY );
			//_transformMatrix.rotate( PBUtil.getRadiansFromDegrees( _rotation ) + _rotationOffset );
			//_transformMatrix.translate( _position.x + _positionOffset.x, _position.y + _positionOffset.y );

			//rootSprite.transformationMatrix = _transformMatrix;
			//rootSprite.visible = ( alpha > 0 );
			//rootSprite.alpha = alpha;

			
			rootSprite.x = _position.x;
			rootSprite.y = _position.y;
			
			_transformDirty = false;
		}

		public function get x() : Number
		{
			return _x;
		}

		public function set x( value : Number ) : void
		{
			if ( value == _x )
				return;

			_x = value;
			_transformDirty = true;
		}

		public function get y() : Number
		{
			return _y;
		}

		public function set y( value : Number ) : void
		{
			if ( value == _y )
				return;

			_y = value;
			_transformDirty = true;
		}

		public function get zIndex() : int
		{
			return _zIndex;
		}

		public function set zIndex( value : int ) : void
		{
			if ( _zIndex == value )
				return;

			_zIndex = value;
			_zIndexDirty = true;
		}

		protected function addToScene() : void
		{
			if ( _scene && !_inScene )
			{
				_scene.addChild( rootSprite );
				_inScene = true;

				_transformDirty = true;
			}
		}

		override protected function onActivate() : void
		{
			super.onActivate();
			addToScene();
		}

		override protected function onAdd() : void
		{
			super.onAdd();

		}

		override protected function onRemove() : void
		{
			super.onRemove();

			rendererList.length = 0;
			rendererList = null;

			removeFromScene();
		}

		override protected function onRetire() : void
		{
			super.onRetire();

			removeFromScene();
		}

		protected function removeFromScene() : void
		{
			if ( _scene && _inScene )
			{
				_scene.removeChild( rootSprite );
				_inScene = false;
			}
		}

		private function sortFunction( objx : ISceneRenderer, objy : ISceneRenderer ) : Number
		{
			if ( objx.zIndex > objy.zIndex )
			{
				return 1;
			}
			else if ( objx.zIndex < objy.zIndex )
			{
				return -1;
			}
			return 0;
		}

		private function sortRenderers() : void
		{
			rendererList.sort( sortFunction );

			var layerIndex : int = 0;
			var scene : ISceneRenderer;

			for ( var layer : int = 0; layer < rendererList.length; layer++ )
			{
				scene = rendererList[ layer ];
				rootSprite.setChildIndex( scene.displayObject, layerIndex );
				layerIndex++;
			}
		}
	}
}
