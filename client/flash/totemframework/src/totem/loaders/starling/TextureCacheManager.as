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
	
	import starling.textures.Texture;
	
	import totem.core.Destroyable;

	public class TextureCacheManager extends Destroyable
	{
		private static var _instances : Dictionary = new Dictionary();

		public static function destroyInstance( key : * ) : Boolean
		{
			var instance : TextureCacheManager = _instances[ key ];

			if ( instance )
			{
				instance.destroy();

				_instances[ key ] = null;
				delete _instances[ key ];

				return true;
			}
			return false;
		}

		public static function getInstance( key : * = "default" ) : TextureCacheManager
		{

			var instance : TextureCacheManager = _instances[ key ];

			if ( instance == null )
			{
				instance = new TextureCacheManager( new SingletonEnforcer());
				_instances[ key ] = instance;
			}
			return instance;
		}

		private var _textures : Dictionary;

		
		public function TextureCacheManager( singletonEnforcer : SingletonEnforcer )
		{
			if ( !singletonEnforcer )
				throw new Error( "Cannot instantiate a singleton class. Use static getInstance instead." );

			_textures = new Dictionary();
		}

		public function createIndex( url : String, textures : Vector.<Texture>, force : Boolean = false ) : void
		{
			if ( _textures[ url ] && force )
			{
				destroyList( _textures[ url ]);
				_textures[ url ] = null;
			}

			if ( !_textures[ url ] || force )
				_textures[ url ] = textures;
		}

		override public function destroy() : void
		{
			super.destroy();

			for ( var key : String in _textures )
			{
				var texure : Vector.<Texture> = _textures[ key ];

				while ( texure.length )
					texure.pop().dispose();

				_textures[ key ] = null;
				delete _textures[ key ];
			}

			_textures = null;

		}

		public function getTextures( url : String ) : Vector.<Texture>
		{
			return _textures[ url ];
		}

		public function hasTextures( url : String ) : Boolean
		{
			return _textures[ url ] != null;
		}

		private function destroyList( textures : Vector.<Texture> ) : void
		{
			while ( textures.length )
				textures.pop().dispose();
		}
	}
}

class SingletonEnforcer
{
}
