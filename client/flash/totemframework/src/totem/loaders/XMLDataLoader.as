package totem.loaders
{

	import gorilla.resource.IResource;
	import gorilla.resource.Resource;
	import gorilla.resource.ResourceManager;
	import gorilla.resource.XMLResource;
	
	import totem.monitors.AbstractMonitorProxy;

	public class XMLDataLoader extends AbstractMonitorProxy
	{
		private var filename : String;

		private var _XMLData : XML;

		public function XMLDataLoader( url : String, id : String = "" )
		{
			this.id = id || url;

			filename = url;
		}

		override public function start() : void
		{
			super.start();
			var resource : IResource = ResourceManager.getInstance().load( filename, XMLResource );
			resource.completeCallback( onXMLComplete );
			resource.failedCallback( onFailed );
		}

		private function onFailed( resource : Resource ) : void
		{
			failed();
		}

		private function onXMLComplete( resource : XMLResource ) : void
		{
			_XMLData = resource.XMLData;
			finished();
		}

		override public function destroy() : void
		{
			super.destroy();
			_XMLData = null;
		}

		public function get XMLData() : XML
		{
			return _XMLData;
		}
	}
}
