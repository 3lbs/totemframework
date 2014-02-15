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

	import org.swiftsuspenders.Injector;
	import totem.data.InListNode;

	import totem.totem_internal;

	use namespace totem_internal;

	/**
	 * Base class for things that have names, lifecycles, and exist in a SmashSet or
	 * SmashGroup.
	 *
	 * To use a SmashObject:
	 *
	 * 1. Instantiate one. (var foo = new SmashGroup();)
	 * 2. Set the owning group. (foo.owningGroup = rootGroup;)
	 * 3. Call initialize(). (foo.initialize();)
	 * 4. Use the object!
	 * 5. When you're done, call destroy(). (foo.destroy();)
	 */
	public class TotemObject extends InListNode implements IDestroyable
	{

		protected var _initialzed : Boolean = false;

		protected var injector : Injector = null;

		totem_internal var _owningGroup : TotemGroup;

		totem_internal var _sets : Vector.<TotemSet>;

		private var _name : String;

		public function TotemObject( name : String )
		{
			_name = name;
		}

		/**
		 * Called to destroy the SmashObject: remove it from sets and groups, and do
		 * other end of life cleanup.
		 */
		override public function destroy() : void
		{
			// Remove from sets.
			if ( _sets )
			{
				while ( _sets.length )
					_sets[ _sets.length - 1 ].remove( this );
			}

			// Remove from owning group.
			if ( _owningGroup )
			{
				_owningGroup.noteRemove( this );
				_owningGroup = null;
			}
			
			injector.teardown();
			injector = null;

			super.destroy();
		}

		public function getInstance( InstanceClass : Class, name : String = "" ) : *
		{
			if ( !getInjector().satisfies( InstanceClass, name ))
			{
				throw new Error( "Instance of" + InstanceClass + " named \"" + name + "\" not found." );
			}
			return getInjector().getInstance( InstanceClass, name );
		}

		/**
		 * Name of the SmashObject. Used for dynamic lookups and debugging.
		 */
		public function getName() : String
		{
			return _name;
		}

		public function getSystem( SystemClass : Class ) : *
		{
			return getInstance( SystemClass );
		}

		public function hasInstance( InstanceClass : Class, name : String = "" ) : Boolean
		{
			return getInjector().hasMapping( InstanceClass, name );
		}

		/**
		 * Called to initialize the SmashObject. The SmashObject must be in a SmashGroup
		 * before calling this (ie, set owningGroup).
		 */
		public function initialize() : void
		{
			if ( _initialzed )
				throw new Error( "Totem Object is already initialzed!" );

			// Error if not in a group.
			if ( _owningGroup == null )
				throw new Error( "Can't initialize a SmashObject without an owning SmashGroup!" );

			_initialzed = true;
		}

		public function get initialzed() : Boolean
		{
			return _initialzed;
		}

		/**
		 * What SmashSets reference this SmashObject?
		 */
		public function get sets() : Vector.<TotemSet>
		{
			return _sets;
		}

		totem_internal function getInjector() : Injector
		{
			if ( injector )
				return injector;
			else if ( owningGroup )
				return owningGroup.getInjector();
			return null;
		}

		totem_internal function noteSetAdd( set : TotemSet ) : void
		{
			if ( _sets == null )
				_sets = new Vector.<TotemSet>();
			_sets.push( set );
		}

		totem_internal function noteSetRemove( set : TotemSet ) : void
		{
			var idx : int = _sets.indexOf( set );

			if ( idx == -1 )
				throw new Error( "Tried to remove SmashObject from a SmashSet it didn't know it was in!" );
			_sets.splice( idx, 1 );
		}

		/**
		 * @private
		 */
		totem_internal function get owningGroup() : TotemGroup
		{
			return _owningGroup;
		}

		/**
		 * The SmashGroup that contains us. All SmashObjects must be in a SmashGroup,
		 * and the owningGroup has to be set before calling initialize().
		 */
		totem_internal function set owningGroup( value : TotemGroup ) : void
		{
			if ( !value )
				throw new Error( "A SmashObject must always be in a SmashGroup." );

			if ( _owningGroup )
				_owningGroup.noteRemove( this );

			_owningGroup = value;
			_owningGroup.noteAdd( this );
		}

		totem_internal function setInjector( value : Injector ) : void
		{
			injector = value;
		}
	}
}
