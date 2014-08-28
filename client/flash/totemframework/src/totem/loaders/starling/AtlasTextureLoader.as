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

	import dragonBones.textures.StarlingTextureAtlas;

	import flash.filesystem.File;

	import starling.textures.TextureAtlas;

	import totem.loaders.XMLDataLoader;

	public class AtlasTextureLoader extends TextureDataLoader
	{

		private var _textureAtlas : TextureAtlas;

		private var _xmlData : XML;

		private var cache : Boolean;

		private var imageURL : String;

		private var xmlLoader : XMLDataLoader;

		public function AtlasTextureLoader( url : String, imageUrl : String = "", genMipMap : Boolean = false, id : String = "", cache : Boolean = false )
		{
			super( url, genMipMap, id );

			this.cache = cache;
			this.imageURL = imageUrl;
		}

		override public function destroy() : void
		{
			super.destroy();

			xmlLoader.destroy();
			xmlLoader = null;

			_xmlData = null;

			_textureAtlas = null;
		}

		override public function start() : void
		{
			xmlLoader = getItemByID( filename );

			_xmlData = xmlLoader.XMLData;

			if ( !imageURL )
			{
				var imageLoc : String = xmlLoader.XMLData.@imagePath;

				var file : File = new File( filename );
				var imageFile : File = file.parent.resolvePath( imageLoc );
				imageURL = imageFile.url;
			}

			filename = imageURL;

			super.start();

		}

		public function get textureAtlas() : TextureAtlas
		{
			return _textureAtlas;
		}

		public function get xmlData() : XML
		{
			return _xmlData;
		}

		override protected function finished() : void
		{

			_textureAtlas = new TextureAtlas( texture, _xmlData );

			if ( xmlLoader )
			{
				xmlLoader.unloadData();
			}

			if ( cache )
			{
				AtlasTextureCache.getInstance().createIndex( id, _textureAtlas );
			}

			super.finished();
		}
	}
}
