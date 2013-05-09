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

package quest
{

	import flash.events.IEventDispatcher;

	import totem.events.RemovableEventDispatcher;

	public class Quest extends RemovableEventDispatcher
	{

		public var parent : Quest;

		public function Quest( target : IEventDispatcher = null )
		{
			super( target );
		}
	}
}
