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

	import application.param.FontParam;

	import flash.system.ApplicationDomain;
	import flash.text.Font;

	import gorilla.resource.FontResource;
	import gorilla.resource.IResource;
	import gorilla.resource.Resource;
	import gorilla.resource.ResourceManager;

	import totem.monitors.AbstractMonitorProxy;

	public class FontsLoader extends AbstractMonitorProxy
	{

		public static function hasFont( value : String ) : Boolean
		{

			var fonts : Array = Font.enumerateFonts( true );

			for each ( var font : Font in fonts )
			{
				//trace( font.fontName + ":" + font.fontType );

				if ( font.fontName == value )
				{
					return true;
				}
			}
			return false;
		}

		private var fontNames : Vector.<FontParam>;

		private var fontResource : FontResource;

		private var url : String;

		public function FontsLoader( url : String, fontNames : Vector.<FontParam>, id : String = "" )
		{
			this.fontNames = fontNames;
			this.id = id || url;
			this.url = url;
		}

		override public function start() : void
		{
			super.start();

			var resource : IResource = ResourceManager.getInstance().load( url, FontResource );
			resource.completeCallback( handleSwfComplete );
			resource.failedCallback( onFailed );
		}

		private function handleSwfComplete( resource : FontResource ) : void
		{
			fontResource = resource;

			var l : int = fontNames.length;

			var fontParam : FontParam;

			while ( l-- )
			{
				fontParam = fontNames[ l ];

				if ( !hasFont( fontParam.clazz ))
				{
					fontResource.registerFont( fontParam.clazz );
				}
			}

			/*	var FontLibrary : Class;

				var applicationDomain : ApplicationDomain = loader.content.loaderInfo.applicationDomain;
				//checkFonts();

				for each ( var fontName : String in fontNames )
				{
					if ( applicationDomain.hasDefinition( fontName ))
					{
						FontLibrary = applicationDomain.getDefinition( fontName ) as Class;

						if ( FontLibrary )
						{
							var font : Font = new FontLibrary();
							Font.registerFont( FontLibrary );
						}
					}
				}*/

			finished();
		}

		private function onFailed( resource : Resource ) : void
		{
			failed();
		}
	}
}
