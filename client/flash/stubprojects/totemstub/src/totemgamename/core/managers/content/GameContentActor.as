package totemgamename.core.managers.content
{
	import flash.events.Event;
	import flash.utils.setTimeout;
	
	import org.casalib.events.RemovableEventDispatcher;
	
	import totem.startup.startupmanager.interfaces.IStartupProxy;
	
	public class GameContentActor extends RemovableEventDispatcher implements IStartupProxy
	{
		private var bindTestName : String;
		
		public function GameContentActor()
		{
			//eventDispatcher = new RemovableEventDispatcher ();
			super ();
		}
		
		public function load() : void
		{
			trace ( "test" );
			
			bindTestName = "test name";
			
			var testTimer : int = setTimeout( testCallback, 3000 );
		
		
		}
		
		private function testCallback():void
		{
			//eventDispatcher.dispatchEvent ( new Event ( Event.COMPLETE ) );
		}
	}
}


