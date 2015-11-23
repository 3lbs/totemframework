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

	import org.osflash.vanilla.extract;

	import totem.utils.DocumentService;

	public class JSONNativeFileLoader
	{

		public static function getObject( file : File ) : Object
		{
			return JSON.parse( DocumentService.getInstance().readFile( file ) || "");
		}

		public static function getObjectClass( file : File, clazz : Class ) : *
		{
			var object : * = extract( getObject( file ), clazz );

			return object;
		}
	}
}
