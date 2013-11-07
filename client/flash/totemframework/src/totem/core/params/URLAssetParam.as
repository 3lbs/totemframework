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

package totem.core.params
{

	public class URLAssetParam extends BaseParam
	{

		private var _url : String;

		public function URLAssetParam()
		{
			super();
		}

		public function get url() : String
		{
			return _url;
		}

		public function set url( value : String ) : void
		{
			_url = value;
		}
	}
}

