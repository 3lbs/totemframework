/*
 * Copyright (c) 2009 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package totem.core.mvc.modular.base
{
	import flash.events.IEventDispatcher;
	
	import totem.core.mvc.modular.core.IModuleEventDispatcher;
	import totem.events.RemovableEventDispatcher;
	
	public class ModuleEventDispatcher extends RemovableEventDispatcher implements IModuleEventDispatcher
	{
		public function ModuleEventDispatcher(target:IEventDispatcher = null)
		{
			super(target);
		}
	}
}