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

package totem.core.input
{

	import totem.core.Destroyable;

	public class BaseInputMonitor extends Destroyable implements IInputMonitor
	{
		protected var _enabled : Boolean = true;

		protected var _observers : IMobileInput;

		protected var _target : Object;

		public function BaseInputMonitor( t : Object )
		{
			super();

			_target = t;
		}

		override public function destroy() : void
		{
			_observers = null;
			_target = null;
			super.destroy();
		}

		public function get enabled() : Boolean
		{
			return _enabled;
		}

		public function set enabled( value : Boolean ) : void
		{
			_enabled = value;
		}

		public function subscribe( input : IMobileInput ) : void
		{
			_observers = input;
		}

		public function unSubscribe( input : IMobileInput ) : void
		{
			_observers = null;
		}
	}
}
