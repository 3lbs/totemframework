package totemgamename.core.startup
{
	import com.pblabs.engine.debug.Logger;
	import totemgamename.core.managers.content.GameContentActor;
	import totem.startup.startupmanager.StartupMonitorWrapper;
	import totem.startup.startupmanager.events.StartupEvent;
	import totem.startup.startupmanager.model.StartupResourceProxy;
	
	import flash.events.Event;
	
	import org.robotlegs.utilities.macrobot.AsyncCommand;
	
	public class AppStartupCommand extends AsyncCommand
	{
		
		override public function execute() : void
		{
			super.execute();
			
			// PBE engine.  good stuff for game
			// PBE.startup ( contextView as Sprite );
			
			Logger.print ( this, "GameStartUpCommand" );
			
			// startup monitior proxy.   this loads all assets and data for the game to start
			
			// we put the monitor in a wrapper so we can use outside of the Robotlegs archticure
			var monitorWrapper : StartupMonitorWrapper = new StartupMonitorWrapper();
			
			// initialzation proxies all assets and content that needs to be loaded to start the game
			var gameContent : GameContentActor = new GameContentActor ();
			//injector.mapValue ( GameContentActor, gameContent );
			
			var startupGameContent : StartupResourceProxy = monitorWrapper.makeAndRegisterStartupResource ( "", gameContent );
			
			
			// lets start the loader
			// might want to map event instead of holding this
			
			monitorWrapper.addEventListener( StartupEvent.LOADING_COMPLETE, onComplete ); 
			monitorWrapper.loadResources ();			
		
		}
		
		private function onComplete ( eve : Event ) : void
		{
			dispatchComplete( true );
		}
	}
}


