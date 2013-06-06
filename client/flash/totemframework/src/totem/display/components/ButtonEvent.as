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

package totem.display.components
{

	import flash.events.Event;
	
	import totem.events.ObjectEvent;

	public class ButtonEvent extends ObjectEvent
	{
		public static const TRIGGERED : String = "ButtonEvent:Triggered";

		public function ButtonEvent( type : String, data : Object = null, bubbles : Boolean = false, cancelable : Boolean = false )
		{
			super( type, data, bubbles, cancelable );
		}
		
		override public function clone():Event
		{
			return new ButtonEvent( type, data, bubbles, cancelable );
		}
	}
}
