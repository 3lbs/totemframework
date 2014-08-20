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
	
	import starling.display.Quad;
	
	import totem.components.display.IDisplay2DRenderer;
	import totem.core.params.Transform2DParam;
	import totem.core.time.TickedComponent;
	import totem.data.type.Point2d;
	import totem.math.AABBox;
	import totem.math.Vector2D;
	import totem.utils.ColorUtil;

	public class SpatialComponent extends TickedComponent implements ISpatial2D
	{
		public static const NAME : String = "spatialComponent";

		public var boundsOffset : Vector2D = new Vector2D();

		protected var _position : Vector2D = new Vector2D();

		protected var _x : Number = 0;

		protected var _y : Number = 0;

		protected var dirtyPosition : Boolean = true;

		protected var dirtyRotation : Boolean = true;

		protected var dirtyScale : Boolean = true;

		protected var properties : Dictionary;

		protected var _bounds : AABBox; // = new AABBox();

		private var _depth : int;

		private var _height : int;

		private var _locked : Boolean;

		private var _positionOffset : Vector2D = new Vector2D();

		private var _rotation : Number = 0;

		private var _scaleX : Number = 1;

		private var _scaleY : Number = 1;

		private var _spatialManager : ISpatialManager;

		private var _type : int;

		private var _width : int;

		private var boundImage : Quad;

		private var dirtyOffset : Boolean;

		private var observers : Vector.<ISpatialObserver> = new Vector.<ISpatialObserver>();

		private var tempOffset : Vector2D = new Vector2D();

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

				_width = data.width;
				_height = data.height;
			}

			_position = new Vector2D( x, y );

			_bounds = new AABBox( _position );

			properties = new Dictionary();
		}

		public function addSpatialManager( spatialDatabase : ISpatialManager ) : void
		{
			_spatialManager = spatialDatabase;

			if ( activated )
				_spatialManager.addSpatialObject( this );
		}

		public function get bounds() : AABBox
		{
			return _bounds;
		}

		public function contains( x : int, y : int ) : Boolean
		{
			return _bounds.contains( x, y );
		}

		public function containsPoint( pt : Point2d ) : Boolean
		{
			/*trace( pt.toString() );
			trace( _bounds.toString () );
			trace(  _bounds.containsPoint( pt ) );
			
			if ( _bounds.containsPoint( pt ) == false )
				trace("stop");*/
				
			return _bounds.containsPoint( pt );
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

		public function get height() : int
		{
			return _height;
		}

		public function set height( value : int ) : void
		{

			if ( value == _height )
				return;

			_height = value;

			_bounds.setSize( _width, _height )
				
			dirtyPosition = true;
			updateTransfrom();
		}

		public function get locked() : Boolean
		{
			return _locked;
		}

		public function set locked( value : Boolean ) : void
		{
			_locked = value;
		}

		override public function onTick() : void
		{
			dispatchUpdate();
		}

		public function get position() : Vector2D
		{
			return _position;
		}

		public function get positionOffset() : Vector2D
		{
			return _positionOffset;
		}

		public function set positionOffset( value : Vector2D ) : void
		{
			_positionOffset.x = value.x;
			_positionOffset.y = value.y;

			dirtyOffset = true;
			updateTransfrom();
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
				updateTransfrom();
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
				updateTransfrom();
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
				updateTransfrom();
			}
		}

		public function setPosition( x : Number, y : Number ) : void
		{
			_x = _position.x = x;
			_y = _position.y = y;

			dirtyPosition = true;
			updateTransfrom();
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
				updateTransfrom();
			}
		}

		public function setScale( x : Number, y : Number, z : Number = 1 ) : void
		{
			_scaleX = x;
			_scaleY = y;

			dirtyScale = true;
			updateTransfrom();
		}

		public function subscribe( component : ISpatialObserver ) : void
		{
			observers.push( component );
			dirtyPosition = dirtyOffset = dirtyRotation = dirtyScale = true;
		}

		public function get type() : int
		{
			return _type;
		}

		public function set type( value : int ) : void
		{
			_type = value;
		}

		public function get uid() : String
		{
			return owner.getName();
		}

		public function unsubscribe( component : ISpatialObserver ) : void
		{
			var idx : int = observers.indexOf( component );

			if ( idx != -1 )
				observers.splice( idx, 1 );

		}

		public function get width() : int
		{
			return _width;
		}

		public function set width( value : int ) : void
		{
			if ( value == _width )
				return;

			_width = value;

			_bounds.setSize( _width, _height );
				
			dirtyPosition = true;
			updateTransfrom();
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
			updateTransfrom();
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
			updateTransfrom();
		}

		protected function dispatchUpdate() : void
		{

			if ( !dirtyPosition && !dirtyRotation && !dirtyScale && !dirtyOffset )
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

				if ( dirtyOffset == true )
					observers[ i ].setOffset( _positionOffset );
			}

			dirtyOffset = dirtyPosition = dirtyScale = dirtyRotation = false;
		}

		override protected function onActivate() : void
		{
			super.onActivate();

			if ( _spatialManager )
			{
				_spatialManager.addSpatialObject( this );
			}

			updateTransfrom();

			dispatchUpdate();
		}

		override protected function onAdd() : void
		{
			super.onAdd();

			dirtyPosition = true;

			_bounds.setSize( _width, _height );
			
			updateTransfrom();

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

			_x = 0;
			_y = 0;
		}

		protected function updateTransfrom() : void
		{

			if ( dirtyPosition == true )
			{
				tempOffset.copy( position ).addTo( boundsOffset ); //.addTo( positionOffset );
				_bounds.moveTo( tempOffset );

				drawHitArea();

			}

		}

		private function drawHitArea() : void
		{

			if ( !activated )
				return;

			var displayComponent : IDisplay2DRenderer = getSibling( IDisplay2DRenderer );

			if ( !boundImage )
			{
				boundImage = new Quad( _bounds.width, _bounds.height, ColorUtil.AQUA );
				boundImage.alpha = .3;
				displayComponent.displayObject.parent.addChild( boundImage );
			}

			if ( boundImage )
			{
				var p : Vector2D = _bounds.center; //.subtractedBy( defaultOffset ); //.subtract( positionOffset );
				
				boundImage.x = p.x; // - (width * 0.5);
				boundImage.y = p.y ; //- ( height * 0.5 );
			}

		}
	}
}

