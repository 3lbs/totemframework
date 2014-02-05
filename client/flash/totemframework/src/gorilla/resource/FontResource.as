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

	import flash.text.Font;

	public class FontResource extends SWFResource
	{
		public function FontResource()
		{
			super();
		}

		public function getFont( fontName : String ) : Font
		{
			var FontLibrary : Class = getAssetClass( fontName ) as Class;

			if ( FontLibrary )
				return new FontLibrary();

			return null;
		}

		public function registerFont( fontName : String ) : void
		{
			var FontLibrary : Class = getAssetClass( fontName ) as Class;
			Font.registerFont( FontLibrary );
		}
	}
}
