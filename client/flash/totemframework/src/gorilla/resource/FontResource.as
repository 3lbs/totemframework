package gorilla.resource
{
	import flash.events.Event;
	import flash.text.Font;
	

	public class FontResource extends SWFResource
	{
		public function FontResource()
		{
			super();
		}

		public function getFont() : void
		{

		}

		public function registerFont() : void
		{

		}
		
		override protected function onLoadComplete( event : Event = null ) : void
		{
			super.onLoadComplete( event );
			//var FontLibrary : Class = e.target.applicationDomain.getDefinition( "FontSwfDocumentClass" ) as Class;
			//Font.registerFont( FontLibrary.SketchetikLight );
			
			//appDomain.Font.enumerateFonts();
			
			var fontLibrarty : Class = getAssetClass( "Impact" ) as Class;
			
			Font.registerFont( fontLibrarty );
			
		}

	}
}
