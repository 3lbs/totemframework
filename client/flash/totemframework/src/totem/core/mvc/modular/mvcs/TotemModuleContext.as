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

package totem.core.mvc.modular.mvcs
{

	import flash.display.DisplayObjectContainer;
	import flash.events.IEventDispatcher;
	import totem.core.TotemGroup;
	import totem.core.mvc.TotemContext;
	import totem.core.mvc.modular.base.ModuleEventDispatcher;
	import totem.core.mvc.modular.core.IModuleEventDispatcher;
	import totem.events.RemovableEventDispatcher;

	import totem.totem_internal;

	public class TotemModuleContext extends TotemContext
	{

		private var _moduleEventDispatcher : IModuleEventDispatcher = new ModuleEventDispatcher();

		public function TotemModuleContext( name : String, mainclass : DisplayObjectContainer, group : TotemGroup )
		{
			super( name, mainclass, group );
		}

		[Inject]
		public function set contextEventDispatcher( value : IEventDispatcher ) : void
		{
			totem_internal::_contextEventDispatcher = value as RemovableEventDispatcher;
		}

		override public function destroy() : void
		{
			_moduleEventDispatcher.destroy();
			_moduleEventDispatcher = null;
			super.destroy();
		}

		override public function initialize() : void
		{
			super.initialize();

			injector.map( IModuleEventDispatcher ).toValue( _moduleEventDispatcher );
		}

		public function get moduleEventDispatcher() : IModuleEventDispatcher
		{
			return _moduleEventDispatcher;
		}
	}
}
