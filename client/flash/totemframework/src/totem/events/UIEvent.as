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

package totem.events
{

	import flash.events.Event;

	public class UIEvent extends ObjectEvent
	{

		public static const ACCEPT : String = "UIEvent:AcceptEvent";

		public static const CANCEL : String = "UIEvent:CancelEvent";

		public static const CLOSE : String = "UIEvent:CloseEvent";

		public function UIEvent( type : String, data : Object = null, bubbles : Boolean = false, cancelable : Boolean = false )
		{
			super( type, data, bubbles, cancelable );
		}

		override public function clone() : Event
		{
			return new UIEvent( type, data, bubbles, cancelable );
		}
	}
}
