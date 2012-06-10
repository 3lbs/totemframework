package totem.core
{
	import flash.utils.Dictionary;

	import org.swiftsuspenders.Injector;

	import totem.utils.construct;

	public class TotemEntity extends TotemObject
	{
		private var name_ : String;

		public function getName() : String
		{
			return name_;
		}

		private var components_ : Dictionary = new Dictionary();

		public function getComponent( ComponentClass : Class ) : *
		{
			return IComponent( getInstance( ComponentClass ));
		}

		public function TotemEntity( name : String )
		{
			name_ = name;
		}

		public function addComponent( ComponentClass : Class, ... params ) : *
		{
			var injector : Injector = getInjector();

			//check component existence
			if ( injector.satisfies( ComponentClass ))
				throw new Error( "Component " + ComponentClass + " already added." );

			//add component to entity
			var component : IComponent = construct( ComponentClass, params );

			//map to entity's and engine's injectors
			injector.map( ComponentClass ).toValue( component );
			injector.parentInjector.map( ComponentClass, getName()).toValue( component );

			//intialize component
			//component.setInjector( getInjector());
			
			components_[ ComponentClass ] = component;

			getInjector().injectInto( component );
			component.onAdded();

			return component;
		}

		public function removeComponent( ComponentClass : Class ) : void
		{
			var injector : Injector = getInjector();

			//check component existence
			if ( !injector.satisfies( ComponentClass ))
				throw new Error( "Component " + ComponentClass + " not found." );

			var component : IComponent = getComponent( ComponentClass );

			//remove component from entity
			component.onRemoved();
			//component.setInjector( null );
			
			delete components_[ ComponentClass ];
		}


		/** @private */
		internal function dispose() : void
		{
			for ( var ComponentClass : * in components_ )
			{
				removeComponent( ComponentClass );
			}
		}
	}
}
