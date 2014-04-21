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

	import application.task.DelayTask;
	import application.task.FadeFromTask;
	import application.task.FadeToTask;
	import application.task.PlayMovieTask;
	
	import totem.core.task.SequenceTask;

	public class Intro3lbsScreenTask extends SequenceTask
	{
		private const NAME : String = "SCREEN_TASK";

		private var introScreen : AppLoadingScreen;

		public function Intro3lbsScreenTask( screen : AppLoadingScreen, delay : int = 0 )
		{
			super( NAME );

			introScreen = screen;
			introScreen.visible = false;

			addTask( new DelayTask( 100 ));
			addTask( new FadeFromTask( introScreen, 0x000000, .3 ));
			addTask( new PlayMovieTask( introScreen.get3lbsScreen(), delay ) );
			//addTask( new DelayTask( delay ));
			addTask( new FadeToTask( introScreen, 0x000000, .3 ));
			addTask( new DelayTask( 100 ));

		}

		override public function destroy() : void
		{
			super.destroy();

			introScreen = null;
		}
	}
}
