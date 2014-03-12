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

package totem.loaders.starling
{

	import flash.filesystem.File;
	
	import starling.textures.TextureAtlas;
	
	import totem.loaders.XMLDataLoader;

	public class AtlasTextureLoader extends TextureDataLoader
	{

		private var _textureAtlas : TextureAtlas;

		private var imageURL : String;

		private var xmlData : XML;

		private var xmlLoader:XMLDataLoader;

		public function AtlasTextureLoader( url : String, imageUrl : String = "", genMipMap : Boolean = false, id : String = "" )
		{
			super( url, genMipMap, id );

			this.imageURL = imageUrl;
		}

		override public function start() : void
		{
			if ( !imageURL )
			{
				xmlLoader = getItemByID( filename );
	
				xmlData = xmlLoader.XMLData;
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

		override protected function finished() : void
		{

			_textureAtlas = new TextureAtlas( texture, xmlData );

			if ( xmlLoader )
			{
				xmlLoader.unloadData();
			}
			
			super.finished();
		}
	}
}
