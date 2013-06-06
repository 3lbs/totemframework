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

package totem.core
{

	import flash.events.Event;
	import flash.events.IEventDispatcher;

	public class System extends TotemObject implements ITotemSystem
	{

		[Inject]
		protected var eventDispatcher : IEventDispatcher;

		public function System( name : String = null )
		{
			super( name );
		}

		override public function destroy() : void
		{
			super.destroy();

		}

		public function dispatchContext( e : Event ) : void
		{
			if ( eventDispatcher.hasEventListener( e.type ))
				eventDispatcher.dispatchEvent( e );
		}

		override public function initialize() : void
		{

		}
	}
}
