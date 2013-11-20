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

	import flash.display.DisplayObjectContainer;
	
	import application.task.DelayTask;
	import application.task.FadeFromTask;
	import application.task.FadeToTask;
	
	import totem.core.task.SequenceTask;

	public class Intro3lbsScreenTask extends SequenceTask
	{
		private const NAME : String = "SCREEN_TASK";

		private var introScreen : DisplayObjectContainer;

		public function Intro3lbsScreenTask( screen : DisplayObjectContainer )
		{
			super( NAME );

			introScreen = screen;
			introScreen.visible = false;
			
			addTask( new DelayTask( 100 ));
			addTask( new FadeFromTask( introScreen, 0x000000, .3 ));
			addTask( new DelayTask( 3000 ));
			//addTask( new WaitTask() );
			addTask( new FadeToTask( introScreen, 0x000000, .3 ));
			addTask( new DelayTask( 100 ));

		}
		
		override public function destroy():void
		{
			super.destroy();
			
			introScreen = null;
		}
	}
}
