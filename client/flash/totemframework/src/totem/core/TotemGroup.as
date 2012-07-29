package totem.core
{
	import avmplus.getQualifiedClassName;
	
	import flash.net.registerClassAlias;
	
	import org.swiftsuspenders.Injector;
	
	import totem.totem_internal;
	
	import totemdebug.Logger;


	use namespace totem_internal;

	/**
	 * SmashGroup provides lifecycle functionality (SmashObjects in it are destroy()ed
	 * when it is destroy()ed), as well as dependency injection (see
	 * registerManager).
	 *
	 * SmashGroups are unique because they don't require an owningGroup to
	 * be initialize()ed.
	 */
	public class TotemGroup extends TotemObject
	{
		protected var _items : Vector.<TotemObject> = new Vector.<TotemObject>();

		public function TotemGroup( _name : String = null )
		{
			super( _name );
		}

		/**
		 * Does this SmashGroup directly contain the specified object?
		 */
		public final function contains( object : TotemObject ) : Boolean
		{
			return ( object.owningGroup == this );
		}

		/**
		 * How many SmashObjects are in this group?
		 */
		public final function get length() : int
		{
			return _items.length;
		}

		/**
		 * Return the SmashObject at the specified index.
		 */
		public final function getTotemObjectAt( index : int ) : TotemObject
		{
			return _items[ index ];
		}

		override public function initialize() : void
		{

			// If no owning group, add to the global list for debug purposes.
			if ( owningGroup == null )
			{
				// this is a root group				
				initInjection();
			}
			else
			{
				if ( _injector )
					_injector.parentInjector = owningGroup.getInjector();

				owningGroup.injectInto( this );
			}
		}

		public override function destroy() : void
		{
			super.destroy();

			// Wipe the items.
			while ( length )
				getTotemObjectAt( length - 1 ).destroy();

			// Shut down the managers we own.
			if ( _injector )
			{

				_injector.teardown();

				/*for ( var key : * in _injector.mappedValues )
				{
					const val : * = _injector.mappedValues[ key ];

					if ( val is ISmashManager )
						( val as ISmashManager ).destroy();
				}*/
				_injector = null;
			}
		}

		totem_internal function noteRemove( object : TotemObject ) : void
		{
			// Get it out of the list.
			var idx : int = _items.indexOf( object );

			if ( idx == -1 )
				throw new Error( "Can't find SmashObject in SmashGroup! Inconsistent group membership!" );
			_items.splice( idx, 1 );
		}

		totem_internal function noteAdd( object : TotemObject ) : void
		{
			_items.push( object );
		}

		//---------------------------------------------------------------

		protected function initInjection() : void
		{
			if ( _injector )
				return;

			_injector = new Injector();

			if ( owningGroup )
				_injector.parentInjector = owningGroup.getInjector();
		}

		/**
		 * Add a manager, which is used to fulfill dependencies for the specified
		 * clazz. If the "manager" implements the ISmashManager interface, then
		 * initialize() is called at this time. When the SmashGroup's destroy()
		 * method is called, then destroy() is called on the manager if it
		 * implements ISmashManager. Injection is also done on the manager when it
		 * is registered.
		 */
		public function registerManager( clazz : Class, instance : *, doInjectInto : Boolean = true ) : void
		{
			// register a short name for the manager, this is mainly used for tooling
			var shortName : String = getQualifiedClassName( clazz ).split( "::" )[ 1 ];
			registerClassAlias( shortName, clazz );

			initInjection();

			_injector.map( clazz ).toValue( instance );

			if ( doInjectInto )
				_injector.injectInto( instance );

			if ( instance is ITotemSystem )
				( instance as ITotemSystem ).initialize();
		}

		/**
		 * Get a previously registered manager.
		 */
		public function getManager( clazz : Class ) : *
		{
			var res : * = null;

			res = getInjector().getMapping( clazz );

			if ( !res )
				throw new Error( "Can't find manager " + clazz + "!" );

			return res;
		}

		/**
		 * Perform dependency injection on the specified object using this
		 * SmashGroup's injection mappings.
		 */
		public function injectInto( object : * ) : void
		{
			getInjector().injectInto( object );
		}

		private var entityCounter_ : int = 0;

		public function createEntity( name : String = null ) : TotemEntity
		{
			//check duplicate entity name
			if ( getInjector().satisfies( TotemEntity, name ))
				throw new Error( "Entity named\"" + name + "\" already exists." );

			if ( !name )
				name = "entity" + entityCounter_++;

			//add entity to group
			var entity : TotemEntity = new TotemEntity( name );
			
			addChildObject( entity, name );
			
			return entity;
		}
		
		public function addGroup ( group : TotemGroup ) : void
		{
			//check duplicate entity name
			if ( getInjector().satisfies( TotemEntity, group.getName() ))
				throw new Error( "Entity named\"" + group.getName() + "\" already exists." );
			
			addChildObject( group, group.getName() );
			
		}
		
		private function addChildObject ( object : TotemObject, name : String ) : void
		{
			
			if ( object.owningGroup != null )
				throw new Error( "Object named\"" + object.getName() + "\" is already in a group exists." );
			
			// Rusher did this mapping may not want to do this
			getInjector().map( TotemEntity, name ).toValue( object );
			object.owningGroup = this;
			
			//inject child injector
			var childInjector : Injector = getInjector().createChildInjector();
			childInjector.map( TotemEntity ).toValue( object );
			object.setInjector( childInjector );
		}
		
		//TODO: late removal
		public function destroyEntity( name : String ) : void
		{
			//check entity name existence
			if ( !getInjector().satisfies( TotemEntity, name ))
				throw new Error( "Entity named\"" + name + "\" does not exist." );

			var entity : TotemEntity = getEntity( name );

			//remove entity from system
			entity.dispose();
			getInjector().unmap( TotemEntity, name );
			entity.setInjector( null );
		}
		
		
		public function getEntity( name : String ) : TotemEntity
		{
			return getInjector().getInstance( TotemEntity, name );
		}
		
		public function lookup( name : String ) : TotemObject
		{
			for each ( var go : TotemObject in _items )
			{
				if ( go.getName() == name )
					return go;
			}
			
			if ( owningGroup )
			{
				return owningGroup.lookup( name );
			}
			
			Logger.error(TotemGroup, "lookup", "lookup failed! GameObject by the name of " + name + " does not exist");
			return null;
		}
	}
}
