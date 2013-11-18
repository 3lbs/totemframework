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
	import totem.core.time.TickedComponent;
	import totem.math.AABBox;
	import totem.math.Vector2D;

	public class SpatialComponent extends TickedComponent implements ISpatial2D
	{
		public static const NAME : String = "spatialComponent";

		public static const UPDATE_TRANSFORMS_EVENT : String = "UpdateTransformEvenFt";

		public var bounds : AABBox;

		public var positionChange : Signal = new Signal( Number, Number );

		public var radius : Number = 1;

		public var rotationChange : Signal = new Signal( Number, Number );

		public var scaleChange : Signal = new Signal( Number, Number );

		public var transformUpdate : Signal = new Signal();

		protected var canDispatch : Boolean = false;

		protected var properties : Dictionary;

		private var _rotation : Number = 0;

		private var _scaleX : Number = 1;

		private var _scaleY : Number = 1;

		private var _x : Number = 0;

		private var _y : Number = 0;
		
		private var dirtyPosition : Boolean = true;

		private var dirtyRotation : Boolean = true;

		private var dirtyScale : Boolean = true;

		private var displayRenderer : IDisplay2DRenderer;

		public function Spatial2DComponent()
		{
			properties = new Dictionary();
		}

		public function addDisplayRendererSignal( renderer : IDisplay2DRenderer ) : void
		{
			displayRenderer = renderer;
		}

		public function getProperty( prop : Object ) : Object
		{
			return properties[ prop ];
		}

		public function get rotation() : Number
		{
			return _rotation;
		}

		public function set rotation( value : Number ) : void
		{
			_rotation = value;
			dirtyRotation = true;

			dispatchUpdate();
		}

		override public function onTick():void
		{
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


		public function setPosition( x : Number, y : Number ) : void
		{
			_x = x;
			_y = y;

			dirtyPosition = true;

			dispatchUpdate();
		}

		public function setProperty( prop : Object, value : Object ) : void
		{
			properties[ prop ] = value;
		}

		public function setRotation( value : Number ) : void
		{
			_rotation = value;

			dirtyRotation = true;

			dispatchUpdate();
		}

		public function setScale( x : Number, y : Number, z : Number ) : void
		{
			_scaleX = x;
			_scaleY = y;

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


		protected function dispatchUpdate( force : Boolean = false ) : void
		{
			if ( canDispatch || force == true )
			{
				if ( dirtyPosition == true )
				{

					if ( displayRenderer )
					{
						displayRenderer.setPosition( _x, _y );
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

		private function updateTransformsEvent( component : DisplayObjectComponent ) : void
		{
			dirtyPosition = true;
			dirtyRotation = true;
			dirtyScale = true;

			dispatchUpdate( true );
		}
	}
}

