package totem.core
{
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;

	import org.casalib.events.RemovableEventDispatcher;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	import org.swiftsuspenders.Injector;

	import totem.totem_internal;

	use namespace totem_internal;

	public class TotemEntity extends TotemObject
	{

		//public var eventDispatcher : IEventDispatcher = new RemovableEventDispatcher();

		private var components_ : Dictionary = new Dictionary();

		public var onAddSignal : ISignal = new Signal( TotemEntity );

		public var ticked : ISignal = new Signal( Number );

		private var tickEnabled : Boolean;

		public function getComponent( ComponentClass : Class ) : *
		{
			return getInstance( ComponentClass );
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

			//component.doAdd();

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

		protected function doInitialize( component : TotemComponent ) : void
		{
			//component._owner = this;
			owningGroup.injectInto( component );
			component.doAdd();


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
			injector.parentInjector.unmap( ComponentClass, getName());

			components_[ ComponentClass ] = null;
			delete components_[ ComponentClass ];
		}

		internal function onTick( delta : Number ) : void
		{
			tickEnabled && ticked.dispatch( delta );
		}

		/** @private */
		internal function dispose() : void
		{
			for ( var ComponentClass : * in components_ )
			{
				removeComponent( ComponentClass );
			}
			
			ticked.removeAll();
			onAddSignal.removeAll();
			
		}
	}
}
