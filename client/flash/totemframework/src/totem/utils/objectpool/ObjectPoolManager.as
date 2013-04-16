package totem.utils.objectpool
{

	import flash.utils.Dictionary;
	
	import totem.core.Destroyable;
	import totem.utils.TypeUtility;

	public final class ObjectPoolManager extends Destroyable
	{
		protected static const _typeDictionary : Dictionary = new Dictionary();

		private static var _instance : ObjectPoolManager;

		public function ObjectPoolManager( se : ObjectPoolerSingletonEnforcer )
		{
			if ( !se )
				throw new Error( "Cannot instantiate a singleton class. Use static getInstance instead." );
		}

		public static function getInstance() : ObjectPoolManager
		{
			return _instance ||= new ObjectPoolManager( new ObjectPoolerSingletonEnforcer());
		}

		public function initObjectPool( identifierOrType : *, count : int, canGrow : Boolean = true, factory : IObjectPoolFactory = null, helper : IObjectPoolHelper = null ) : void
		{
			if ( _typeDictionary[ identifierOrType ])
				throw new Error( "Already created an object pool of this type: " + identifierOrType );

			var objectPool : ObjectPool = _typeDictionary[ identifierOrType ] = new ObjectPool( canGrow );

			if ( factory )
				objectPool.setFactory( factory );

			if ( helper )
				objectPool.setHelper( helper );

			var type : Class = ( identifierOrType is Class ) ? identifierOrType : null;
			objectPool.allocate( count, type );
		}

		public function preallocate( identifierOrType : *, count : int, factory : IObjectPoolFactory = null ) : void
		{
			if ( !_typeDictionary[ identifierOrType ])
				_typeDictionary[ identifierOrType ] = new ObjectPool( true );
			const pool : ObjectPool = _typeDictionary[ identifierOrType ] as ObjectPool;

			var type : Class = ( identifierOrType is Class ) ? identifierOrType : null;
			pool.allocate( count, type );
		}

		public function checkOut( identifierOrType : * ) : *
		{
			if ( !_typeDictionary[ identifierOrType ])
				throw new Error( "Object Pool doesnt exsists.  needs to be created and allocated" );

			const pool : ObjectPool = _typeDictionary[ identifierOrType ] as ObjectPool;

			return pool.checkOut();
		}

		public function checkIn( item : *, identifierOrType : * = null ) : void
		{
				
			if ( identifierOrType == null )
				identifierOrType = TypeUtility.getClass( item );
			
			if ( !_typeDictionary[ identifierOrType ])
				throw new Error( "Object Pool doesnt exsists.  needs to be created and allocated" );

			const pool : ObjectPool = _typeDictionary[ identifierOrType ] as ObjectPool;
			
			
			pool.checkIn( item );
		}

		public function disposePool( identifierOrType : * ) : void
		{
			var pool : ObjectPool = _typeDictionary[ identifierOrType ];

			if ( pool )
			{
				pool.deconstruct();

				_typeDictionary[ identifierOrType ] = null;
				delete _typeDictionary[ identifierOrType ];
			}
		}

		override public function destroy() : void
		{
			super.destroy();

			for ( var type : * in _typeDictionary )
			{
				var pool : ObjectPool = _typeDictionary[ type ];

				pool.deconstruct();

				_typeDictionary[ type ] = null;
				delete _typeDictionary[ type ];
			}
		}
	}
}

// singleton enforcer
class ObjectPoolerSingletonEnforcer
{
}
