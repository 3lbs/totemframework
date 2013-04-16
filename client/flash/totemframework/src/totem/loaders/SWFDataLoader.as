package totem.loaders
{

	import gorilla.resource.IResource;
	import gorilla.resource.Resource;
	import gorilla.resource.ResourceManager;
	import gorilla.resource.SWFResource;
	
	import totem.monitors.AbstractMonitorProxy;

	public class SWFDataLoader extends AbstractMonitorProxy
	{
		private var url : String;

		public var swfResource : SWFResource;

		public function SWFDataLoader( url : String, id : String = "" )
		{

			this.id = id || url;

			this.url = url;

		}

		override public function start() : void
		{
			super.start();

			var resource : IResource = ResourceManager.getInstance().load( url, SWFResource );
			resource.completeCallback( onBitmapComplete );
			resource.failedCallback( onFailed );
		}

		private function onFailed( resource : Resource ) : void
		{
			failed();
		}

		private function onBitmapComplete( resource : SWFResource ) : void
		{
			swfResource = resource;
			finished();
		}

		
		override public function destroy():void
		{
			super.destroy();
			
		}
	}
}
