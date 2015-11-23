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

	import flash.events.IEventDispatcher;

	import mx.events.ResourceEvent;
	import mx.resources.ResourceManager;

	import totem.events.RemovableEventDispatcher;

	public class ResourceBundleLoader extends RemovableEventDispatcher
	{

		private var _locale : String;

		public function ResourceBundleLoader( url : String, locale : String )
		{

			_locale = locale;

			var eventDispatcher : IEventDispatcher = ResourceManager.getInstance().loadResourceModule( url, true );
			eventDispatcher.addEventListener( ResourceEvent.COMPLETE, completeHandler );
			super();
		}

		private function completeHandler( event : ResourceEvent ) : void
		{
			ResourceManager.getInstance().localeChain = [ _locale ];
			dispatchEvent( event.clone());
		}
	}
}
