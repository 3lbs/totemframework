package totem.core
{

	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import ladydebug.Logger;
	
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	import org.swiftsuspenders.Injector;
	
	import totem.totem_internal;
	import totem.events.RemovableEventDispatcher;
	import totem.monitors.promise.IPromise;
	import totem.monitors.promise.SerialDeferred;

	use namespace totem_internal;

	public class TotemEntity extends TotemObject
	{
		public var eventDispatcher : IEventDispatcher = new RemovableEventDispatcher();

		private var components_ : Dictionary = new Dictionary();

		public var onAddSignal : ISignal = new Signal( TotemEntity );

		public var ticked : ISignal = new Signal( Number );

		private var tickEnabled : Boolean;

		public function getComponent( ComponentClass : Class ) : *
		{
			var component : * = null;
			try
			{
				component = getInstance( ComponentClass );
			}
			catch ( error : Error )
			{
				Logger.warn( this, "getComponent", "doesnt exsists: " + ComponentClass );
			}

			return component;
		}

		public function TotemEntity( name : String )
		{
			super( name );
		}

		public function addComponent( component : TotemComponent, ComponentClass : Class ) : TotemComponent
		{
			var injector : Injector = getInjector();

			//check component existence
			if ( injector.satisfiesDirectly( ComponentClass ))
				throw new Error( "Component " + ComponentClass + " already added." );

			//map to entity's and engine's injectors
			injector.map( ComponentClass ).toValue( component );

			component.setInjector( injector );
			component.owner = this;
			// you may not want to do this with components!!!!!!!!!!!!!!!!!!!!
			//injector.parentInjector.map( ComponentClass, getName()).toValue( component );

			components_[ ComponentClass ] = component;

			return component;
		}

		override public function initialize() : void
		{
			super.initialize();

			for each ( var component : TotemComponent in components_ )
			{
				getInjector().injectInto( component );
				component.doAdd();
			}
			
			onAddSignal.dispatch( this );

			onAddSignal.removeAll();
			onAddSignal = null;

		}
		
		private function handleInitComplete():void
		{
			eventDispatcher.dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		public function removeComponent( ComponentClass : Class ) : void
		{
			var injector : Injector = getInjector();

			//check component existence
			if ( !injector.satisfiesDirectly( ComponentClass ))
				throw new Error( "Component " + ComponentClass + " not found." );

			var component : TotemComponent = getComponent( ComponentClass );

			//remove component from entity
			component.doRemove();

			injector.unmap( ComponentClass );
			//injector.parentInjector.unmap( ComponentClass, getName());

			components_[ ComponentClass ] = null;
			delete components_[ ComponentClass ];
		}

		internal function onTick( delta : Number ) : void
		{
			tickEnabled && ticked.dispatch( delta );
		}

		override public function destroy() : void
		{
			super.destroy();
			// deleyed destroy?????
			deconstruct();
		}

		public function deconstruct( func : Function = null ) : IPromise
		{
			var monitor : SerialDeferred = new SerialDeferred();
			
			
			
			for each ( var component : TotemComponent in components_ )
			{
				monitor.add( component.deconstruct() );	
			}
			
			monitor.resolveOn( doDeconstruct );
			
			return monitor.promise();
		}

		protected function doDeconstruct() : void
		{
			for ( var componentClass : * in components_ )
			{
				removeComponent( componentClass );
			}

			ticked.removeAll();

			if ( injector )
			{
				injector.teardown();
				injector = null;
			}
		}
	}
}
