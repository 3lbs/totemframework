package totem.loaders.starling
{

	import flash.display.BitmapData;
	
	import gorilla.resource.DataResource;
	import gorilla.resource.IResource;
	import gorilla.resource.ImageResource;
	import gorilla.resource.Resource;
	import gorilla.resource.ResourceManager;
	
	import starling.textures.Texture;
	
	import totem.monitors.RequiredProxy;
	import totem.utils.URLUtil;

	public class TextureDataLoader extends RequiredProxy
	{
		protected var filename : String;

		private var fileType : String;

		private var _texture : Texture;

		private var generateMipMaps : Boolean;

		private var _bitmapData : BitmapData;

		public function TextureDataLoader( url : String, genMipMap : Boolean, id : String = "" )
		{
			this.id = id || url;

			filename = url;
		}

		public function get bitmapData():BitmapData
		{
			return _bitmapData;
		}

		override public function start() : void
		{
			super.start();
			
			fileType = URLUtil.getFileExtension( filename );
			var resourceClass : Class = ( fileType == "atf" ) ? DataResource : ImageResource;

			var resource : IResource = ResourceManager.getInstance().load( filename, resourceClass );
			resource.completeCallback( onBitmapComplete );
			resource.failedCallback( onFailed );
		}

		private function onFailed( resource : Resource ) : void
		{
			failed();
		}

		private function onBitmapComplete( resource : Resource ) : void
		{

			if ( resource is ImageResource )
			{
				_texture = Texture.fromBitmapData( ImageResource( resource ).bitmapData, generateMipMaps );
				_bitmapData = ImageResource( resource ).bitmapData;
			}
			else
			{
				_texture = Texture.fromAtfData( DataResource( resource ).data, 1, generateMipMaps );
			}

			finished();
		}

		override public function destroy() : void
		{
			super.destroy();
			_texture = null;
			_bitmapData = null;
		}

		public function get texture() : Texture
		{
			return _texture;
		}
	}
}
