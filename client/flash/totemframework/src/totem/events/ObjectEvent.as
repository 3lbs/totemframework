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

package totem.events
{

	import flash.events.Event;

	public class ObjectEvent extends Event
	{

		public var data : Object;

		public function ObjectEvent( type : String, data : Object = null, bubbles : Boolean = false, cancelable : Boolean = false )
		{
			super( type, bubbles, cancelable );
			this.data = data;
		}

		override public function clone() : Event
		{
			return new ObjectEvent( type, data, bubbles, cancelable ) as Event;
		}
	}
}

