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

package application.loadingscreen
{

	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;

	import totem.core.task.Task;
	import totem.display.scenes.BaseLoadingScreen;
	import totem.utils.MovieClipUtil;

	public class AppLoadingScreen extends BaseLoadingScreen
	{
		private var FRAME_RATE : Number;

		private var _loader : Loader;

		public function AppLoadingScreen( w : Number, h : Number )
		{
			super();

			contentWidth = w;
			contentHeight = h;

			addEventListener( Event.ADDED_TO_STAGE, init );
		}

		override public function destroy() : void
		{
			super.destroy();

			if ( _loader.parent )
				_loader.parent.removeChild( _loader );

			_loader.unloadAndStop();
			_loader = null;
		}

		protected function handleIntroLoaded( event : Event ) : void
		{

			MovieClipUtil.stopAllAnimation( _loader.content as MovieClip );

			var introTask : Intro3lbsScreenTask = new Intro3lbsScreenTask( this );
			introTask.onCompleted.add( handleComplete );
			introTask.start();

			updateDisplay();
		}

		protected function init( event : Event ) : void
		{
			removeEventListener( Event.ADDED_TO_STAGE, init );
			backgroundColor = 0x95936F;

			FRAME_RATE = stage.frameRate;
			stage.frameRate = 30;

			var _urlRequest : URLRequest = new URLRequest( "../resources/assets/intro3lbsmachine.swf" );
			_loader = new Loader();
			var _lc : LoaderContext = new LoaderContext( false, ApplicationDomain.currentDomain, null );

			_loader.contentLoaderInfo.addEventListener( Event.COMPLETE, handleIntroLoaded );
			_loader.load( _urlRequest, _lc );
			addChild( _loader );

		}

		private function handleComplete( task : Task ) : void
		{
			task.destroy();

			stage.frameRate = FRAME_RATE;
			dispatchEvent( new Event( Event.COMPLETE ));
		}
	}
}
