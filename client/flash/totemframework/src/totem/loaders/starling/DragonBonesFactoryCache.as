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
//   3lbs Copyright 2014 
//   For more information see http://www.3lbs.com 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package totem.loaders.starling
{

	import flash.utils.Dictionary;
	
	import dragonBones.factories.BaseFactory;

	public class DragonBonesFactoryCache
	{

		public static const NATIVE_EXT : String = "_native";

		private static var _instance : DragonBonesFactoryCache;

		public static function getInstance() : DragonBonesFactoryCache
		{
			return _instance ||= new DragonBonesFactoryCache( new SingletonEnforcer());

		}

		private var _factories : Dictionary = new Dictionary();

		public function DragonBonesFactoryCache( singletonEnforcer : SingletonEnforcer )
		{

			if ( !singletonEnforcer )
			{
				throw new Error( "Cannot instantiate a singleton class. Use static getInstance instead." );
			}

		}

		public function createIndex( id : String, factory : BaseFactory, force : Boolean = false ) : void
		{
			if ( !_factories[ id ] || force )
			{
				_factories[ id ] = factory;
			}
		}

		public function getFactory( id : String ) : BaseFactory
		{
			return _factories[ id ];
		}
	}
}

class SingletonEnforcer
{
}
