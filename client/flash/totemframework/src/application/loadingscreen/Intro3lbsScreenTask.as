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

	import totem.core.task.util.DelayTask;
	import application.task.PlayMovieTask;

	import totem.core.task.SequenceTask;
	import totem.display.video.SimpleStageVideo;

	public class Intro3lbsScreenTask extends SequenceTask
	{
		private const NAME : String = "SCREEN_TASK";

		public function Intro3lbsScreenTask( url : String, stageVideoProxy : SimpleStageVideo, delay : int = 0 )
		{
			super( NAME );

			addTask( new DelayTask( 100 ));
			//addTask( new FadeFromTask( introScreen, 0x000000, .3 ));
			addTask( new PlayMovieTask( url, stageVideoProxy, delay ));
			//addTask( new DelayTask( delay ));
			//addTask( new FadeToTask( introScreen, 0x000000, .3 ));
			addTask( new DelayTask( 100 ));

		}

		override public function destroy() : void
		{
			super.destroy();

		}
	}
}
