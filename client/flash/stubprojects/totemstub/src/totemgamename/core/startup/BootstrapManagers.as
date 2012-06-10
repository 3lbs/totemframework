package totemgamename.core.startup
{
	import com.pblabs.engine.core.NameManager;
	import com.pblabs.engine.time.IProcessManager;
	import com.pblabs.engine.time.ProcessManager;
	
	import flash.events.EventDispatcher;
	
	import org.robotlegs.core.IInjector;
	
	import totem.config.StageProxy;
	
	public class BootstrapManagers
	{
		
		public function BootstrapManagers( injector : IInjector )
		{
			// Register ourselves.
			//registerManager(PBGame, this);
			
			var stageProxy : StageProxy = injector.getInstance( StageProxy );
			
			
			// Bring in the standard managers.
			var pm : ProcessManager = new ProcessManager ( stageProxy.stage );
			injector.mapValue ( IProcessManager, pm );
			injector.mapValue ( ProcessManager, pm );
			
			// might want to do an interface
			//injector.mapValue ( InputManager, new InputManager () );
			injector.mapValue ( NameManager, new NameManager () );
			/*injector.mapValue ( ResourceManager, new ResourceManager () );
			
			
			var sm : SoundManager = new SoundManager ();
			injector.mapValue ( ISoundManager, sm );
			pm.addTickedObject ( sm, 100 );*/
			
			// want to copy this!   might get rid of this whole class!
			//registerManager(ScreenManager, new ScreenManager());
			
			injector.mapValue ( EventDispatcher, new EventDispatcher () );
		}
	}
}

