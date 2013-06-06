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

package gorilla.resource
{

	import flash.display.Loader;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import mx.controls.SWFLoader;
	
	import org.casalib.util.StageReference;

	public class FlexSWFResource extends SWFResource
	{
		
		public static var flexAppDomain : ApplicationDomain = new ApplicationDomain();
		
		public function FlexSWFResource()
		{
			super();
		}

		protected function handleApplicationComplete( event : Event ) : void
		{
			var stage : Stage = StageReference.getStage();
		
			if ( _loader.parent )
				stage.removeChild( _loader );
	
			clip.visible = true;
			
			_isLoaded = true;
			_urlLoader = null;
			_loader = null;

			complete.dispatch( this );
			failed.removeAll();
		}

		override public function initialize( data : * ) : void
		{
			if ( !( data is ByteArray ))
				throw new Error( "Default Resource can only process ByteArrays!" );
			
			var loader : Loader = new Loader();
			loader.contentLoaderInfo.addEventListener( Event.COMPLETE, onLoadComplete );
			loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, onDownloadError );
			loader.contentLoaderInfo.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onDownloadSecurityError );
			
			var _lc : LoaderContext = new LoaderContext( false, flexAppDomain, null );
			_lc.allowCodeImport = true;
			
			loader.loadBytes( data, _lc );
			
			var stage : Stage = StageReference.getStage();
			stage.addChild( loader );
			
			// Keep reference so the Loader isn't GC'ed.
			_loader = loader;
		}

		
		override protected function onLoadComplete( event : Event = null ) : void
		{
			if ( onContentReady( event ? event.target.content : null ))
			{
				// we have to do this because Flex swf run code that will fail if not on stage
				// Focus manager

				//var stage : Stage = StageReference.getStage();
				clip.visible = false;
				clip.addEventListener( "applicationComplete", handleApplicationComplete );
				//stage.addChild( clip );
			}
			else
			{
				onFailed( "Got false from onContentReady - the data wasn't accepted." );
				return;
			}

		}
	}
}
