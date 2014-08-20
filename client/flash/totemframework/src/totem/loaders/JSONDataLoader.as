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
//   3lbs Copyright 2014 
//   For more information see http://www.3lbs.com 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package totem.loaders
{

	import flash.filesystem.File;

	import gorilla.resource.JSONResource;
	import gorilla.resource.Resource;

	import totem.monitors.RequiredProxy;

	public class JSONDataLoader extends RequiredProxy
	{

		private var _JSONData : Object;

		private var filename : String;

		public function JSONDataLoader( url : String, id : String = "" )
		{
			this.id = id || url;
			filename = url;
		}

		public function get JSONData() : Object
		{
			return _JSONData;
		}

		override public function destroy() : void
		{
			super.destroy();
			unloadData();
			_JSONData = null;
		}

		override public function start() : void
		{
			super.start();
			/*var resource : IResource = ResourceManager.getInstance().load( filename, JSONResource );
			resource.completeCallback( onJSONComplete );
			resource.failedCallback( onFailed );*/

			var file : File = new File( filename );

			if ( file.exists )
			{
				_JSONData = JSONNativeFileLoader.getObject( file );

				finished();
			}
			else
			{
				failed();
			}

		}

		override public function unloadData() : void
		{
			//ResourceManager.getInstance().unload( filename, JSONDataLoader );
			_JSONData = null;
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
	}
}
