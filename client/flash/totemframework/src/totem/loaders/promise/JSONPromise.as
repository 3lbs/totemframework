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

package totem.loaders.promise
{

	import gorilla.resource.IResource;
	import gorilla.resource.JSONResource;
	import gorilla.resource.Resource;
	import gorilla.resource.ResourceManager;

	import totem.core.Destroyable;
	import totem.monitors.promise.Deferred;
	import totem.monitors.promise.IPromise;
	import totem.monitors.promise.wait;

	public class JSONPromise extends Destroyable
	{

		public static function create( url : String ) : IPromise
		{
			return new JSONPromise( url ).promise();
		}

		private var _filename : String;

		private var _outcome : Deferred;

		public function JSONPromise( url : String )
		{
			_filename = url
			_outcome = new Deferred();
		}

		override public function destroy() : void
		{
			super.destroy();
			_outcome = null;
		}

		public function get filename() : String
		{
			return _filename;
		}

		public function promise() : IPromise
		{
			wait( 1, start );
			return _outcome;
		}

		private function onFailed( resource : Resource ) : void
		{
			_outcome.reject( null );
			destroy();
		}

		private function onJSONComplete( resource : JSONResource ) : void
		{
			_outcome.resolve( resource.JSONData );
			destroy();
		}

		private function start() : void
		{
			var resource : IResource = ResourceManager.getInstance().load( filename, JSONResource );
			resource.completeCallback( onJSONComplete );
			resource.failedCallback( onFailed );
		}
	}
}
