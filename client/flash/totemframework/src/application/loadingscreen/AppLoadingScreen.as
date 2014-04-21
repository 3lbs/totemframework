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

	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;

	import totem.core.task.Task;
	import totem.display.MovieClipFPSThrottle;
	import totem.display.scenes.BaseLoadingScreen;
	import totem.net.AppURL;
	import totem.utils.Alignment;
	import totem.utils.DisplayObjectUtil;
	import totem.utils.MobileUtil;

	public class AppLoadingScreen extends BaseLoadingScreen
	{
		private var FRAME_RATE : Number;

		private var _loader : Loader;

		private var delay : int;

		private var movieClipPlayer : MovieClipFPSThrottle;

		public function AppLoadingScreen( w : Number, h : Number, delay : int )
		{

			super();

			this.delay = delay;
			contentWidth = w;
			contentHeight = h;

			addEventListener( Event.ADDED_TO_STAGE, init );
		}

		override public function destroy() : void
		{

			if ( _loader.parent )
				_loader.parent.removeChild( _loader );

			_loader.unloadAndStop();

			_loader = null;
			
			super.destroy();
		}

		public function get3lbsScreen() : MovieClipFPSThrottle
		{
			return movieClipPlayer;
		}

		protected function handleIntroLoaded( event : Event ) : void
		{

			movieClipPlayer = new MovieClipFPSThrottle( _loader.content as MovieClip, 24 );

			addChild( movieClipPlayer );

			MobileUtil.viewRect();

			DisplayObjectUtil.alignInRect( movieClipPlayer, MobileUtil.viewRect(), Alignment.CENTER );

			updateDisplay();

			var introTask : Intro3lbsScreenTask = new Intro3lbsScreenTask( this, delay );
			introTask.onCompleted.add( handleComplete );
			introTask.start();
		}

		protected function init( event : Event ) : void
		{
			removeEventListener( Event.ADDED_TO_STAGE, init );
			backgroundColor = 0xFFFFFF;

			FRAME_RATE = stage.frameRate;
			stage.frameRate = 30;

			//var _urlRequest : URLRequest = new URLRequest( "/res/assets/intro3lbsmachine_portrait.swf" );

			var url : String = MobileUtil.isHD() ? "Intro3lbsMachineFinal_HD.swf" : "Intro3lbsMachineFinal_S.swf";
			var _urlRequest : URLRequest = new URLRequest( AppURL.ASSETS.getURL( url ));
			_loader = new Loader();
			var _lc : LoaderContext = new LoaderContext( false, ApplicationDomain.currentDomain, null );

			_loader.contentLoaderInfo.addEventListener( Event.COMPLETE, handleIntroLoaded );
			_loader.load( _urlRequest, _lc );

		}

		private function handleComplete( task : Task ) : void
		{
			task.destroy();

			stage.frameRate = FRAME_RATE;
			dispatchEvent( new Event( Event.COMPLETE ));
		}
	}
}
