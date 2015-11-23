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

package localization
{

	import flash.globalization.LocaleID;
	import flash.globalization.StringTools;
	import flash.utils.describeType;

	import mx.events.ResourceEvent;
	import mx.resources.ResourceBundle;
	import mx.resources.ResourceManager;

	import totem.monitors.promise.DeferredEventDispatcher;
	import totem.monitors.promise.IPromise;

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

		public function deleteResourceBundleProperty( key : String, bundleName : String, l : String = "" ) : void
		{
			var locale : String = ( l == "" ) ? getCurrentLocale() : l;

			var bundle : ResourceBundle = ResourceManager.getInstance().getResourceBundle( locale, bundleName ) as ResourceBundle;

			var content : Object = bundle.content;

			if ( content[ key ])
			{
				content[ key ] = null;
				delete content[ key ];
			}

		}

		public function getString( bundle : String, key : String, param : Array = null, locale : String = null ) : String
		{
			var str : String = ResourceManager.getInstance().getString( bundle, key, param, locale );

			if ( str == "undefined" || !str )
			{
				return "B: " + bundle + " K: " + key;

			}
			return str;
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

		public function loadResourceBundle( url : String, locale : String ) : IPromise
		{
			ResourceManager.getInstance().loadResourceModule( url, true );

			var bundleLoader : ResourceBundleLoader = new ResourceBundleLoader( url, locale );

			var defferedEventDispatcher : DeferredEventDispatcher = new DeferredEventDispatcher( bundleLoader );
			defferedEventDispatcher.resolveOn( ResourceEvent.COMPLETE );

			return defferedEventDispatcher.promise();
		}

		public function removeResourceBundle( bundleName : String, l : String = "" ) : void
		{
			var locale : String = ( l == "" ) ? getCurrentLocale() : l;
			ResourceManager.getInstance().removeResourceBundle( locale, bundleName );
			ResourceManager.getInstance().update();
		}

		public function setResourceBundleProperty( key : String, property : Object, bundleName : String, l : String = "" ) : void
		{
			var locale : String = ( l == "" ) ? getCurrentLocale() : l;

			var bundle : ResourceBundle = ResourceManager.getInstance().getResourceBundle( locale, bundleName ) as ResourceBundle;

			var content : Object = bundle.content;
			content[ key ] = property;
		}
	}
}

class LocalizationSingletonEnforcer
{
}
