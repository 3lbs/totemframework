package totem.core.mvc.modular.mvcs
{

	import flash.display.DisplayObjectContainer;
	import flash.events.IEventDispatcher;
	
	import totem.core.TotemGroup;
	import totem.core.mvc.TotemContext;
	import totem.core.mvc.modular.base.ModuleEventDispatcher;
	import totem.core.mvc.modular.core.IModuleEventDispatcher;
	import totem.events.RemovableEventDispatcher;

	public class TotemModuleContext extends TotemContext
	{

		private var _moduleEventDispatcher : IModuleEventDispatcher;

		public function TotemModuleContext( name : String, mainclass : DisplayObjectContainer, group : TotemGroup )
		{
			super( name, mainclass, group );
		}

		[Inject]
		public function set contextEventDispatcher( value : IEventDispatcher ) : void
		{
			_contextEventDispatcher = value as RemovableEventDispatcher;
		}

		public function get moduleEventDispatcher() : IModuleEventDispatcher
		{
			return _moduleEventDispatcher;
		}

		override public function initialize() : void
		{
			super.initialize();
			
			_moduleEventDispatcher = new ModuleEventDispatcher();
			injector.map( IModuleEventDispatcher ).toValue( _moduleEventDispatcher );
		}

		override public function destroy() : void
		{
			ModuleEventDispatcher( _moduleEventDispatcher ).destroy();
			_moduleEventDispatcher = null;
			
			_contextEventDispatcher = null;
			
			super.destroy();
		}
	}
}
