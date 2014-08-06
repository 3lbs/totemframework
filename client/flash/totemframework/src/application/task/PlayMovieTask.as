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

	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;

	import totem.core.task.Task;
	import totem.display.video.SimpleStageVideo;

	public class PlayMovieTask extends Task
	{
		private var _delay : int;

		private var _stageVideoProxy : SimpleStageVideo;

		private var _url : String;

		private var stream : NetStream;

		public function PlayMovieTask( url : String, m : SimpleStageVideo, delay : int )
		{
			super();
			_url = url;
			_stageVideoProxy = m;
			_delay = delay;
		}

		override public function destroy() : void
		{

			_stageVideoProxy = null;

			stream.close();
			stream = null;

			super.destroy();
		}

		public function onCuePoint( info : Object ) : void
		{
		}

		public function onMetaData( info : Object ) : void
		{
		}

		override protected function doStart() : void
		{

			//var customClient:Object = new Object(); customClient.onMetaData = metaDataHandler;

			var customClient:Object = new Object();
			
			
			var nc : NetConnection = new NetConnection();
			nc.connect( null );
			
			
			stream = new NetStream( nc );
			stream.client = customClient;

			stream.addEventListener( NetStatusEvent.NET_STATUS, netStatusHandler );

			//stream.close();
			_stageVideoProxy.attachNetStream( stream );

			stream.play( _url );

			_stageVideoProxy.toggle( false );
			//if ( _delay > 0 )
			//wait( _delay, complete );
		}

		private function netStatusHandler( evt : NetStatusEvent ) : void
		{
			if ( evt.info.code == "NetStream.Play.Stop" )
			{
				complete();
			}
		}
	}
}
