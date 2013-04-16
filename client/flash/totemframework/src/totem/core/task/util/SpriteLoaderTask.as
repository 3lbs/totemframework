package totem.core.task.util
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	
	import gorilla.resource.SWFResource;
	
	import totem.loaders.SWFDataLoader;

	public class SpriteLoaderTask extends DisplayLoaderTask
	{
		
		private var swfURL : String;
		
		private var spriteName : String;
		
		private var swfLoader : SWFDataLoader;
		
		
		public function SpriteLoaderTask( url : String, name : String )
		{
			swfURL = url;
			spriteName = name;
			super();
		}
		
		override protected function doStart() : void
		{
			super.doStart();
			
			swfLoader = new SWFDataLoader( swfURL, spriteName );
			swfLoader.addEventListener( Event.COMPLETE, handleAtlasComplete );
			swfLoader.start();
		}
		
		protected function handleAtlasComplete( event : Event ) : void
		{
			swfLoader.removeEventListener( Event.COMPLETE, handleAtlasComplete );
			
			var atlas : SWFResource = swfLoader.swfResource;
			
			var clazz : Class = atlas.getAssetClass( spriteName );
			
			
			var bitmapData : BitmapData = new clazz();
			
			sprite = new Bitmap( bitmapData );
			
			//sprite = new Image( atlas.getTexture( spriteName ));
			
			complete();
		}
		
		override public function destroy() : void
		{
			super.destroy();
			
			swfLoader = null;
			sprite = null;
		}
	}
}