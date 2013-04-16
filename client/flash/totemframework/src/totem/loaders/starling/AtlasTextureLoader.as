package totem.loaders.starling
{

	import flash.filesystem.File;

	import starling.textures.TextureAtlas;

	import totem.loaders.XMLDataLoader;

	public class AtlasTextureLoader extends TextureDataLoader
	{

		private var xmlData : XML;

		private var _textureAtlas : TextureAtlas;

		public function AtlasTextureLoader( url : String, genMipMap : Boolean, id : String = "" )
		{
			super( url, genMipMap, id );
		}

		public function get textureAtlas() : TextureAtlas
		{
			return _textureAtlas;
		}

		override public function start() : void
		{

			var xmlLoader : XMLDataLoader = getItemByID( filename );

			xmlData = xmlLoader.XMLData;
			var imageLoc : String = xmlLoader.XMLData.@imagePath;

			var file : File = new File( filename );
			var imageFile : File = file.parent.resolvePath( imageLoc );
			var imageURL : String = imageFile.nativePath;

			filename = imageURL;

			super.start();

		}

		override protected function finished() : void
		{

			_textureAtlas = new TextureAtlas( texture, xmlData );

			super.finished();
		}
	}
}
