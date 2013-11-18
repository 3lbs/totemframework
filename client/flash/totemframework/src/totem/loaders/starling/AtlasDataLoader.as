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

	import flash.display.BitmapData;

	import starling.textures.TextureAtlas;

	import totem.loaders.XMLDataLoader;
	import totem.monitors.CompleteMonitor;
	import totem.monitors.IRequireMonitor;
	import totem.monitors.IMonitor;

	public class AtlasDataLoader extends CompleteMonitor
	{

		private static const ATLAS_ID : String = "atlasid";

		private var _bitmapData : BitmapData;

		private var _textureAtlas : TextureAtlas;

		private var cacheBitmapData : Boolean;

		private var generateMipMap : Boolean;

		private var url : String;

		public function AtlasDataLoader( url : String, generateMipMap : Boolean = false, cacheBitmapData : Boolean = false, id : String = "" )
		{
			this.id = id || url;

			this.url = url;

			this.cacheBitmapData = cacheBitmapData;

			this.generateMipMap = generateMipMap;
		}

		public function get bitmapData() : BitmapData
		{
			return _bitmapData;
		}

		override public function destroy() : void
		{
			super.destroy();

			_textureAtlas = null;
			_bitmapData = null;
		}

		override public function start() : void
		{

			_textureAtlas = AtlasTextureCache.getInstance().getTexture( id );
			_bitmapData = AtlasTextureCache.getInstance().getBitmapData( id );

			if ( _textureAtlas )
			{
				finished();
				return;
			}

			var xmlLoader : IMonitor = addDispatcher( new XMLDataLoader( url ));
			var atlasLoader : IRequireMonitor = addDispatcher( new AtlasTextureLoader( url, null, generateMipMap, ATLAS_ID )) as IRequireMonitor;
			atlasLoader.requires( xmlLoader );

			super.start();
		}

		public function get textureAtlas() : TextureAtlas
		{
			return _textureAtlas;
		}

		override protected function finished() : void
		{
			var textureLoader : AtlasTextureLoader = getItemByID( ATLAS_ID );
			
			if ( textureLoader )
			{
				_textureAtlas = textureLoader.textureAtlas;
				_bitmapData = textureLoader.bitmapData;

				AtlasTextureCache.getInstance().createIndex( id, _textureAtlas );
			}

			if ( _bitmapData && cacheBitmapData )
				AtlasTextureCache.getInstance().createBitmapData( id, _bitmapData );

			super.finished();
		}
	}
}
