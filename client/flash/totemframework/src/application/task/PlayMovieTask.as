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

package application.task
{

	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.events.NetStatusEvent;
	import flash.geom.Rectangle;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import totem.core.task.Task;
	import totem.math.BoxRectangle;
	import totem.utils.MobileUtil;

	public class PlayMovieTask extends Task
	{
		private var _delay : int;

		private var _screen : DisplayObjectContainer;

		private var _url : String;

		private var bitmapIntro : Bitmap;

		private var stream : NetStream;

		private var video : Video;

		public function PlayMovieTask( url : String, m : DisplayObjectContainer, delay : int )
		{
			super();
			_url = url;
			_screen = m;
			_delay = delay;
		}

		override public function destroy() : void
		{

			if ( video )
			{
				video.attachNetStream( null );
				video = null;
			}

			if ( stream )
			{
				stream.removeEventListener( NetStatusEvent.NET_STATUS, netStatusHandler );
				stream.client = {};
				stream.close();
				stream.dispose();
				stream = null;
			}

			if ( bitmapIntro )
			{
				if ( bitmapIntro.parent )
				{
					bitmapIntro.parent.removeChild( bitmapIntro );
				}

				bitmapIntro.bitmapData.dispose();
				bitmapIntro = null;
			}

			_screen = null;

			super.destroy();
		}

		public function ns_onMetaData( item : Object ) : void
		{
			var rect : Rectangle = MobileUtil.viewRect().clone();

			var vrect:BoxRectangle = new BoxRectangle();
			vrect.width= item.width;
			vrect.height = item.height;
			
			var s : Number = rect.width / item.width;
			vrect.multiply( s );
			
			video.width = vrect.width;
			video.height = vrect.height;
			video.y = ( rect.height - vrect.height ) * 0.5;
			
			
		}

		override protected function doStart() : void
		{

			var customClient : Object = { onMetaData: ns_onMetaData };

			var nc : NetConnection = new NetConnection();
			nc.connect( null );

			stream = new NetStream( nc );
			stream.client = customClient;

			stream.addEventListener( NetStatusEvent.NET_STATUS, netStatusHandler, false, 0, true );
			stream.bufferTime = 2;

			var rect : Rectangle = MobileUtil.viewRect().clone();
			video = new Video();
			
			video.width = rect.width;
			video.height = rect.height;
			
			video.attachNetStream( stream );

			_screen.addChild( video );
			stream.play( _url )

		}

		/**
		 *
		 * @param evt
		 *
		 */
		private function netStatusHandler( evt : NetStatusEvent ) : void
		{

			if ( evt.info.code == "NetStream.Play.FileStructureInvalid" )
			{
				trace( "The MP4's file structure is invalid" );
			}
			else if ( evt.info.code == "NetStream.Play.NoSupportedTrackFound" )
			{
				trace( "The MP4 doesn't contain any supported tracks" );
			}
			else if ( evt.info.level == "error" )
			{
				trace( "There was some sort of error with the NetStream", "Error", _url );
				complete();
			}

			if ( evt.info.code == "NetStream.Play.Stop" )
			{
				complete();
			}
		}
	}
}
