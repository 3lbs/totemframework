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

package totem.components.input
{

	import totem.core.TotemComponent;
	import totem.observer.NotifBroadcaster;

	public class InputNotifComponent extends TotemComponent implements IInputComponent
	{

		private var _broadcaster : NotifBroadcaster = new NotifBroadcaster();

		private var _enabled : Boolean;

		public function InputNotifComponent( name : String = null )
		{
			super( name );

			_enabled = true;
		}

		public function get broadcaster() : NotifBroadcaster
		{
			return null;
		}

		public function get enabled() : Boolean
		{
			return _enabled;
		}

		public function set enabled( value : Boolean ) : void
		{
			_enabled = value;
		}
	}
}
