package totem.loaders
{

	import gorilla.resource.IResource;
	import gorilla.resource.JSONResource;
	import gorilla.resource.Resource;
	import gorilla.resource.ResourceManager;
	
	import totem.monitors.RequiredProxy;

	public class JSONDataLoader extends RequiredProxy
	{
		private var filename : String;

		private var _JSONData : Object;

		public function JSONDataLoader( url : String, id : String = "" )
		{
			this.id = id || url;
			filename = url;
		}

		override public function start() : void
		{
			super.start();
			var resource : IResource = ResourceManager.getInstance().load( filename, JSONResource );
			resource.completeCallback( onJSONComplete );
			resource.failedCallback( onFailed );
		}

		private function onFailed( resource : Resource ) : void
		{
			failed();
		}

		private function onJSONComplete( resource : JSONResource ) : void
		{
			_JSONData = resource.JSONData;
			finished();
		}

		override public function destroy() : void
		{
			super.destroy();
			_JSONData = null;
		}

		public function get JSONData() : Object
		{
			return _JSONData;
		}
	}
}
