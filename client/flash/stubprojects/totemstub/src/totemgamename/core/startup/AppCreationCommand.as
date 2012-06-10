//------------------------------------------------------------------------------
//
//   Copyright 2012 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package totemgamename.core.startup
{
	import org.robotlegs.base.ContextEvent;
	import org.robotlegs.utilities.macrobot.SequenceCommand;
	/**
	 *
	 * @author eddie
	 */
	public class AppCreationCommand extends SequenceCommand
	{
		/**
		 *
		 */
		public function AppCreationCommand()
		{
			// sequnce command these command wait till one is finished before it start the next command
			addCommand ( AppInitCommand, new ContextEvent ( ContextEvent.STARTUP_COMPLETE ) );
			addCommand ( AppStartupCommand, new ContextEvent ( ContextEvent.STARTUP_COMPLETE ) );
			addCommand ( CreationCompleteCommand, new ContextEvent ( ContextEvent.STARTUP_COMPLETE ) );
		}
		
		override protected function commandCompleteHandler( success : Boolean ) : void
		{
			super.commandCompleteHandler( success );
			//  the game is finished start up	
			trace(" hi me ");
		}
	}
}

