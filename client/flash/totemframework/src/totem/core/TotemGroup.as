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

package totem.core
{

	import flash.utils.Dictionary;
	
	import avmplus.getQualifiedClassName;
	
	import org.swiftsuspenders.Injector;
	
	import totem.totem_internal;
	import totem.utils.DestroyUtil;

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

		private var entityCounter_ : int = 0;

		private var managerMap : Dictionary = new Dictionary();

		public function TotemGroup( _name : String = null )
		{
			super( _name );
		}

		public function addGroup( group : TotemGroup ) : void
		{
			//check duplicate entity name
			if ( getInjector().satisfies( TotemGroup, group.getName()))
				throw new Error( "Group named\"" + group.getName() + "\" already exists." );

			addChildObject( group, group.getName());
			getInjector().map( TotemObject, group.getName()).toValue( group );

		}

		/**
		 * Does this SmashGroup directly contain the specified object?
		 */
		public final function contains( object : TotemObject ) : Boolean
		{
			return ( object.owningGroup == this );
		}

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
			getInjector().map( TotemEntity, name ).toValue( entity );

			return entity;
		}

		override public function destroy() : void
		{
			super.destroy();

			// Wipe the items.
			while ( length )
				getTotemObjectAt( length - 1 ).destroy();

			
			DestroyUtil.destroyDictionary( managerMap );
			managerMap = null;
			
			// Shut down the managers we own.
			if ( injector )
			{
				injector.teardown();
				injector = null;
			}
		}

		public function destroyEntity( name : String ) : void
		{
			//check entity name existence
			if ( !getInjector().satisfies( TotemEntity, name ))
				throw new Error( "Entity named\"" + name + "\" does not exist." );

			var entity : TotemEntity = getEntity( name );

			//remove entity from system
			entity.destroy();
			getInjector().unmap( TotemEntity, name );
			entity.setInjector( null );
		}

		public function getEntity( name : String ) : TotemEntity
		{
			return getInjector().getInstance( TotemEntity, name );
		}

		/**
		 * Get a previously registered manager.
		 */
		public function getManager( clazz : Class ) : *
		{
			var res : * = null;

			res = getInjector().getInstance( clazz );

			if ( !res )
				throw new Error( "Can't find manager " + clazz + "!" );

			return res;
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
			if ( _initialzed )
				throw new Error( "Totem Group is already initialzed!" );

			_initialzed = true;

			// If no owning group, add to the global list for debug purposes.
			if ( owningGroup == null )
			{
				// this is a root group				
				initInjection();
			}
			else
			{
				if ( injector )
					injector.parentInjector = owningGroup.getInjector();

				owningGroup.injectInto( this );
			}
		}

		/**
		 * Perform dependency injection on the specified object using this
		 * SmashGroup's injection mappings.
		 */
		public function injectInto( object : * ) : void
		{
			getInjector().injectInto( object );
		}

		/**
		 * How many SmashObjects are in this group?
		 */
		public final function get length() : int
		{
			return _items.length;
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

			//Logger.error(TotemGroup, "lookup", "lookup failed! GameObject by the name of " + name + " does not exist");
			return null;
		}

		/**
		 * Add a manager, which is used to fulfill dependencies for the specified
		 * clazz. If the "manager" implements the ISmashManager interface, then
		 * initialize() is called at this time. When the SmashGroup's destroy()
		 * method is called, then destroy() is called on the manager if it
		 * implements ISmashManager. Injection is also done on the manager when it
		 * is registered.
		 */
		public function registerManager( clazz : Class, instance : *, doInjectInto : Boolean = true ) : *
		{
			// register a short name for the manager, this is mainly used for tooling
			var shortName : String = getQualifiedClassName( clazz ).split( "::" )[ 1 ];

			initInjection();

			injector.map( clazz ).toValue( instance );

			if ( doInjectInto )
				injector.injectInto( instance );

			if ( instance is TotemObject )
			{
				TotemObject( instance ).owningGroup = this;
			}

			if ( instance is ITotemSystem )
			{
				( instance as ITotemSystem ).initialize();
			}

			managerMap[ shortName ] = clazz;

			return instance;
		}

		protected function addChildObject( object : TotemObject, name : String ) : void
		{

			if ( object.owningGroup != null )
				throw new Error( "Object named\"" + object.getName() + "\" is already in a group exists." );

			// Rusher did this mapping may not want to do this
			//getInjector().map( TotemEntity, object.getName() ).toValue( object );

			object.owningGroup = this;

			//inject child injector
			var childInjector : Injector = getInjector().createChildInjector();
			//?
			childInjector.map( TotemEntity ).toValue( object );
			object.setInjector( childInjector );
		}

		//---------------------------------------------------------------

		protected function initInjection() : void
		{
			if ( injector )
				return;

			injector = new Injector();

			if ( owningGroup )
				injector.parentInjector = owningGroup.getInjector();
		}

		totem_internal function noteAdd( object : TotemObject ) : void
		{
			_items.push( object );
		}

		totem_internal function noteRemove( object : TotemObject ) : void
		{
			// Get it out of the list.
			var idx : int = _items.indexOf( object );

			if ( idx == -1 )
				throw new Error( "Can't find SmashObject in SmashGroup! Inconsistent group membership!" );
			_items.splice( idx, 1 );
		}
	}
}
