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
	import gorilla.resource.SWFResource;

	import totem.monitors.AbstractMonitorProxy;

	public class SWFDataLoader extends AbstractMonitorProxy
	{

		public var swfResource : SWFResource;

		protected var url : String;

		public function SWFDataLoader( url : String, id : String = "" )
		{

			this.id = id || url;

			this.url = url;

		}

		override public function destroy() : void
		{
			super.destroy();

		}

		override public function start() : void
		{
			super.start();

			var resource : IResource = ResourceManager.getInstance().load( url, SWFResource );
			resource.completeCallback( handleSwfComplete );
			resource.failedCallback( onFailed );
		}

		private function handleSwfComplete( resource : SWFResource ) : void
		{
			swfResource = resource;
			finished();
		}

		private function onFailed( resource : Resource ) : void
		{
			failed();
		}
	}
}
