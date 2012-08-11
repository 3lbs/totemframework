package totem.display.builder
{
	import flash.display.BitmapData;
	import flash.events.Event;
	
	import gorilla.resource.IResource;
	import gorilla.resource.IResourceManager;
	import gorilla.resource.ImageResource;
	import gorilla.resource.Resource;
	import gorilla.resource.ResourceManager;
	
	import totem.monitors.AbstractProxy;
	import totem.net.URLManager;
	import totem.net.getURL;

	public class BitmapDataFactory extends AbstractProxy
	{

		private var filename : String;

		private var _bitmapData : BitmapData;

		public function BitmapDataFactory( url : String, id : String = "" )
		{
			this.id = id || url;

			filename = getURL( url , URLManager.ASSET_URL );
		}

		override public function start() : void
		{
			var resource : IResource = ResourceManager.getInstance().load( filename, ImageResource );
			resource.completeCallback( onBitmapComplete );
			resource.failedCallback( onFailed );
		}
		
		private function onFailed( resource : Resource ):void
		{
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
			_bitmapData = null;
		}

		public function get bitmapData() : BitmapData
		{
			return _bitmapData;
		}

	}
}

