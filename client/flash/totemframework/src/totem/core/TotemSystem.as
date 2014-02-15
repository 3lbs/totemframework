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

	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import totem.totem_internal;

	public class TotemSystem extends TotemObject implements ITotemSystem
	{

		[Inject]
		protected var eventDispatcher : IEventDispatcher;

		public function TotemSystem( name : String = null )
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
			super.initialize();

			if ( !injector && totem_internal::owningGroup )
				injector = totem_internal::getInjector();
		}
	}
}
