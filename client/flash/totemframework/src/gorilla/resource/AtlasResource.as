package gorilla.resource
{

	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	import ladydebug.Logger;

	public class AtlasResource extends Resource
	{

		private var _textureAtlas : TextureAtlas;

		private var fileType : String;

		public function AtlasResource()
		{
			super();
		}

		public function get XMLData() : XML
		{
			return _xml;
		}
		
		/**
		 * Get the raw BitmapData that was loaded.
		 */
		public function  get bitmapData():BitmapData
		{
			return _bitmapData;
		}
		
		override public function initialize( data : * ) : void
		{
			try
			{
				_xml = new XML( data );
			}
			catch ( e : TypeError )
			{
				if ( data is ByteArray )
				{
					// convert ByteArray data to a string
					data = ( data as ByteArray ).readUTFBytes(( data as ByteArray ).length );
				}
				
				try
				{
					_xml = new XML( data );
				}
				catch ( e : TypeError )
				{
					Logger.print( this, "Got type error parsing XML: " + e.toString());
					_valid = false;
				}
			}

			var imageLoc : String = XMLData.@imagePath;
			
			var file : File = new File( filename );
			var imageFile : File = file.parent.resolvePath( imageLoc );
			var imageURL : String = imageFile.nativePath;
			
			var resourceClass : Class = ( imageFile.extension == "atf" ) ? DataResource : ImageResource;

			var resource : IResource = ResourceManager.getInstance().load( imageURL, resourceClass );
			resource.completeCallback( onBitmapComplete );
			resource.failedCallback( onFailed );
			
		}

		private function onBitmapComplete( resource : Resource ) : void
		{
			
			/*if ( resource is ImageResource )
			{
				_texture = Texture.fromBitmapData( ImageResource( resource ).bitmapData, generateMipMaps );
				_bitmapData = ImageResource( resource ).bitmapData;
			}
			else
			{
				_texture = Texture.fromAtfData( DataResource( resource ).data, 1, generateMipMaps );
			}
			
			_textureAtlas = new TextureAtlas( _texture, _xml );
			
			var image : Resource = resource;*/
		}

		
		private function onFailed( resource : Resource ) : void
		{
			_valid = false;
			
			onLoadComplete( null );
		}
		

		public function get textureAtlas() : TextureAtlas
		{
			return _textureAtlas;
		}
		
		private var _valid : Boolean = true;
		
		protected var _bitmapData:BitmapData = null;
		
		private var _xml : XML = null;

	}
}
