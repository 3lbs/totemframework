package totem.loaders.starling
{

	import flash.display.BitmapData;
	import flash.utils.Dictionary;
	
	import starling.textures.TextureAtlas;
	
	import totem.core.Destroyable;

	public class AtlasTextureCache extends Destroyable
	{

		private static var _instances : Dictionary = new Dictionary();

		private var _textures : Dictionary;

		private var _usages : Dictionary;

		private var _bitmapDatas : Dictionary;

		public function AtlasTextureCache( singletonEnforcer : SingletonEnforcer )
		{
			if ( !singletonEnforcer )
				throw new Error( "Cannot instantiate a singleton class. Use static getInstance instead." );

			_textures = new Dictionary();
			_bitmapDatas = new Dictionary();
			_usages = new Dictionary();
		}

		public static function getInstance( key : * = "default" ) : AtlasTextureCache
		{

			var instance : AtlasTextureCache = _instances[ key ];

			if ( instance == null )
			{
				instance = new AtlasTextureCache( new SingletonEnforcer());
				_instances[ key ] = instance;
			}
			return instance;
		}

		
		public static function destroyInstance ( key : * ) : Boolean
		{	
			var instance : AtlasTextureCache = _instances[ key ];
			
			if ( instance )
			{
				instance.destroy();
				
				_instances[ key ] = null;
				delete _instances[key];
				
				return true;
			}
			return false;
		}
		
		public function getTexture( url : String ) : TextureAtlas
		{
			return _textures[ url ];
		}

		public function getBitmapData( url : String ) : BitmapData
		{
			return _bitmapDatas[ url ];
		}

		public function createIndex( url : String, texture : TextureAtlas, force : Boolean = false ) : void
		{
			if ( !_textures[ url ])
				_textures[ url ] = texture;
		}

		public function createBitmapData( url : String, bitmapData : BitmapData, force : Boolean = false ) : void
		{
			if ( !_bitmapDatas[ url ] && bitmapData )
				_bitmapDatas[ url ] = bitmapData;
		}

		override public function destroy() : void
		{
			super.destroy();

			for ( var key : String in _textures )
			{
				var texure : TextureAtlas = _textures[ key ];
				texure.dispose();

				_textures[ key ] = null;
				delete _textures[ key ];
			}
			
			_textures = null;
			
			for ( key in _bitmapDatas )
			{
				var bd : BitmapData = _bitmapDatas[ key ];
				bd.dispose();

				_bitmapDatas[ key ] = null;
				delete _bitmapDatas[ key ];
			}

			_bitmapDatas = null;

		}

	}
}

class SingletonEnforcer
{
}
