/*
 * Copyright (c) 2009 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package totem.core.mvc.modular.core
{
	import totem.core.mvc.ITotemContext;
    
	public interface IModuleTotemContext extends ITotemContext
	{
        function dispose():void;
	}
}