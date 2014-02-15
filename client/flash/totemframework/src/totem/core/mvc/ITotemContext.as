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

package totem.core.mvc
{

	import flash.display.DisplayObjectContainer;
	import flash.events.IEventDispatcher;

	import totem.core.ITotemSystem;
	import totem.core.TotemEntity;
	import totem.core.TotemGroup;
	import totem.monitors.progress.IProgressMonitor;

	public interface ITotemContext extends ITotemSystem
	{

		function addGroup( group : TotemGroup ) : void;

		function createEntity( name : String = null ) : TotemEntity;

		function destroyEntity( name : String ) : void;

		function get contextEventDispatcher() : IEventDispatcher;

		function get mainClass() : DisplayObjectContainer;

		function get progressMonitor() : IProgressMonitor;

		function registerManager( clazz : Class, instance : *, doInjectInto : Boolean = true ) : *;
		
		function getManager( clazz : Class ) : *;
		
		function getEntity( name : String ) : TotemEntity;
	}
}
