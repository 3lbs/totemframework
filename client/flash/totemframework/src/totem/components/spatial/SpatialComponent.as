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

package totem.components.spatial
{

	import flash.utils.Dictionary;

	import org.osflash.signals.Signal;

	import totem.components.display.DisplayObjectComponent;
	import totem.components.display.IDisplay2DRenderer;
	import totem.core.params.Transform2DParam;
	import totem.core.time.TickedComponent;
	import totem.math.AABBox;
	import totem.math.BoxRectangle;
	import totem.math.Vector2D;

	public class SpatialComponent extends TickedComponent implements ISpatial2D
	{
		public static const NAME : String = "spatialComponent";

		public static const UPDATE_TRANSFORMS_EVENT : String = "UpdateTransformEvenFt";

		public var gridBounds : BoxRectangle;

		public var positionChange : Signal = new Signal( Number, Number );

		public var rotationChange : Signal = new Signal( Number );

		public var scaleChange : Signal = new Signal( Number, Number );

		public var transformUpdate : Signal = new Signal();

		protected var _position : Vector2D = new Vector2D();

		protected var canDispatch : Boolean = false;

		protected var dirtyPosition : Boolean = true;

		protected var dirtyRotation : Boolean = true;

		protected var dirtyScale : Boolean = true;

		protected var properties : Dictionary;

		private var _bounds : AABBox;

		private var _rotation : Number = 0;

		private var _scaleX : Number = 1;

		private var _scaleY : Number = 1;

		private var _spatialManager : ISpatialManager;

		private var _x : Number = 0;

		private var _y : Number = 0;

		private var area : Number;

		private var displayRenderer : IDisplay2DRenderer;

		public function SpatialComponent( name : String = "", data : Transform2DParam = null )
		{
			super( name || NAME );

			if ( data )
			{
				x = data.translateX;
				y = data.translateY;

				_rotation = data.rotate;

				_scaleX = data.scaleX;
				_scaleY = data.scaleY;
			}

			_position = new Vector2D( x, y );

			properties = new Dictionary();
		}

		public function addDisplayRenderer( renderer : IDisplay2DRenderer ) : void
		{
			displayRenderer = renderer;
		}

		public function addSpatialManager( spatialDatabase : ISpatialManager ) : void
		{
			_spatialManager = spatialDatabase;
			_spatialManager.addSpatialObject( this );
		}

		public function get bounds() : AABBox
		{
			return bounds;
		}

		public function getProperty( prop : Object ) : Object
		{
			return properties[ prop ];
		}

		public function getSpatialManager() : ISpatialManager
		{
			return _spatialManager;
		}

		override public function onTick() : void
		{
			dispatchUpdate();
		}

		public function get position() : Vector2D
		{
			return _position;
		}

		public function removeItemFromManager() : void
		{
			if ( _spatialManager )
			{
				_spatialManager.removeSpatialObject( this );
			}
		}

		public function get rotation() : Number
		{
			return _rotation;
		}

		public function set rotation( value : Number ) : void
		{
			if ( value != _rotation )
			{
				_rotation = value;
				dirtyRotation = true;
			}
		}

		public function get scaleX() : Number
		{
			return _scaleX;
		}

		public function set scaleX( value : Number ) : void
		{
			if ( value != _scaleX )
			{
				_scaleX = value;
				dirtyScale = true;
			}
		}

		public function get scaleY() : Number
		{
			return _scaleY;
		}

		public function set scaleY( value : Number ) : void
		{
			if ( value != _scaleY )
			{
				_scaleY = value;
				dirtyScale = true;
			}
		}

		public function setPosition( x : Number, y : Number ) : void
		{
			this.x = x;
			this.y = y;

			dirtyPosition = true;
		}

		public function setProperty( prop : Object, value : Object ) : void
		{
			properties[ prop ] = value;
		}

		public function setRotation( value : Number ) : void
		{
			if ( value != _rotation )
			{
				_rotation = value;
				dirtyRotation = true;
			}
		}

		public function setScale( x : Number, y : Number, z : Number ) : void
		{
			_scaleX = x;
			_scaleY = y;

			dirtyScale = true;
		}

		public function get x() : Number
		{
			return _x;
		}

		public function set x( value : Number ) : void
		{
			if ( value == _x )
				return;

			_position.x = _x = value;
			dirtyPosition = true;
		}

		public function get y() : Number
		{
			return _y;
		}

		public function set y( value : Number ) : void
		{
			if ( value == _y )
				return;

			_position.y = _y = value;
			dirtyPosition = true;
		}

		protected function dispatchUpdate( force : Boolean = false ) : void
		{
			if ( canDispatch || force == true )
			{
				if ( dirtyPosition == true )
				{

					if ( displayRenderer )
					{
						displayRenderer.position = position;
					}
					else
					{
						positionChange.dispatch( _x, _y );
					}

					dirtyPosition = false;
				}

				if ( dirtyRotation == true )
				{

					if ( displayRenderer )
					{
						displayRenderer.setRotation( _rotation );
					}
					else
					{
						rotationChange.dispatch( _rotation );
					}

					dirtyRotation = false;
				}

				if ( dirtyScale == true )
				{

					if ( displayRenderer )
					{
						displayRenderer.setScale( _scaleX, _scaleY );
					}
					else
					{
						rotationChange.dispatch( _scaleX, _scaleY );
					}

					dirtyScale = false;
				}
			}

		}

		override protected function onAdd() : void
		{
			super.onAdd();

			//_bounds ||= BoxRectangle.create( x, y, width, height );

			area = 10;
			_bounds ||= AABBox.create( position, area, area );
			canDispatch = true;

			dispatchUpdate( true );
		}

		override protected function onRemove() : void
		{
			super.onRemove();

			canDispatch = false;

			positionChange.removeAll();
			rotationChange.removeAll();
			transformUpdate.removeAll();
		}

		private function updateTransformsEvent( component : DisplayObjectComponent ) : void
		{
			dirtyPosition = true;
			dirtyRotation = true;
			dirtyScale = true;

			dispatchUpdate( true );
		}
	}
}

