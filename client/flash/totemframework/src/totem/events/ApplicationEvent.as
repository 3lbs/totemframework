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

	public class ApplicationEvent extends ObjectEvent
	{

		public static const APPLICATION_COMPLETE_EVENT : String = "ApplicationEvent:ApplicationComplete";

		public static const APPLICATION_INIT_EVENT : String = "ApplicationEvent:ApplicationInit";

		public function ApplicationEvent( type : String, data : Object = null, bubbles : Boolean = false, cancelable : Boolean = false )
		{
			super( type, data, bubbles, cancelable );
		}
	}
}
