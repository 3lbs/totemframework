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

package application.parents
{

	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.LocationChangeEvent;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	
	import totem.display.layout.TContainer;
	import totem.utils.MobileUtil;

	public class WebViewer extends TContainer
	{
		public var url : String;

		private var tempDirectory : String = "parents";

		private var webView : StageWebView;

		public function WebViewer( width : uint, height : uint )
		{
			contentWidth = width;
			contentHeight = height;
		}

		public function backHistory() : void
		{
			webView.historyBack();
		}

		override public function destroy() : void
		{
			super.destroy();

			
			webView.removeEventListener( ErrorEvent.ERROR, handleErrorLoading );
			webView.removeEventListener( Event.COMPLETE, handleCompleteLoad );
			webView.reload();
			webView.viewPort = null;
			webView.dispose();
			webView = null;

			if ( MobileUtil.isAndroid())
			{
				var destination : File = File.applicationStorageDirectory.resolvePath( tempDirectory );

				if ( destination.exists )
					destination.deleteDirectory( true );
			}
		}

		public function isHistoryBack() : Boolean
		{
			return webView.isHistoryBackEnabled;
		}

		public function copyFolder  ( file : File ) : void
		{
			//var file : File = new File( url );
			
			var path : String;
			
			if ( MobileUtil.isIOS())
			{
				path = new File( file.nativePath ).url;
			}
			else
			{
				var source : File =  file.parent;
				var destination : File = File.applicationStorageDirectory.resolvePath( tempDirectory );
				
				if ( !destination.exists )
				{
					destination.createDirectory();
				}
				
				source.copyTo( destination, true );
				path = "file://" + destination.resolvePath( file.name ).nativePath;
			}
		}
		
		public function loadPageURL( url : String ) : void
		{
			this.url = url;

			var file : File = new File( url );

			var path : String;

			if ( MobileUtil.isIOS())
			{
				path = new File( file.nativePath ).url;
			}
			else
			{
				var source : File =  file.parent;
				var destination : File = File.applicationStorageDirectory.resolvePath( tempDirectory );

				if ( !destination.exists )
				{
					destination.createDirectory();
				}

				source.copyTo( destination, true );
				path = "file://" + destination.resolvePath( file.name ).nativePath;
			}

			webView = new StageWebView();

			if ( StageWebView.isSupported )
			{
				webView.viewPort = new Rectangle( x, y, contentWidth, contentHeight );
				webView.addEventListener( ErrorEvent.ERROR, handleErrorLoading )
				webView.addEventListener( Event.COMPLETE, handleCompleteLoad );
				webView.addEventListener( LocationChangeEvent.LOCATION_CHANGE, handleLocalChange );
				webView.stage = this.stage;
				webView.loadURL( path );
			}
			else
			{
				throw new Error( "Stage WebView not supported on this device" );
			}
		}

		protected function handleCompleteLoad( event : Event ) : void
		{
			dispatchEvent( event.clone());
		}

		protected function handleErrorLoading( event : ErrorEvent ) : void
		{
			throw new Error( "Loading pages" );
			dispatchEvent( event.clone());
		}

		protected function handleLocalChange( event : LocationChangeEvent ) : void
		{

		}
	}
}
