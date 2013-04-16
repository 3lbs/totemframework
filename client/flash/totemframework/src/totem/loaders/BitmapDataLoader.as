package totem.loaders
{
	import flash.display.BitmapData;
	
	import gorilla.resource.IResource;
	import gorilla.resource.ImageResource;
	import gorilla.resource.Resource;
	import gorilla.resource.ResourceManager;
	
	import totem.monitors.AbstractMonitorProxy;

	public class BitmapDataLoader extends AbstractMonitorProxy
	{

		private var filename : String;

		private var _bitmapData : BitmapData;

		public function BitmapDataLoader( url : String, id : Object = null )
		{
			this.id = id || url;

			filename = url;
		}

		override public function start() : void
		{
			super.start();
			
			var resource : IResource = ResourceManager.getInstance().load( filename, ImageResource );
			resource.completeCallback( onBitmapComplete );
			resource.failedCallback( onFailed );
		}
		
		private function onFailed( resource : Resource ):void
		{
			failed();
		}
		
		private function onBitmapComplete( resource : ImageResource ) : void
		{
			_bitmapData = resource.bitmapData;
			finished();
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

