package totemgamename.core.startup
{
	import com.pblabs.engine.debug.Logger;
	import totem.config.StageProxy;
	
	import org.robotlegs.core.IInjector;
	
	public class BootstrapConfig
	{
		
		public function BootstrapConfig( injector : IInjector )
		{
			//  we have to use the injector because you cant do injection in the constructor.
			var stageProxy : StageProxy = injector.getInstance( StageProxy );
			
			Logger.print(this, "Initializing " + this + ".");
			Logger.startup( stageProxy.stage );
		}
	}
}

