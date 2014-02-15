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
	
	import application.task.DelayTask;
	import application.task.FadeFromTask;
	import application.task.FadeToTask;
	import application.task.FunctionTask;
	
	import totem.core.task.SequenceTask;
	import totem.utils.MovieClipUtil;

	public class Intro3lbsScreenTask extends SequenceTask
	{
		private const NAME : String = "SCREEN_TASK";

		private var introScreen : AppLoadingScreen;

		public function Intro3lbsScreenTask( screen : AppLoadingScreen, delay : int = 3000 )
		{
			super( NAME );

			introScreen = screen;
			introScreen.visible = false;

			addTask( new DelayTask( 100 ));
			addTask( new FadeFromTask( introScreen, 0x000000, .3 ));
			addTask( new FunctionTask( stopAllMovie ));
			addTask( new DelayTask( delay ));
			addTask( new FadeToTask( introScreen, 0x000000, .3 ));
			addTask( new DelayTask( 100 ));

		}

		override public function destroy() : void
		{
			super.destroy();

			introScreen = null;
		}

		private function stopAllMovie() : void
		{
			var _loader : Loader = introScreen.get3lbsScreen();
			MovieClipUtil.stopAllAnimation( _loader.content as MovieClip );
		}
	}
}
