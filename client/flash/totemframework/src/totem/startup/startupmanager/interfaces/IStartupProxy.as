/*
	PureMVC Utility - Startup Manager - Manage loading of data resources at application startup
	Copyright (c) 2007-2008, collaborative, as follows
	2007 Daniele Ugoletti, Joel Caballero
	2008 Philip Sexton <philip.sexton@puremvc.org>
	Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package totem.startup.startupmanager.interfaces
{
	
	/**
	 *  Application proxy classes, where the class is a proxy
	 *  for a resource to be loaded at startup, must implement
	 *  this interface.
	 */
	public interface IStartupProxy
	{
		function load() :void;
	
		//function getProxyName(): String;
	}
}
