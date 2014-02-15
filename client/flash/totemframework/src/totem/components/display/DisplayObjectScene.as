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

package totem.components.display
{

	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import ladydebug.Logger;

	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import starling.display.Sprite;

	import totem.core.time.ITicked;
	import totem.data.type.Point2d;
	import totem.display.layout.starling.TStarlingSprite;
	import totem.math.Vector2D;
	import totem.utils.TotemUtil;

	public class DisplayObjectScene extends TStarlingSprite implements ITicked
	{
		public static var NAME : String = "DisplayObjectScene";

		public var maxZoom : Number = 1;

		public var minZoom : Number = .01;

		public var sceneViewDispatcher : ISignal = new Signal( Rectangle );

		public var trackObject : IDisplay2DRenderer;

		public var trackOffset : Point = new Point( 0, 0 );

		public var updatePositionDispatcher : ISignal = new Signal( Number, Number, Rectangle );

		protected var _rootSprite : Sprite = new Sprite();

		protected var _rootTransform : Matrix = new Matrix();

		protected var _sceneAlignment : SceneAlignment = SceneAlignment.DEFAULT_ALIGNMENT;

		protected var _tempPoint : Point = new Point();

		protected var _trackLimitRectangle : Rectangle = null;

		protected var _transformDirty : Boolean = true;

		protected var _zoom : Number = 1;

		private var _height : Number;

		private var _layers : Vector.<DisplayObjectSceneLayer> = new Vector.<DisplayObjectSceneLayer>();

		private var _rootPosition : Vector2D = new Vector2D();

		private var _sceneViewBoundsCache : Rectangle = new Rectangle();

		private var _width : Number;

		private var centerVector : Vector2D;

		private var centeredLimitBounds : Rectangle = new Rectangle();

		/**
		 *
		 *
		 */
		public function DisplayObjectScene()
		{
			super();
			addChild( _rootSprite );
			_rootSprite.touchable = true;
		}

		public function addLayer( layer : DisplayObjectSceneLayer ) : DisplayObjectSceneLayer
		{
			_layers.push( layer );

			_rootSprite.addChild( layer );

			layer.parentSprite = _rootSprite;

			layer.touchable = false;

			sortLayers();

			_transformDirty = true;

			return layer;
		}

		/**
		 * @inheritDoc
		 */
		public function centerOnPt( pt : Vector2D ) : void
		{

			SceneAlignment.calculate( _tempPoint, sceneAlignment, _width / zoom, _height / zoom );

			centerVector ||= new Vector2D();

			centerVector.x = -pt.x - _tempPoint.x;
			centerVector.y = -pt.y - _tempPoint.y;

			centerVector.x += ( _tempPoint.x / zoom );
			centerVector.y += ( _tempPoint.x / zoom );

			position = centerVector;

			_transformDirty = true;

		}

		override public function destroy() : void
		{
			super.destroy();
		}

		public function generateLayer( name : String, layer : Number = 0 ) : DisplayObjectSceneLayer
		{
			return addLayer( new DisplayObjectSceneLayer( name, layer ));
		}

		public function getLayerByDepth( d : int ) : DisplayObjectSceneLayer
		{
			for ( var i : int = 0; i < _layers.length; ++i )
			{
				if ( _layers[ i ].depth == d )
				{
					return _layers[ i ];
				}
			}

			return null;
		}

		public function getLayerByName( n : String ) : DisplayObjectSceneLayer
		{

			for ( var i : int = 0; i < _layers.length; ++i )
			{
				if ( _layers[ i ].name == n )
				{
					return _layers[ i ];
				}
			}
			return null;
		}

		public function hasLayer( layers : DisplayObjectSceneLayer ) : Boolean
		{
			return ( _layers.indexOf( layers ) > -1 );
		}

		public function hasLayerByName( name : String ) : Boolean
		{

			for ( var i : int = 0; i < _layers.length; ++i )
			{
				if ( _layers[ i ].name == name )
				{
					return true;
				}
			}

			return false;
		}

		public function localToGrid( pt : Point2d, resultPt : Point2d = null ) : Point2d
		{

			resultPt ||= Point2d.create();

			_rootSprite.localToGlobal( pt, resultPt );

			return mainContainer.globalToLocal( resultPt, resultPt ) as Point2d;
		}

		public function get mainContainer() : Sprite
		{
			return _rootSprite;
		}

		public function onTick() : void
		{

			if ( !parent )
			{
				Logger.warn( this, "updateTransform", "sceneView is null, so we aren't rendering." );
				return;
			}

			// Update our state based on the tracked object, if any.
			if ( trackObject )
			{
				position = new Vector2D( -( trackObject.position.x + trackOffset.x ), -( trackObject.position.y + trackOffset.y ));
			}

			// Apply limit to camera movement.
			if ( trackLimitRectangle != null )
			{

				//centeredLimitBounds = new Rectangle( trackLimitRectangle.x + _width * 0.5, trackLimitRectangle.y + _height * 0.5, trackLimitRectangle.width - _width, trackLimitRectangle.height - _height );

				centeredLimitBounds.x = trackLimitRectangle.x + _width * 0.5;
				centeredLimitBounds.y = trackLimitRectangle.y + _height * 0.5;
				centeredLimitBounds.width = trackLimitRectangle.width - _width;
				centeredLimitBounds.height = trackLimitRectangle.height - _height;

				position = new Vector2D( TotemUtil.clamp( position.x, -centeredLimitBounds.right, -centeredLimitBounds.left ), TotemUtil.clamp( position.y, -centeredLimitBounds.bottom, -centeredLimitBounds.top ));
			}

			updateTransform();

		/*trace( "noid", sceneViewBounds );
		trace( "pos", _rootPosition.x, _rootPosition.y );
		( setScenePosition( sceneViewBounds.x, sceneViewBounds.y ) );*/

		}

		public function panBy( deltaX : Number, deltaY : Number ) : void
		{

			if ( deltaX == 0 && deltaY == 0 )
				return;

			_rootPosition.x -= int( deltaX / _zoom );
			_rootPosition.y -= int( deltaY / _zoom );
			_transformDirty = true;

		}

		/**
		 * @inheritDoc
		 */
		public function panTo( xTo : Number, yTo : Number ) : void
		{
			SceneAlignment.calculate( _tempPoint, sceneAlignment, _width / zoom, _height / zoom );

			_rootPosition.x = -xTo - _tempPoint.x;
			_rootPosition.y = -yTo - _tempPoint.y;

			_transformDirty = true;
		}

		public function get position() : Vector2D
		{
			return _rootPosition;
		}

		public function set position( value : Vector2D ) : void
		{
			if ( !value )
				return;

			var newX : int = int( value.x );
			var newY : int = int( value.y );

			if ( _rootPosition.x == newX && _rootPosition.y == newY )
				return;

			_rootPosition.x = newX;
			_rootPosition.y = newY;

			// Apply w	limit to camera movement.
			if ( trackLimitRectangle != null )
			{
				//var centeredLimitBounds : Rectangle = new Rectangle( trackLimitRectangle.x + ( _width * 0.5 ) / zoom, trackLimitRectangle.y + ( _height * 0.5 ) / zoom, trackLimitRectangle.width - ( _width / zoom ), trackLimitRectangle.height - ( _height / zoom ));

				centeredLimitBounds.x = trackLimitRectangle.x + ( _width * 0.5 ) / zoom;
				centeredLimitBounds.y = trackLimitRectangle.y + ( _height * 0.5 ) / zoom;
				centeredLimitBounds.width = trackLimitRectangle.width - ( _width / zoom );
				centeredLimitBounds.height = trackLimitRectangle.height - ( _height / zoom );

				_rootPosition.x = TotemUtil.clamp( _rootPosition.x, -centeredLimitBounds.right, -centeredLimitBounds.left );
				_rootPosition.y = TotemUtil.clamp( _rootPosition.y, -centeredLimitBounds.bottom, -centeredLimitBounds.top );
			}

			_transformDirty = true;
		}

		public function removeLayer( layer : DisplayObjectSceneLayer ) : void
		{
			var idx : int = _layers.indexOf( layer );

			if ( idx > -1 )
			{
				_layers.slice( idx, 1 );
				_rootSprite.removeChild( layer );

				sortLayers();
				_transformDirty = true;
			}
		}

		public function get sceneAlignment() : SceneAlignment
		{
			return _sceneAlignment;
		}

		public function set sceneAlignment( value : SceneAlignment ) : void
		{
			if ( value != _sceneAlignment )
			{
				_sceneAlignment = value;
				_transformDirty = true;
				updateTransform();
			}
		}

		public function get scenePosition() : Point
		{
			var pt : Point = new Point();

			SceneAlignment.calculate( _tempPoint, sceneAlignment, _width / zoom, _height / zoom );
			pt.x = -position.x - _tempPoint.x;
			pt.y = -position.y - _tempPoint.y;

			return pt;
		}

		public function get sceneViewBounds() : Rectangle
		{
			return _sceneViewBoundsCache;
		}

		public function setScenePosition( x : int, y : int ) : void
		{
			SceneAlignment.calculate( _tempPoint, sceneAlignment, _width / zoom, _height / zoom );
			var _positionX : int = -x - _tempPoint.x;
			var _positionY : int = -y - _tempPoint.y;
		}

		public function setSize( w : Number, h : Number ) : void
		{
			_width = Math.round( w );
			_height = Math.round( h );
		}

		public function get size() : Point
		{
			return new Point( _width, _height );
		}

		public function sortLayers() : void
		{
			_layers.sort( sortFunction );

			var layerIndex : int = 0;

			for ( var layer : int = 0; layer < _layers.length; layer++ )
			{
				var screen : DisplayObjectSceneLayer = _layers[ layer ] as DisplayObjectSceneLayer;
				_rootSprite.setChildIndex( screen, layerIndex );
				layerIndex++;
			}
		}

		public function get trackLimitRectangle() : Rectangle
		{
			return _trackLimitRectangle;
		}

		public function set trackLimitRectangle( value : Rectangle ) : void
		{
			_trackLimitRectangle = value;
		}

		public function transformScreenToScene( inPos : Point, resultPoint : Point = null ) : Point
		{
			updateTransform();
			return _rootSprite.globalToLocal( inPos, resultPoint );
		}

		public function transformScreenToWorld( inPos : Point, resultPoint : Point = null ) : Point
		{
			updateTransform();
			return _rootSprite.globalToLocal( inPos, resultPoint );
		}

		public function transformWorldToScreen( inPos : Point, resultPoint : Point = null ) : Point
		{
			updateTransform();
			return _rootSprite.localToGlobal( inPos, resultPoint );
		}

		public function updateTransform() : void
		{
			if ( !parent )
				return;

			if ( _transformDirty == false )
				return;

			_transformDirty = false;

			// Update our transform, if required
			_rootTransform.identity();
			_rootTransform.translate( _rootPosition.x, _rootPosition.y );
			_rootTransform.scale( zoom, zoom );

			// Center it appropriately.sceneView.width
			SceneAlignment.calculate( _tempPoint, sceneAlignment, _width, _height );
			_rootTransform.translate( _tempPoint.x, _tempPoint.y );

			// Apply the transform.
			_rootSprite.transformationMatrix = _rootTransform;

			updateSceneViewBounds();

			updatePositionDispatcher.dispatch( _rootSprite.x, _rootSprite.y, _sceneViewBoundsCache );

			for each ( var l : DisplayObjectSceneLayer in _layers )
				l.onRender();

		}

		public function get zoom() : Number
		{
			return _zoom;
		}

		public function set zoom( value : Number ) : void
		{
			// Make sure our zoom level stays within the desired bounds
			value = TotemUtil.clamp( value, minZoom, maxZoom );

			if ( _zoom == value )
				return;

			_zoom = value;
			_transformDirty = true;
		}

		private function sortFunction( objx : DisplayObjectSceneLayer, objy : DisplayObjectSceneLayer ) : Number
		{
			if ( objx.depth > objy.depth )
			{
				return 1;
			}
			else if ( objx.depth < objy.depth )
			{
				return -1;
			}
			return 0;
		}

		private function updateSceneViewBounds() : void
		{
			// What region of the scene are we currently viewing?
			SceneAlignment.calculate( _tempPoint, sceneAlignment, _width / zoom, _height / zoom );

			_sceneViewBoundsCache.x = -position.x - _tempPoint.x;
			_sceneViewBoundsCache.y = -position.y - _tempPoint.y;
			_sceneViewBoundsCache.width = _width / zoom;
			_sceneViewBoundsCache.height = _height / zoom;

		}
	}
}
