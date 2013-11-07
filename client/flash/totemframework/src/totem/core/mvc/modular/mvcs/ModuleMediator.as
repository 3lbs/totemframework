/*
 * Copyright (c) 2009 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package totem.core.mvc.modular.mvcs
{

	import flash.events.Event;
	
	import totem.core.mvc.modular.core.IModuleEventDispatcher;
	import totem.core.mvc.view.Mediator;

	public class ModuleMediator extends Mediator
	{

		[Inject]
		public var moduleDispatcher : IModuleEventDispatcher;


		/**
		 * Map an event type to globally redispatch to all modules within an application.
		 * <p/>
		 * <listing version="3.0">
		 * mapRedispatchToModules(MyEvent.SOME_EVENT);
		 * </listing>
		 *
		 * @param event
		 *
		 */
		protected function addModuleListener( type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = true ) : void
		{
			moduleDispatcher.addEventListener( type, listener, useCapture, priority, useWeakReference );
		}

		/**
		 * Globally redispatch an event to all modules within an application.
		 * <p/>
		 * <listing version="3.0">
		 * eventMap.mapEvent(view, MyEvent.SOME_EVENT, redispatchToModule);
		 * </listing>
		 *
		 * @param event
		 *
		 */
		protected function dispatchToModules( event : Event ) : Boolean
		{
			if ( moduleDispatcher.hasEventListener( event.type ))
				return moduleDispatcher.dispatchEvent( event );
			return false;
		}
		
		override public function destroy():void
		{
			super.destroy();
			
			
			moduleDispatcher = null;
		}
	}
}
