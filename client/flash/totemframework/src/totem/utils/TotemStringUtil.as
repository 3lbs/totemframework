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

package totem.utils
{

	public class TotemStringUtil
	{

		public static function fromCamelCase( str : String, capitaliseFirst : Boolean ) : String
		{
			var r : RegExp = /(^[a-z]|[A-Z0-9])[a-z]*/g;
			var result : Array = str.match( r );

			if ( result.length > 0 )
			{
				if ( capitaliseFirst )
					result[ 0 ] = String( result[ 0 ]).charAt( 0 ).toUpperCase() + String( result[ 0 ]).substring( 1 );

				return result.join( " " );
			}

			return str;
		}

		public static function toCamelCase( TEXT : String ) : String
		{
			TEXT = TEXT.toLowerCase()
			var words = TEXT.split( " " )

			for ( var i = 1; i < words.length; i++ )
			{
				words[ i ] = words[ i ].charAt( 0 ).toUpperCase() + words[ i ].substring( 1 )
			}
			TEXT = words.join( "" )
			return TEXT
		}

		public function TotemStringUtil()
		{
		}
	}
}
