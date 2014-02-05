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

package totem.utils
{

	import flash.utils.Dictionary;

	import totem.core.IDestroyable;

	public class DestroyUtil
	{

		public static function destroyDictionary( dict : Dictionary ) : void
		{
			for ( var key : String in dict )
			{
				if ( dict[ key ] is IDestroyable && !IDestroyable( dict[ key ]).destroyed )
				{
					IDestroyable( dict[ key ]).destroy();
				}

				dict[ key ] = null;
				delete dict[ key ];
			}
		}

		public function DestroyUtil()
		{
		}
	}
}
