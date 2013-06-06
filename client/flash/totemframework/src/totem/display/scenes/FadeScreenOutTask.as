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

package totem.display.scenes
{

	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	import totem.core.task.Task;

	public class FadeScreenOutTask extends Task
	{

		protected var _tempContainer : Sprite;

		private var _transition : String;

		private var loadingScreen : BaseLoadingScreen;

		private var screenFadeBitmapData : BitmapData;

		private var timelineMax : TimelineMax;

		public function FadeScreenOutTask( screen : BaseLoadingScreen, screenBitmapData : BitmapData, transition : String )
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

			loadingScreen.parentNode.removeScreen( loadingScreen );
			loadingScreen.visible = true;

			timelineMax.clear();
			timelineMax = null;

			loadingScreen = null;

			return super.complete();
		}

		override protected function doStart() : void
		{

			var g : Graphics;

			var time : Number = SceneTransitionTask.FADE_TIME_QUICK;

			if ( _transition == SceneState.TRANSITION_IMAGE )
			{
				screenFadeBitmapData.draw( loadingScreen );

				time = SceneTransitionTask.FADE_TIME_IMAGE;

				g = _tempContainer.graphics;
				g.clear();
				g.beginBitmapFill( screenFadeBitmapData );
				g.drawRect( 0, 0, loadingScreen.width, loadingScreen.height );
				g.endFill();
			}
			else
			{
				g = _tempContainer.graphics;
				g.clear();
				g.beginFill( 0 );
				g.drawRect( 0, 0, loadingScreen.width, loadingScreen.height );
				g.endFill();
			}

			if ( !_tempContainer.parent )
				loadingScreen.parent.addChildAt( _tempContainer, loadingScreen.parent.getChildIndex( loadingScreen ));

			loadingScreen.finished();
			loadingScreen.visible = false;

			timelineMax = new TimelineMax({ onComplete: complete, delay : .5 });
			timelineMax.stop();
			timelineMax.append( new TweenMax( _tempContainer, time, { tint: 0x000000 }));
			
			timelineMax.append( new TweenMax( _tempContainer, time, { alpha: 0 }));
			timelineMax.play()
		}
	}
}
