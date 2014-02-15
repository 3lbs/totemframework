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
	import com.greensock.plugins.TintPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	
	import totem.core.task.Task;
	import totem.display.scenes.BaseLoadingScreen;
	import totem.display.scenes.SceneState;

	public class FadeScreenInTask extends Task
	{

		protected var _tempContainer : Sprite;

		private var _transition : String;

		private var loadingScreen : BaseLoadingScreen;

		private var screenFadeBitmapData : BitmapDataHolder;

		private var skipAlpha : Boolean;

		private var timelineMax : TimelineMax;

		public function FadeScreenInTask( ls : BaseLoadingScreen, screenBitmapData : BitmapDataHolder, transition : String )
		{
			super();

			_transition = transition;

			loadingScreen = ls;

			screenFadeBitmapData = screenBitmapData;

			_tempContainer = new Sprite();
			_tempContainer.mouseEnabled = false;
		}

		override protected function complete() : Boolean
		{
			timelineMax.clear();
			timelineMax = null;

			screenFadeBitmapData = null;

			loadingScreen.displayContent = true;
			loadingScreen.backgroundColor = 0;
			loadingScreen = null;

			if ( _tempContainer.parent )
				_tempContainer.parent.removeChild( _tempContainer );

			_tempContainer.graphics.clear();
			_tempContainer = null;
			return super.complete();
		}

		override protected function doStart() : void
		{
			TweenPlugin.activate([ TintPlugin ]);

			var time : Number = GroupTransitionTask.FADE_TIME_QUICK;

			var g : Graphics = _tempContainer.graphics;
			g.clear();

			if ( _transition == SceneState.TRANSITION_IMAGE )
			{
				time = GroupTransitionTask.FADE_TIME_IMAGE;

				// tells the loading screen to place asset
				loadingScreen.play();
				
				screenFadeBitmapData.bitmapData = new BitmapData( loadingScreen.contentWidth, loadingScreen.contentHeight );
				screenFadeBitmapData.bitmapData.draw( loadingScreen );

				g.beginBitmapFill( screenFadeBitmapData.bitmapData );
				g.drawRect( 0, 0, loadingScreen.width, loadingScreen.height );

				var ct : ColorTransform = new ColorTransform();
				ct.color = 0x000000;
				_tempContainer.transform.colorTransform = ct;
			}
			else
			{
				g.beginFill( 0 );
				g.drawRect( 0, 0, loadingScreen.contentWidth, loadingScreen.contentHeight );
			}

			g.endFill();

			_tempContainer.alpha = 0;

			loadingScreen.displayContent = false;
			loadingScreen.addChild( _tempContainer );

			timelineMax = new TimelineMax({ onComplete: complete, delay: .5 });
			timelineMax.stop();
			timelineMax.append( new TweenMax( _tempContainer, time, { alpha: 1 }));
			timelineMax.append( new TweenMax( _tempContainer, time, { tint: null }));
			timelineMax.play();
		}
	}
}
