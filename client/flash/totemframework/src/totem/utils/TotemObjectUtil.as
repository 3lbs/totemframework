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

	import flash.utils.describeType;

	public class TotemObjectUtil
	{
		/**
		 * 
		 * @param objectA properties will be copied into objectB
		 * @param objectB will be copied into
		 * @return  objectB with the properties of objectA
		 * 
		 */		
		public static function mergeInto( objectA : Object, objectB : Object ) : Object
		{

			var xml : XML = describeType( objectB );
			var resourceList : XMLList = xml..accessor.( @access  == "readwrite" );
			//trace( resourceList.toString());

			//var resourceList3 : XMLList = xml..metadata.( @name == "Bindable" );

			//trace( xml..metadata.( @name == "Resource" )[ 1 ].parent());
			var property : String;

			for each ( var item : XML in resourceList )
			{
				//var prop : XML = item.parent();
				var name : String = item.@name;

				var tags : XMLList = item..metadata.(@name == "Transient" );
				
				if ( tags.length() == 0 )
				{
					objectB[ name ] = objectA[ name ];
				}
				
				//trace( tags.length() );
			}


			return objectB;
		}

		public function TotemObjectUtil()
		{
		}
	}
}
