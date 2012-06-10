package totemgamename.core.startup
{
	import org.robotlegs.utilities.macrobot.AsyncCommand;
	
	public class CreationCompleteCommand extends AsyncCommand
	{
		override public function execute():void
		{
			trace("int game");
			
			//  maybe start first state here!!!!
			dispatchComplete( true );
		}
	}
}

