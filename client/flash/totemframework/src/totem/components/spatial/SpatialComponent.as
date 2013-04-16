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

	import org.osflash.signals.Signal;
	
	import totem.components.DisplayRendererComponent;
	import totem.core.params.TransformParam;
	import totem.core.time.TickedComponent;
	import totem.math.AABBox;
	import totem.math.Vector2D;

	public class SpatialComponent extends TickedComponent implements ISpatialObject
	{
		public static const NAME : String = "spatialComponent";

		public static const UPDATE_TRANSFORMS_EVENT : String = "UpdateTransformEvenFt";

		public var bounds : AABBox;

		public var positionChange : Signal = new Signal( Number, Number, Number );

		public var radius : Number = 1;

		public var rotationChange : Signal = new Signal( Number, Number, Number );

		public var scaleChange : Signal = new Signal( Number, Number, Number );

		public var transformUpdate : Signal = new Signal();

		protected var canDispatch : Boolean = false;

		private var _rotationX : Number = 0;

		private var _rotationY : Number = 0;

		private var _rotationZ : Number = 0;

		private var _scaleX : Number = 1;

		private var _scaleY : Number = 1;

		private var _scaleZ : Number = 1;

		private var _x : Number = 0;

		private var _y : Number = 0;

		private var _z : Number = 0;

		private var dirtyPosition : Boolean = true;

		private var dirtyRotation : Boolean = true;

		private var dirtyScale : Boolean = true;

		private var displayRenderer : DisplayRendererComponent;

		public function SpatialComponent( data : TransformParam = null )
		{
			if ( data )
			{
				x = data.translateX;
				y = data.translateY;
				z = data.translateZ;

				_rotationX = data.rotateX;
				_rotationY = data.rotateY;
				_rotationZ = data.rotateZ;

				_scaleX = data.scaleX;
				_scaleY = data.scaleY;
				_scaleZ = data.scaleZ;
			}
		}
		
		public function addDisplayRendererSignal( renderer : DisplayRendererComponent ) : void
		{
			displayRenderer = renderer;
			displayRenderer.displayUpdate.add( updateTransformsEvent );
		}

		public function get rotationX() : Number
		{
			return _rotationX;
		}

		public function set rotationX( value : Number ) : void
		{
			_rotationX = value;
			dirtyRotation = true;

			dispatchUpdate();
		}

		public function get rotationY() : Number
		{
			return _rotationY;
		}

		public function set rotationY( value : Number ) : void
		{
			_rotationY = value;
			dirtyRotation = true;

			dispatchUpdate();
		}

		public function get rotationZ() : Number
		{
			return _rotationZ;
		}

		public function set rotationZ( value : Number ) : void
		{
			_rotationZ = value;
			dirtyRotation = true;

			dispatchUpdate();
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
				dispatchUpdate();
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
				dispatchUpdate();
			}
		}

		public function get scaleZ() : Number
		{
			return _scaleZ;
		}

		public function set scaleZ( value : Number ) : void
		{
			if ( value != _scaleZ )
			{
				_scaleZ = value;
				dirtyScale = true;
				dispatchUpdate();
			}
		}

		public function setPosition( x : Number, y : Number, z : Number ) : void
		{
			_x = x;
			_y = y;
			_z = z;

			dirtyPosition = true;

			dispatchUpdate();
		}

		public function setRotation( x : Number, y : Number, z : Number ) : void
		{
			_rotationX = x;
			_rotationY = y;
			_rotationZ = z;

			dirtyRotation = true;

			dispatchUpdate();
		}

		public function setScale( x : Number, y : Number, z : Number ) : void
		{
			_scaleX = x;
			_scaleY = y;
			_scaleZ = z;

			dirtyScale = true;

			dispatchUpdate();
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

			dirtyPosition = true;
			dispatchUpdate();
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
			dirtyPosition = true;
			dispatchUpdate();
		}

		public function get z() : Number
		{
			return _z;
		}

		public function set z( value : Number ) : void
		{
			if ( value == _z )
				return;

			_z = value;

			dirtyPosition = true;
			dispatchUpdate();
		}

		protected function dispatchUpdate( force : Boolean = false ) : void
		{
			if ( canDispatch || force == true )
			{
				if ( dirtyPosition == true )
				{

					if ( displayRenderer )
					{
						displayRenderer.setPosition( _x, _y, _z );
					}
					else
					{
						positionChange.dispatch( _x, _y, _z );
					}

					dirtyPosition = false;
				}

				if ( dirtyRotation == true )
				{

					if ( displayRenderer )
					{
						displayRenderer.setRotation( _rotationX, _rotationY, _rotationZ );
					}
					else
					{
						rotationChange.dispatch( _rotationX, _rotationY, _rotationZ );
					}

					dirtyRotation = false;
				}

				if ( dirtyScale == true )
				{

					if ( displayRenderer )
					{
						displayRenderer.setScale( _scaleX, _scaleY, _scaleZ );
					}
					else
					{
						rotationChange.dispatch( _scaleX, _scaleY, _scaleZ );
					}

					dirtyScale = false;
				}
			}

		}

		override protected function onAdd() : void
		{
			super.onAdd();

			bounds = new AABBox( new Vector2D( x, y ), radius, radius );

			canDispatch = true;

			dispatchUpdate();
		}

		override protected function onRemove() : void
		{
			super.onRemove();

			canDispatch = false;

			positionChange.removeAll();
			rotationChange.removeAll();
			transformUpdate.removeAll();
		}

		private function updateTransformsEvent( component : DisplayRendererComponent ) : void
		{
			dirtyPosition = true;
			dirtyRotation = true;
			dirtyScale = true;

			dispatchUpdate( true );
		}
	}
}

