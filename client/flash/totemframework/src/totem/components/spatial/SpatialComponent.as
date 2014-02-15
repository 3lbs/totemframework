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

package totem.components.spatial
{

	import flash.utils.Dictionary;

	import totem.core.params.Transform2DParam;
	import totem.core.time.TickedComponent;
	import totem.data.type.Point2d;
	import totem.math.AABBox;
	import totem.math.Vector2D;

	public class SpatialComponent extends TickedComponent implements ISpatial2D
	{
		public static const NAME : String = "spatialComponent";

		protected var _position : Vector2D = new Vector2D();

		protected var _x : Number = 0;

		protected var _y : Number = 0;

		protected var dirtyPosition : Boolean = true;

		protected var dirtyRotation : Boolean = true;

		protected var dirtyScale : Boolean = true;

		protected var properties : Dictionary;

		private var _bounds : AABBox;

		private var _depth : int;

		private var _rotation : Number = 0;

		private var _scaleX : Number = 1;

		private var _scaleY : Number = 1;

		private var _spatialManager : ISpatialManager;

		private var _type : int;

		private var area : Number;

		private var observers : Vector.<ISpatialObserver> = new Vector.<ISpatialObserver>();

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

		public function addSpatialManager( spatialDatabase : ISpatialManager, active : Boolean ) : void
		{
			_spatialManager = spatialDatabase;

			if ( active )
				_spatialManager.addSpatialObject( this );
		}

		public function get bounds() : AABBox
		{
			return _bounds;
		}

		public function contains( x : int, y : int ) : Boolean
		{
			return false; // _bounds.contains( x, y );
		}

		public function containsPoint( pt : Point2d ) : Boolean
		{
			return false; // _bounds.containsPoint( pt );
		}

		public function get depth() : int
		{
			return _depth;
		}

		public function set depth( value : int ) : void
		{
			_depth = value;
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
			_x = _position.x = x;
			_y = _position.y = y;

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

		public function subscribe( component : ISpatialObserver ) : void
		{
			observers.push( component );
		}

		public function get type() : int
		{
			return _type;
		}

		public function set type( value : int ) : void
		{
			_type = value;
		}

		public function unsubscribe( component : ISpatialObserver ) : void
		{
			var idx : int = observers.indexOf( component );

			if ( idx != -1 )
				observers.splice( idx, 1 );

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

		protected function dispatchUpdate() : void
		{

			if ( !dirtyPosition && !dirtyRotation && !dirtyScale )
				return;

			var i : int;
			var length : int = observers.length;

			for ( i = 0; i < length; ++i )
			{
				if ( dirtyPosition == true )
					observers[ i ].setPosition( _x, _y );

				if ( dirtyRotation == true )
					observers[ i ].setRotation( _rotation );

				if ( dirtyScale == true )
					observers[ i ].setScale( _scaleX, _scaleY );
			}

			dirtyPosition = dirtyScale = dirtyRotation = false;
		}

		override protected function onActivate() : void
		{
			super.onActivate();

			if ( _spatialManager )
			{
				_spatialManager.addSpatialObject( this );
			}
		}

		override protected function onAdd() : void
		{
			super.onAdd();

			//_bounds ||= BoxRectangle.create( x, y, width, height );

			area = 10;
			_bounds ||= AABBox.create( position, area, area );

			dirtyPosition = true;

			dispatchUpdate();
		}

		override protected function onRemove() : void
		{
			super.onRemove();

			if ( _spatialManager )
			{
				_spatialManager.removeSpatialObject( this );
				_spatialManager = null;
			}

			observers.length = 0;
		}

		override protected function onRetire() : void
		{
			super.onRetire();

			if ( _spatialManager )
			{
				_spatialManager.removeSpatialObject( this );
			}
		}
	}
}

