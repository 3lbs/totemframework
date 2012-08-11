package totem.core.mvc
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	import org.casalib.events.IRemovableEventDispatcher;
	import org.casalib.events.RemovableEventDispatcher;
	import org.swiftsuspenders.Injector;

	import totem.core.ITotemSystem;
	import totem.core.TotemGroup;
	import totem.core.mvc.controller.command.ControllerSystemManager;
	import totem.core.mvc.view.MediatorSystemManager;
	import totem.core.mvc.view.ViewMap;
	import totem.totem_internal;

	use namespace totem_internal;

	public class TotemContext extends TotemGroup implements ITotemSystem
	{
		private var _stage : Stage;

		public var eventDispatcher : IRemovableEventDispatcher;

		private var mediators : MediatorSystemManager;

		private var views : ViewMap;

		private var controller : ControllerSystemManager;

		private var _mainClass : Sprite;

		public function TotemContext( mainclass : Sprite, injector : Injector = null )
		{
			setup( mainclass, injector );
		}

		public function get mainClass():Sprite
		{
			return _mainClass;
		}

		public function get stage() : Stage
		{
			return _stage;
		}

		public function setup( mainclass : Sprite, injectorClass : Injector = null ) : void
		{
			if ( injectorClass )
			{
				setInjector( injectorClass );
				initializeInjector();
			}

			if ( mainclass )
			{
				_mainClass = mainclass;
			}

			if ( mainclass.stage )
			{
				_stage = mainclass.stage;
				initializeApplication();
			}
		}

		private function initializeApplication() : void
		{
			disposeCore();

			mediators = new MediatorSystemManager( this );
			registerManager( MediatorSystemManager, mediators );

			controller = new ControllerSystemManager( this );
			registerManager( ControllerSystemManager, controller );

			views = new ViewMap();
			registerManager( ViewMap, views );

			initialize();
			registerModels();
			registerViews();
			registerCommands();
			registerPlugins();
			start();
		}

		/**
		 * Method that you can optionally overwrite to register models to the framework.
		 * @see com.soma.core.model.SomaModels
		 * @example
		 * <listing version="3.0">addModel(MyModel.NAME, new MyModel());</listing>
		 */
		protected function registerModels() : void
		{

		}

		/**
		 * Method that you can optionally overwrite to register views to the framework.
		 * @see com.soma.core.view.SomaViews
		 * @example
		 * <listing version="3.0">addView(MySprite.NAME, new MySprite());</listing>
		 */
		protected function registerViews() : void
		{

		}

		/**
		 * Method that you can optionally overwrite to register commands (mapping events to command classes) to the framework.
		 * @see com.soma.core.controller.SomaController
		 * @example
		 * <listing version="3.0">addCommand(MyEvent.DOSOMETING, MyCommandClass);</listing>
		 */
		protected function registerCommands() : void
		{

		}

		/**
		 * Method that you can optionally overwrite to register plugins to the framework.
		 * @example
		 * <listing version="3.0">
		 var pluginVO:SomaDebuggerVO = new SomaDebuggerVO(this, SomaDebugger.NAME_DEFAULT, getCommands(), true, false);
		 var debugger:SomaDebugger = createPlugin(SomaDebugger, pluginVO) as SomaDebugger;
		 * </listing>
		 */
		protected function registerPlugins() : void
		{

		}

		/**
		 * Method that you can optionally overwrite to start your own after that the framework has registered all the elements (models, views, commands, wires, plugins).
		 * @see com.soma.core.wire.SomaWires
		 * @example
		 * <listing version="3.0">addWire(MyWire.NAME, new MyWire());</listing>
		 */
		protected function start() : void
		{

		}

		/** @private */
		protected function initializeInjector() : void
		{
			disposeInjector();

			if ( _injector )
			{
				eventDispatcher = new RemovableEventDispatcher();
				_injector.map( TotemContext, "totemFacdeInstance" ).toValue( this );
				_injector.map( IRemovableEventDispatcher, "facadeDispatcher" ).toValue( eventDispatcher );
			}
		}

		override public function destroy() : void
		{
			super.destroy();

			disposeCore();
			disposeInjector();
			
			_mainClass = null;
			_stage = null;
		}

		/** @private */
		private function disposeCore() : void
		{

			if ( views )
			{
				views.dispose();
				views = null;
			}

			if ( controller )
			{
				controller.destroy();
				controller = null;
			}

			if ( mediators )
			{
				mediators.destroy();
				mediators = null;
			}
		}

		/** @private */
		private function disposeInjector() : void
		{
			if ( _injector )
			{
				_injector.teardown();
				_injector = null;
			}
		}
	}
}
