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

package gorilla.resource
{

	import flash.utils.ByteArray;

	public class JSONResource extends Resource
	{
		private var _json : Object;

		private var _valid : Boolean = true;

		public function JSONResource()
		{
			super();
		}

		public function get JSONData() : Object
		{
			return _json;
		}

		override public function destroy() : void
		{
			super.destroy();

			_json = null;
		}

		override public function initialize( data : * ) : void
		{
			if ( data is ByteArray )
			{
				// convert ByteArray data to a string
				data = ( data as ByteArray ).readUTFBytes(( data as ByteArray ).length );
			}

			try
			{
				//_xml = new XML(data);
				//Logger.info( this, "json", data )
				_json = JSON.parse( data );
			}
			catch ( e : TypeError )
			{
				//Logger.print(this, "Got type error parsing JSON: " + e.toString());
				_valid = false;
			}

			onLoadComplete();
		}

		override protected function onContentReady( content : * ) : Boolean
		{
			return _valid;
		}
	}
}
