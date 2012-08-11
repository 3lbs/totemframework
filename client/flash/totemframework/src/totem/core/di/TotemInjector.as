package totem.core.di
{
	import flash.system.ApplicationDomain;

	import org.swiftsuspenders.Injector;
	import org.swiftsuspenders.mapping.InjectionMapping;
	import org.swiftsuspenders.typedescriptions.TypeDescription;

	import totem.core.Destroyable;

	public class TotemInjector extends Destroyable
	{

		private var injector : Injector;

		public function TotemInjector()
		{
			initialize();
		}

		internal function initialize( specifiedInjector : TotemInjector = null, parentInjector : TotemInjector = null ) : TotemInjector
		{
			if ( injector )
				destroy();

			/*if ( !specifiedInjector )
				injector = new Injector();
			else
			{
				injector = specifiedInjector;

				if ( parentInjector )
					_parent = parentInjector;
			}*/
			
			return this;
		}

		public function map( type : Class, name : String = '' ) : InjectionMapping
		{
			return injector.map( type, name );
		}


		public function unmap( type : Class, name : String = '' ) : void
		{
			injector.unmap( type, name );
		}


		public function satisfies( type : Class, name : String = '' ) : Boolean
		{
			return injector.satisfies( type, name );
		}

		public function satisfiesDirectly( type : Class, name : String = '' ) : Boolean
		{
			return injector.satisfiesDirectly( type, name );
		}

		public function injectInto( target : Object ) : void
		{
			injector.injectInto( target );
		}

		public function getInstance( type : Class, name : String = '', targetType : Class = null ) : *
		{
			return getInstance( type, name, targetType );
		}

		public function destroyInstance( instance : Object ) : void
		{
			injector.destroyInstance( instance );
		}

		public function teardown() : void
		{
			injector.teardown();
		}

		public function createChildInjector( applicationDomain : ApplicationDomain = null ) : Injector
		{
			return injector.createChildInjector( applicationDomain );
		}

		public function set parentInjector( parentInjector : Injector ) : void
		{
			injector.parentInjector = parentInjector;
		}

		public function get parentInjector() : Injector
		{
			return injector.parentInjector;
		}

		public function set applicationDomain( applicationDomain : ApplicationDomain ) : void
		{
			injector.applicationDomain = applicationDomain;
		}

		public function get applicationDomain() : ApplicationDomain
		{
			return injector.applicationDomain;
		}

		public function addTypeDescription( type : Class, description : TypeDescription ) : void
		{
			injector.addTypeDescription( type, description );
		}

		/**
		 * Returns a description of the given type containing its constructor, injection points
		 * and post construct and pre destroy hooks
		 *
		 * @param type The type to describe
		 * @return The TypeDescription containing all information the injector has about the type
		 */
		public function getTypeDescription( type : Class ) : TypeDescription
		{
			return injector.getTypeDescription( type );
		}
		
		override public function destroy():void
		{
			super.destroy();
			
			injector = null;
		}
	}
}
