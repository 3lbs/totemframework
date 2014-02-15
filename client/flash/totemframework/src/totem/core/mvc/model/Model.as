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

package totem.core.mvc.model
{

	import flash.events.Event;
	import flash.events.IEventDispatcher;

	import totem.core.Destroyable;

	public class Model extends Destroyable
	{

		[Inject]
		public var eventDispatcher : IEventDispatcher;

		public function Model()
		{
		}

		override public function destroy() : void
		{
			super.destroy();

			eventDispatcher = null;
		}

		protected function dispatchContext( e : Event ) : void
		{
			if ( eventDispatcher.hasEventListener( e.type ))
				eventDispatcher.dispatchEvent( e );
		}
	}
}
