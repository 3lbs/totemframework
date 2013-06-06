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

package totem.loaders
{

	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	import gorilla.resource.FlexSWFResource;
	import gorilla.resource.Resource;
	
	import org.casalib.util.StageReference;
	
	import totem.monitors.AbstractMonitorProxy;

	public class FlexSWFDataLoader extends AbstractMonitorProxy
	{

		public var swfResource : FlexSWFResource;

		private var loader : Loader;

		private var url : String;

		public function FlexSWFDataLoader( url : String, id : String = "" )
		{

			this.id = id || url;

			this.url = url;

		}

		override public function destroy() : void
		{
			super.destroy();

		}

		override public function start() : void
		{
			super.start();

			/*var resource : IResource = ResourceManager.getInstance().load( url, FlexSWFResource );
			resource.completeCallback( handleSwfComplete );
			resource.failedCallback( onFailed );*/

			loader = new Loader();

			loader.contentLoaderInfo.
			// you'll need to write a method named onLoaded to capture the COMPLETE event
			loader.contentLoaderInfo.addEventListener( Event.COMPLETE, handleSwfLoader );

			var context : LoaderContext = new LoaderContext( false, ApplicationDomain.currentDomain, null );
			//var context : LoaderContext = new LoaderContext();

			StageReference.getStage().addChild( loader );

			loader.addEventListener( "mx.managers.SystemManager.isBootstrapRoot", systemManagerHandler );
			loader.addEventListener( "mx.managers.SystemManager.isStageRoot", systemManagerHandler );

			loader.load( new URLRequest( url ), context );

		/* Specify the current application's security domain. */

		/* Specify a new ApplicationDomain, which loads the sub-app into a
		peer ApplicationDomain. */

			//swfLoader.load(
		}

		protected function handleSwfLoader( event : Event ) : void
		{
			// TODO Auto-generated method stub
			trace( "this!!" );
		}

		private function handleSwfComplete( resource : FlexSWFResource ) : void
		{
			swfResource = resource;
			finished();
		}

		private function onFailed( resource : Resource ) : void
		{
			failed();
		}

		private function systemManagerHandler( event : Event ) : void
		{
			event.preventDefault();
		}
	}
}
