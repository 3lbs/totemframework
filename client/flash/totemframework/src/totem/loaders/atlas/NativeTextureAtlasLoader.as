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

package totem.loaders.atlas
{

	import flash.filesystem.File;
	
	import dragonBones.factories.NativeFactory;
	import dragonBones.textures.ITextureAtlas;
	import dragonBones.textures.NativeTextureAtlas;
	
	import totem.loaders.BitmapDataLoader;
	import totem.loaders.starling.AtlasTextureCache;
	import totem.loaders.starling.DragonBonesFactoryCache;
	import totem.utils.DocumentService;

	public class NativeTextureAtlasLoader extends BitmapDataLoader
	{

		private var _textureAtlas : ITextureAtlas;

		private var _xmlData : XML;

		private var imageURL : String;

		public function NativeTextureAtlasLoader( url : String, imageUrl : String = "", id : String = "" )
		{
			super( url, id );

			this.imageURL = imageUrl;
		}

		override public function destroy() : void
		{
			super.destroy();

			_xmlData = null;

			_textureAtlas = null;
		}

		override public function start() : void
		{

			var file : File = new File( filename );

			_xmlData = new XML( DocumentService.getInstance().readFile( file ));

			filename = imageURL;

			super.start();

		}

		public function get textureAtlas() : ITextureAtlas
		{
			return _textureAtlas;
		}

		public function get xmlData() : XML
		{
			return _xmlData;
		}

		override protected function finished() : void
		{

			_textureAtlas = new NativeTextureAtlas( bitmapData, _xmlData );

			var factory : NativeFactory = new NativeFactory();

			factory.addTextureAtlas( _textureAtlas, id );

			DragonBonesFactoryCache.getInstance().createIndex( id, factory );

			//AtlasTextureCache.getInstance().createNativeAtlas( id, _textureAtlas );
			AtlasTextureCache.getInstance().createBitmapData( id, bitmapData );

			super.finished();
		}
	}
}
