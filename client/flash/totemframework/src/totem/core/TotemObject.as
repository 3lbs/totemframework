package totem.core
{
	import org.swiftsuspenders.Injector;

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
	public class TotemObject
	{
		private var _name : String;

		private var _active : Boolean = false;

		totem_internal var _owningGroup : TotemGroup;

		totem_internal var _sets : Vector.<TotemSet>;

		public function TotemObject( _name : String = null )
		{
			name = _name;
		}

		public function getInjector() : Injector
		{
			return owningGroup.injector;
		}

		public function getInstance( InstanceClass : Class, name : String = "" ) : *
		{
			if ( !owningGroup.injector.satisfies( InstanceClass, name ))
			{
				throw new Error( "Instance of" + InstanceClass + " named \"" + name + "\" not found." );
			}
			return owningGroup.injector.getInstance( InstanceClass, name );
		}

		public function getEntity( name : String ) : TotemEntity
		{
			return getInstance( TotemEntity, name );
		}

		/**
		 * Name of the SmashObject. Used for dynamic lookups and debugging.
		 */
		public function get name() : String
		{
			return _name;
		}

		/**
		 * @private
		 */
		public function set name( value : String ) : void
		{
			if ( _active && _owningGroup )
				throw new Error( "Cannot change SmashObject name after initialize() is called and while in a SmashGroup." );

			_name = value;
		}

		/**
		 * What SmashSets reference this SmashObject?
		 */
		public function get sets() : Vector.<TotemSet>
		{
			return _sets;
		}

		/**
		 * @private
		 */
		public function get owningGroup() : TotemGroup
		{
			return _owningGroup;
		}

		/**
		 * The SmashGroup that contains us. All SmashObjects must be in a SmashGroup,
		 * and the owningGroup has to be set before calling initialize().
		 */
		public function set owningGroup( value : TotemGroup ) : void
		{
			if ( !value )
				throw new Error( "A SmashObject must always be in a SmashGroup." );

			if ( _owningGroup )
				_owningGroup.noteRemove( this );

			_owningGroup = value;
			_owningGroup.noteAdd( this );
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
		 * Called to initialize the SmashObject. The SmashObject must be in a SmashGroup
		 * before calling this (ie, set owningGroup).
		 */
		public function initialize() : void
		{
			// Error if not in a group.
			if ( _owningGroup == null )
				throw new Error( "Can't initialize a SmashObject without an owning SmashGroup!" );

			_active = true;
		}

		/**
		 * Called to destroy the SmashObject: remove it from sets and groups, and do
		 * other end of life cleanup.
		 */
		public function destroy() : void
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

			_active = false;
		}
	}
}
