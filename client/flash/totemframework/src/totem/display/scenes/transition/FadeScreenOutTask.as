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

package totem.display.scenes.transition
{

	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;

	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;

	import totem.core.task.Task;
	import totem.display.scenes.BaseLoadingScreen;
	import totem.display.scenes.SceneState;

	public class FadeScreenOutTask extends Task
	{

		protected var _tempContainer : Sprite;

		private var _transition : String;

		private var loadingScreen : BaseLoadingScreen;

		private var screenFadeBitmapData : BitmapDataHolder;

		private var timelineMax : TimelineMax;

		public function FadeScreenOutTask( screen : BaseLoadingScreen, screenBitmapData : BitmapDataHolder, transition : String )
		{
			super();

			_transition = transition;

			loadingScreen = screen;

			_tempContainer = new Sprite();

			screenFadeBitmapData = screenBitmapData;

		}

		override protected function complete() : Boolean
		{
			if ( _tempContainer.parent )
				_tempContainer.parent.removeChild( _tempContainer );

			_tempContainer.graphics.clear();
			_tempContainer = null;

			timelineMax.clear();
			timelineMax = null;

			loadingScreen = null;

			screenFadeBitmapData = null;
			
			return super.complete();
		}

		override protected function doStart() : void
		{


			var time : Number = GroupTransitionTask.FADE_TIME_QUICK;

			var g : Graphics = _tempContainer.graphics;
			g.clear();
			if ( _transition == SceneState.TRANSITION_IMAGE )
			{
				screenFadeBitmapData.bitmapData.draw( loadingScreen );
				loadingScreen.finished();
				
				time = GroupTransitionTask.FADE_TIME_IMAGE;
				g.beginBitmapFill( screenFadeBitmapData.bitmapData );
				g.drawRect( 0, 0, loadingScreen.contentWidth, loadingScreen.contentHeight );
			}
			else
			{
				g.beginFill( 0 );
				g.drawRect( 0, 0, loadingScreen.contentWidth, loadingScreen.contentHeight );
				g.endFill();
			}

			loadingScreen.addChild( _tempContainer );
			loadingScreen.backgroundVisible = false;

			timelineMax = new TimelineMax({ onComplete: complete, delay: .5 });
			timelineMax.stop();
			timelineMax.append( new TweenMax( _tempContainer, time, { tint: 0xFFFFFF }));
			timelineMax.append( new TweenMax( _tempContainer, time, { alpha: 0 }));
			timelineMax.play()
		}
	}
}
