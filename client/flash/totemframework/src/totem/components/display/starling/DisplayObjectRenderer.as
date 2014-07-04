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

package totem.components.display.starling
{

	import starling.display.DisplayObject;

	import totem.components.display.DisplayObjectSceneLayer;
	import totem.components.display.IDisplay2DRenderer;
	import totem.core.TotemDestroyable;
	import totem.math.Vector2D;

	public class DisplayObjectRenderer extends TotemDestroyable implements IDisplay2DRenderer
	{

		protected var _alpha : Number = 1;

		protected var _displayObject : DisplayObject;

		private var _visible : Boolean;

		private var _zIndex : Number;

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
			return null;
		}

		public function set position( value : Vector2D ) : void
		{
		}

		public function get positionOffset() : Vector2D
		{
			return null;
		}

		public function set positionOffset( value : Vector2D ) : void
		{
		}

		public function set scene( scene : DisplayObjectSceneLayer ) : void
		{
		}

		public function setPosition( x : Number, y : Number ) : void
		{
		}

		public function setRotation( value : Number ) : void
		{
		}

		public function setScale( _scaleX : Number, _scaleY : Number ) : void
		{
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
