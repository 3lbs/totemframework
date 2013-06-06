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
	import com.greensock.plugins.TintPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	
	import dinozoo.view.screens.loadingscreen.BaseLoadingScreen;
	
	import totem.core.task.Task;

	public class FadeScreenInTask extends Task
	{

		protected var _tempContainer : Sprite;

		private var _transition : String;

		private var loadingScreen : BaseLoadingScreen;

		private var screenFadeBitmapData : BitmapData;

		private var skipAlpha : Boolean;

		private var timelineMax : TimelineMax;

		public function FadeScreenInTask( sc : BaseLoadingScreen, screenBitmapData : BitmapData, transition : String )
		{
			super();

			_transition = transition;
			
			loadingScreen = sc;

			screenFadeBitmapData = screenBitmapData;

			_tempContainer = new Sprite();
			_tempContainer.mouseEnabled = false;
		}

		override protected function complete() : Boolean
		{
			timelineMax.clear();
			timelineMax = null;

			loadingScreen.visible = true;

			_tempContainer.graphics.clear();

			if ( _tempContainer.parent )
				_tempContainer.parent.removeChild( _tempContainer );

			//_tempContainer.visible = false;

			loadingScreen.play();

			return super.complete();
		}

		override protected function doStart() : void
		{
			TweenPlugin.activate([ TintPlugin ]);
			timelineMax = new TimelineMax({ onComplete: complete, delay : .5 });

			timelineMax.stop();

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

				var ct : ColorTransform = new ColorTransform();
				ct.color = 0x000000;
				_tempContainer.transform.colorTransform = ct;
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

			loadingScreen.visible = false;

			_tempContainer.alpha = 0;
			timelineMax.append( new TweenMax( _tempContainer, time, { alpha: 1 }));
			timelineMax.append( new TweenMax( _tempContainer, time, { tint: null }));
			timelineMax.play();
		}
	}
}
