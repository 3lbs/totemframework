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

package totem.display.components
{

	import flash.display.SimpleButton;

	import totem.core.Destroyable;

	public class DataSimpleButton extends Destroyable
	{
		private var _button : SimpleButton;

		private var _data : Object;

		public function DataSimpleButton( display : SimpleButton )
		{
			super();

			_button = display;
		}

		public function get data() : Object
		{
			return _data;
		}

		public function set data( value : Object ) : void
		{
			_data = value;
		}

		override public function destroy() : void
		{
			super.destroy();

			_button = null;
			_data = null;
		}
	}
}
