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

package totem.core
{

	import totem.observer.Notification;

	public class TotemNotification extends Notification
	{

		public static const ENTITY_INITIALIZED : String = "TotemNotif:EntityInitialezed";

		public function TotemNotification( type : String, data : Object = null )
		{
			super( type, data );
		}
	}
}
