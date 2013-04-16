package totem.loaders.starling
{

	import flash.display.BitmapData;
	
	import starling.textures.TextureAtlas;
	
	import totem.loaders.XMLDataLoader;
	import totem.monitors.CompleteMonitor;
	import totem.monitors.IRequireMonitor;
	import totem.monitors.IStartMonitor;

	public class AtlasDataLoader extends CompleteMonitor
	{
		private var url : String;

		private var _textureAtlas : TextureAtlas;

		private var _bitmapData : BitmapData;

		private var generateMipMap : Boolean;

		private static const ATLAS_ID : String = "atlasid";


		public function AtlasDataLoader( url : String, id : String = "", generateMipMap : Boolean = false )
		{
			this.id = id || url;

			this.url = url;

			this.generateMipMap = generateMipMap;
		}

		public function get textureAtlas() : TextureAtlas
		{
			return _textureAtlas;
		}
 
		public function get bitmapData() : BitmapData
		{
			return _bitmapData;
		}

		override public function start() : void
		{
			
			_textureAtlas = AtlasTextureCache.getInstance().getTexture( url );
			_bitmapData = AtlasTextureCache.getInstance().getBitmapData( url );

			if ( _textureAtlas )
			{
				complete();
				return;
			}
			
			var xmlLoader : IStartMonitor = addDispatcher( new XMLDataLoader( url ));
			var atlasLoader : IRequireMonitor = addDispatcher( new AtlasTextureLoader( url, generateMipMap, ATLAS_ID )) as IRequireMonitor;
			atlasLoader.requires( xmlLoader );

			super.start();
		}

		override protected function finished() : void
		{
			var textureLoader : AtlasTextureLoader = getItemByID( ATLAS_ID );
			_textureAtlas = textureLoader.textureAtlas;
			_bitmapData = textureLoader.bitmapData;
			
			AtlasTextureCache.getInstance().createIndex( url, _textureAtlas );
			
			if ( _bitmapData )
				AtlasTextureCache.getInstance().createBitmapData( url, _bitmapData );
	
			super.finished();
		}

		override public function destroy() : void
		{
			super.destroy();

			_textureAtlas = null;
			_bitmapData = null;
		}
	}
}
