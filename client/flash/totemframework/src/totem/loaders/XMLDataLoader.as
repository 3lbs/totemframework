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

package totem.loaders
{

	import gorilla.resource.IResource;
	import gorilla.resource.Resource;
	import gorilla.resource.ResourceManager;
	import gorilla.resource.XMLResource;

	import totem.monitors.AbstractMonitorProxy;

	public class XMLDataLoader extends AbstractMonitorProxy
	{

		private var _XMLData : XML;

		private var filename : String;

		public function XMLDataLoader( url : String, id : String = "" )
		{
			this.id = id || url;

			filename = url;
		}

		public function get XMLData() : XML
		{
			return _XMLData;
		}

		override public function destroy() : void
		{
			super.destroy();

			_XMLData = null;
		}

		override public function start() : void
		{
			super.start();
			var resource : IResource = ResourceManager.getInstance().load( filename, XMLResource );
			resource.completeCallback( onXMLComplete );
			resource.failedCallback( onFailed );
		}

		override public function unloadData() : void
		{
			ResourceManager.getInstance().unload( filename, XMLResource );
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
	}
}
