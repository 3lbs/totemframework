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

package totem.ui.layout.layouts
{

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	import totem.ui.layout.events.EventUI;
	import totem.ui.layout.vo.GapUI;
	import totem.ui.layout.vo.PaddingUI;

	public class HBoxUI extends LayoutUI
	{

		public static const ALIGN_BOTTOM_LEFT : String = "bottom_left";

		public static const ALIGN_BOTTOM_RIGHT : String = "bottom_right";

		public static const ALIGN_CENTER_LEFT : String = "center_left";

		public static const ALIGN_CENTER_RIGHT : String = "center_right";

		public static const ALIGN_TOP_LEFT : String = "top_left";

		public static const ALIGN_TOP_RIGHT : String = "top_right";

		protected const BOTTOM : String = "bottom";

		protected const CENTER : String = "center";

		protected const LEFT : String = "left";

		protected const RIGHT : String = "right";

		protected const TOP : String = "top";

		protected var _childrenAlign : String;

		protected var _childrenEnable : Boolean = true;

		protected var _childrenGap : GapUI;

		protected var _childrenPadding : PaddingUI;

		protected var _horizontalAlign : String;

		protected var _verticalAlign : String;

		public function HBoxUI( reference : DisplayObjectContainer, width : Number = 100, height : Number = 100 )
		{
			super( reference, width, height );
		}

		public function get childrenAlign() : String
		{
			return _childrenAlign;
		}

		public function set childrenAlign( value : String ) : void
		{
			if ( value != ALIGN_TOP_LEFT && value != ALIGN_CENTER_LEFT && value != ALIGN_BOTTOM_LEFT && value != ALIGN_TOP_RIGHT && value != ALIGN_CENTER_RIGHT && value != ALIGN_BOTTOM_RIGHT )
			{
				throw new Error( "Error in " + this + " (" + name + "): the align property must be, for example: HBoxUI.ALIGN_TOP_LEFT" );
			}
			_childrenAlign = value;
			setPrivateAlignment();
		}

		public function get childrenEnable() : Boolean
		{
			return _childrenEnable;
		}

		public function set childrenEnable( value : Boolean ) : void
		{
			_childrenEnable = value;
		}

		public function get childrenGap() : GapUI
		{
			return _childrenGap;
		}

		public function set childrenGap( value : GapUI ) : void
		{
			_childrenGap = value;
		}

		public function get childrenPadding() : PaddingUI
		{
			return _childrenPadding;
		}

		public function set childrenPadding( value : PaddingUI ) : void
		{
			_childrenPadding = value;
		}

		override public function dispose() : void
		{
			/*try
			{
				if ( _element != null )
					_element.removeEventListener( EventUI.UPDATED, updatedHandler );
				_childrenPadding = null;
				_childrenGap = null;
				super.dispose();
			}
			catch ( e : Error )
			{
				trace( "Error in", this, "(dispose method):", e.message );
			}*/
		}

		override protected function initialize() : void
		{
			super.initialize();
			_childrenPadding = new PaddingUI();
			_childrenGap = new GapUI();
			_childrenAlign = ALIGN_TOP_LEFT;
			setPrivateAlignment();
			_element.addEventListener( EventUI.UPDATED, updatedHandler );
		}

		protected function setPrivateAlignment() : void
		{
			var arr : Array = _childrenAlign.split( "_" );
			_horizontalAlign = arr[ 1 ];
			_verticalAlign = arr[ 0 ];
		}

		protected function update() : void
		{
			var startX : Number = 0;
			var startY : Number = 0;

			switch ( _horizontalAlign )
			{
				case LEFT:
					startX = _childrenPadding.left;
					break;
				case RIGHT:
					startX = _width - _childrenPadding.right;
					break;
			}

			switch ( _verticalAlign )
			{
				case TOP:
					startY = _childrenPadding.top;
					break;
				case CENTER:
					startY = ( _height >> 1 );
					break;
				case BOTTOM:
					startY = _height - _childrenPadding.bottom;
					break;
			}
			var posX : Number = startX;
			var posY : Number = startY;
			var i : Number = 0;
			var l : Number = numChildren;

			for ( i; i < l; ++i )
			{
				var obj : DisplayObject = getChildAt( i );

				if ( _verticalAlign == CENTER )
				{
					posY -= ( obj.height >> 1 );
				}
				else if ( _verticalAlign == BOTTOM )
				{
					posY -= obj.height;
				}

				if ( _horizontalAlign == RIGHT )
				{
					posX -= obj.width;
				}
				obj.x = posX;
				obj.y = posY;
				posX = ( _horizontalAlign == LEFT ) ? ( obj.x + obj.width + _childrenGap.horizontal ) : ( obj.x - _childrenGap.horizontal );
				posY = startY;
			}
		}

		protected function updatedHandler( e : EventUI ) : void
		{
			if ( !_childrenEnable )
			{
				return;
			}
			update();
		}
	}
}
