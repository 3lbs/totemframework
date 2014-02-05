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

	import flash.display.BitmapData;
	
	import gorilla.resource.IResource;
	import gorilla.resource.ImageResource;
	import gorilla.resource.Resource;
	import gorilla.resource.ResourceManager;
	
	import totem.monitors.RequiredProxy;

	public class BitmapDataLoader extends RequiredProxy implements IBitmapDataLoader
	{

		protected var filename : String;

		private var _bitmapData : BitmapData;

		public function BitmapDataLoader( url : String, id : Object = null )
		{
			this.id = id || url;

			filename = url;
		}

		public function get bitmapData() : BitmapData
		{
			return _bitmapData;
		}

		override public function destroy() : void
		{
			super.destroy();
			_bitmapData = null;
		}

		override public function start() : void
		{
			super.start();

			var resource : IResource = ResourceManager.getInstance().load( filename, ImageResource );
			resource.completeCallback( onBitmapComplete );
			resource.failedCallback( onFailed );
		}

		override public function unloadData() : void
		{
			ResourceManager.getInstance().unload( filename, ImageResource );
		}

		private function onBitmapComplete( resource : ImageResource ) : void
		{
			_bitmapData = resource.bitmapData;
			finished();
		}

		private function onFailed( resource : Resource ) : void
		{
			failed();
		}
	}
}

