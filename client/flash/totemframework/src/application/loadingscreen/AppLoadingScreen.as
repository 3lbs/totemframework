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

package application.loadingscreen
{

	import flash.events.Event;
	
	import totem.core.task.Task;
	import totem.display.scenes.BaseLoadingScreen;
	import totem.display.video.SimpleStageVideo;

	public class AppLoadingScreen extends BaseLoadingScreen
	{
		private var _url : String;

		private var delay : int;

		private var stageVideoProxy : SimpleStageVideo;

		public function AppLoadingScreen( url : String, w : Number, h : Number, delay : int )
		{

			super();

			_url = url;

			this.delay = delay;
			backgroundVisible = false;
			contentWidth = w;
			contentHeight = h;

			addEventListener( Event.ADDED_TO_STAGE, init );
		}

		override public function destroy() : void
		{

			stageVideoProxy.destroy();
			stageVideoProxy = null;

			super.destroy();
		}

		protected function handleStageVideoInit( event : Event ) : void
		{
			stageVideoProxy.removeEventListener( Event.INIT, handleStageVideoInit );

			var introTask : Intro3lbsScreenTask = new Intro3lbsScreenTask( _url, stageVideoProxy, delay );
			introTask.onCompleted.add( handleComplete );
			introTask.start();
		}

		protected function init( event : Event ) : void
		{
			backgroundVisible = false;
			removeEventListener( Event.ADDED_TO_STAGE, init );

			//var _urlRequest : URLRequest = new URLRequest( "/res/assets/intro3lbsmachine_portrait.swf" );
			//var url : String = MobileUtil.isHD() ? "Intro3lbsMachineFinal_HD.swf" : "Intro3lbsMachineFinal_S.swf";

			stageVideoProxy = new SimpleStageVideo( contentWidth, contentHeight );
			stageVideoProxy.addEventListener( Event.INIT, handleStageVideoInit );

			addChild( stageVideoProxy );
		}

		private function handleComplete( task : Task ) : void
		{
			task.destroy();

			//stage.frameRate = FRAME_RATE;
			dispatchEvent( new Event( Event.COMPLETE ));
		}
	}
}
