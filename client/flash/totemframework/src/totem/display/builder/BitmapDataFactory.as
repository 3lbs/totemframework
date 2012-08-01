package totem.display.builder
{
	import flash.display.BitmapData;
	import flash.events.Event;
	
	import gorilla.resource.IResource;
	import gorilla.resource.IResourceManager;
	import gorilla.resource.ImageResource;
	
	import totem.monitors.AbstractProxy;
	import totem.net.URLManager;
	import totem.net.getURL;

	public class BitmapDataFactory extends AbstractProxy
	{

		public var resourceManager : IResourceManager;

		private var filename : String;

		private var _bitmapData : BitmapData;

		public function BitmapDataFactory( manager : IResourceManager, url : String, id : String = "" )
		{
			this.id = id || url;

			resourceManager = manager;

			filename = getURL( url , URLManager.ASSET_URL );
		}

		override public function start() : void
		{
			var resource : IResource = resourceManager.load( filename, ImageResource );
			resource.completeCallback( onBitmapComplete );
			resource.failedCallback( failed );
		}

		private function onBitmapComplete( resource : ImageResource ) : void
		{
			_bitmapData = resource.bitmapData;
			factoryComplete();
		}

		private function factoryComplete() : void
		{
			dispatchEvent( new Event( Event.COMPLETE ));
		}

		override public function destroy() : void
		{
			super.destroy();
			resourceManager = null;
			_bitmapData = null;
		}

		public function get bitmapData() : BitmapData
		{
			return _bitmapData;
		}

	}
}

