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

package localization
{

	import flash.globalization.LocaleID;
	import flash.globalization.StringTools;
	import flash.utils.describeType;

	import mx.resources.ResourceManager;

	public class LocalizationManager
	{

		private static var _instance : LocalizationManager;

		public static function getCurrentLocale() : String
		{
			var value : String = new StringTools( LocaleID.DEFAULT ).actualLocaleIDName;
			return value;
		}

		public static function getInstance() : LocalizationManager
		{
			return _instance ||= new LocalizationManager( new LocalizationSingletonEnforcer());
		}

		public function LocalizationManager( singletonEnforcer : LocalizationSingletonEnforcer )
		{
			if ( !singletonEnforcer )
				throw new Error( "Cannot instantiate a singleton class. Use static getInstance instead." );
		}

		public function getString( bundle : String, key : String, param : Array = null, locale : String = null ) : String
		{
			return ResourceManager.getInstance().getString( bundle, key, param, locale ) || "B: " + bundle + " K: " + key;
		}

		public function injectInto( obj : * ) : Boolean
		{
			var xml : XML = describeType( obj );
			var resourceList : XMLList = xml..metadata.( @name == "Localize" );

			//trace( xml..metadata.( @name == "Resource" )[ 1 ].parent());

			for each ( var item : XML in resourceList )
			{
				var prop : XML = item.parent();
				var name : String = prop.@name;

				var bundle : String = item.arg.( @key == "bundle" ).@value;
				var key : String = item.arg.( @key == "key" ).@value;

				obj[ name ] = getString( bundle, key );
			}

			return false;
		}
	}
}

class LocalizationSingletonEnforcer
{
}
