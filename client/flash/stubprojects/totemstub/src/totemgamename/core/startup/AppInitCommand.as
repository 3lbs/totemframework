package totemgamename.core.startup
{
	import org.robotlegs.utilities.macrobot.AsyncCommand;
	
	public class AppInitCommand extends AsyncCommand
	{
		public function AppInitCommand()
		{
			super();
		}
		
		override public function execute():void
		{
			super.execute();
			// set up stage
			/*var stageProxy : StageProxy = new StageProxy( contextView );
			injector.mapValue( StageProxy, stageProxy );
			
			// flash var config
			//var flashVarProxy : FlashVarsConfig = new FlashVarsConfig( stageProxy.stage );
			
			new BootstrapConfig( injector );
			new BootstrapManagers( injector );
			
			// load modules
			
			var gameViewModule : PBModule = new PBModule();
			contextView.addChild( gameViewModule );
			
			var view3dModule : Module3D = new Module3D();
			contextView.addChild( view3dModule );
			*/
			dispatchComplete( true );
			//dispatch( new StartupEvent( StartupEvent.INITIALIZE_COMPLETE ) );
		}
	}
}

