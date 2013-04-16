package totem.library
{

	import flash.utils.Dictionary;

	public class TotemAssetLibrary
	{

		private static var _instances : Dictionary = new Dictionary();

		// handle creation and pooling of game objects

		public function TotemAssetLibrary( singletonEnforcer : TotemAssetSingletonEnforcer )
		{
			if ( !singletonEnforcer )
				throw new Error( "Cannot instantiate a singleton class. Use static getInstance instead." );
		}

		public static function getInstance( key : * = "default" ) : TotemAssetBundle
		{
			var instance : TotemAssetBundle = _instances[ key ];

			if ( instance == null )
			{
				instance = new TotemAssetBundle();
				_instances[ key ] = instance;
			}
			return instance;
		}

		public static function disposeBundle( key : * ) : Boolean
		{
			var instance : TotemAssetBundle = _instances[ key ]

			if ( instance )
			{
				instance.destroy();
				_instances[ key ] = null;
				delete _instances[ key ];

				return true;
			}
			return false;
		}

	}
}

class TotemAssetSingletonEnforcer
{
}
