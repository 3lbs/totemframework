package totem.core.mvc
{

	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.IEventDispatcher;
	
	import org.swiftsuspenders.Injector;
	
	import totem.totem_internal;
	import totem.core.TotemGroup;
	import totem.events.RemovableEventDispatcher;

	use namespace totem_internal;

	public class TotemContext extends TotemGroup implements ITotemContext
	{
		protected var _stage : Stage;

		protected var _mainClass : DisplayObjectContainer;

		protected var _contextEventDispatcher : RemovableEventDispatcher = new RemovableEventDispatcher();
		
		public function TotemContext( name : String, mainclass : DisplayObjectContainer, group : TotemGroup )
		{
			super( name );
			
			_mainClass = mainclass;
			
			setup( group );
		}
		
		public function get eventDispatcher () : IEventDispatcher
		{
			return _contextEventDispatcher;
		}
		
		public function get mainClass() : DisplayObjectContainer
		{
			return _mainClass;
		}

		public function get stage() : Stage
		{
			return _stage;
		}

		public function setup( group : TotemGroup ) : void
		{
			
			owningGroup = group;
			
			//inject child injector
			var childInjector : Injector = group.getInjector().createChildInjector();
			childInjector.map( ITotemContext ).toValue( this );
			setInjector( childInjector );
			
			
			group.injectInto( this );
			
			//setInjector( injector );
			injector.map( Injector ).toValue( injector );
			//injector.injectInto( this );

			injector.map( ITotemContext, getName() ).toValue( this );

			if ( _mainClass )
			{
				if ( !injector.satisfies( DisplayObjectContainer ))
					injector.map( DisplayObjectContainer ).toValue( _mainClass );
			}

			if ( _mainClass.stage )
			{
				_stage = _mainClass.stage;
				initializeApplication();
			}
		}

		private function initializeApplication() : void
		{
			initialize();
			start();
		}

		protected function start() : void
		{

		}

		override public function destroy() : void
		{
			super.destroy();

			_mainClass = null;
			_stage = null;
		}

		/*override protected function handleStageDeactivated( e : flash.events.Event ) : void
		{
		
		if ( _playing && _starling )
		_starling.stop();
		
		super.handleStageDeactivated( e );
		}
		
		override protected function handleStageActivated( e : flash.events.Event ) : void
		{
		
		if ( _starling && !_starling.isStarted )
		_starling.start();
		
		super.handleStageActivated( e );
		}*/
	}
}
