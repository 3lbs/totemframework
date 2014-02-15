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

package totem.sound
{

	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import totem.core.TotemDestroyable;

	/**
	 * Experimental spatial sound system
	 */
	public class TotemSpatialSound extends TotemDestroyable
	{
		public var drawObject : Boolean = true;

		public var drawRadius : Boolean = false;

		//protected var _camera : ACitrusCamera;

		protected var _debugArt : TotemSoundDebugArt;

		protected var _group : uint = 1;

		protected var _objects : Vector.<TotemSoundObject>;

		protected var _realDebugView : *;

		protected var _touchable : Boolean = false;

		protected var _view : *;

		protected var _visible : Boolean = false;

		protected var camCenter : Point = new Point();

		protected var camRect : Rectangle = new Rectangle();

		protected var camRotation : Number = 0;

		public function TotemSpatialSound( name : String, params : Object = null )
		{

			super( name );
			touchable = false;
			_objects = new Vector.<TotemSoundObject>();

			updateCameraProperties();
		}

		public function add( citrusSoundObject : TotemSoundObject ) : void
		{
			_objects.push( citrusSoundObject );
			updateObject( citrusSoundObject );
			citrusSoundObject.initialize();
		}

		public function get animation() : String
		{
			return "";
		}

		public function get depth() : Number
		{
			return 0;
		}

		override public function destroy() : void
		{
			visible = false;
			super.destroy();
		}

		public function getBody() : *
		{
			return null;
		}

		public function get group() : uint
		{
			return _group;
		}

		public function set group( value : uint ) : void
		{
			_group = value;
		}

		public function get height() : Number
		{
			return 0;
		}

		public function get inverted() : Boolean
		{
			return false;
		}

		public function get offsetX() : Number
		{
			return 0;
		}

		public function get offsetY() : Number
		{
			return 0;
		}

		public function get parallaxX() : Number
		{
			return 1;
		}

		public function get parallaxY() : Number
		{
			return 1;
		}

		public function get registration() : String
		{
			return "topLeft";
		}

		public function remove( citrusSoundObject : TotemSoundObject ) : void
		{
			var i : int = _objects.indexOf( citrusSoundObject );

			if ( i > -1 )
				_objects.splice( i, 1 );
		}

		public function get rotation() : Number
		{
			return 0;
		}

		public function get touchable() : Boolean
		{
			return _touchable;
		}

		public function set touchable( value : Boolean ) : void
		{
			_touchable = value;
		}

		public function update() : void
		{

			updateCameraProperties();

			if ( _visible )
				_debugArt.graphics.clear();

			var object : TotemSoundObject;

			for each ( object in _objects )
			{
				updateObject( object );

				if ( _visible )
				{
					if ( drawObject )
					{
						//_debugArt.graphics.lineStyle( 0.1, 0xFF0000, 0.8 );
						//_debugArt.graphics.drawCircle( object.citrusObject.x, object.citrusObject.y, 1 + 120 * object.totalVolume );
					}

					if ( drawRadius )
					{
						//_debugArt.graphics.lineStyle( 0.5, 0x00FF00, 0.8 );
						//_debugArt.graphics.drawCircle( object.citrusObject.x, object.citrusObject.y, object.radius );
					}
				}
			}

			if ( _visible )
			{
				//var m : Matrix = _debugArt.transform.matrix;
				//m.copyFrom( _camera.transformMatrix );
				//m.concat( _ce.transformMatrix );
				//_debugArt.transform.matrix = m;
			}
		}

		public function get velocity() : Array
		{
			return null;
		}

		public function get view() : *
		{
			return _view;
		}

		public function set view( value : * ) : void
		{
			_view = value;
		}

		public function get visible() : Boolean
		{
			return _visible;
		}

		public function set visible( value : Boolean ) : void
		{
			if ( value == _visible )
				return;

			if ( value )
			{
				_debugArt = new TotemSoundDebugArt();
				//_ce.stage.addChild( _debugArt );
			}
			else if ( _debugArt )
			{
				_debugArt.destroy();
				//_ce.stage.removeChild( _debugArt );
			}

			_visible = value;
		}

		public function get width() : Number
		{
			return 0;
		}

		public function get x() : Number
		{
			return 0;
		}

		public function get y() : Number
		{
			return 0;
		}

		public function get z() : Number
		{
			return 0;
		}

		protected function updateCameraProperties() : void
		{
			/*_camera = _ce.state.view.camera;
			camRect.copyFrom( _camera.getRect());
			camCenter.setTo( camRect.x + camRect.width * 0.5, camRect.y + camRect.height * 0.5 );
			camRotation = _camera.getRotation();*/
		}

		protected function updateObject( object : TotemSoundObject ) : void
		{
			//if ( _camera )
			{
				/*object.camVec.setTo( object.citrusObject.x - camCenter.x, object.citrusObject.y - camCenter.y );
				object.camVec.angle += camRotation;
				object.rect.width = _camera.cameraLensWidth;
				object.rect.height = _camera.camProxy.scale;*/
			}
			object.update();
		}
	}

}
