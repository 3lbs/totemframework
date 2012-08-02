package totem3d.actors.commands.builder
{
	import flash.events.Event;
	
	import gorilla.resource.ResourceManager;
	
	import totem.core.command.Command;
	
	import totem3d.actors.components.ITextureMaterialComponent;
	import totem3d.builder.MaterialFactory;
	import totem3d.core.dto.MaterialParam;

	public class BuildTextureMaterialCommand extends Command
	{
		private var materialParam : MaterialParam;

		private var materialFactory : MaterialFactory;

		[Inject]
		public var resourceManager : ResourceManager;
		
		[Inject]
		public var textureMaterialComponent : ITextureMaterialComponent;
		
		public function BuildTextureMaterialCommand( param : MaterialParam )
		{
			materialParam = param;
		}

		override public function execute() : void
		{
			materialFactory = new MaterialFactory( materialParam );
			materialFactory.addEventListener( Event.COMPLETE, handleMaterialBuildComplete );

			materialFactory.start();
		}

		protected function handleMaterialBuildComplete( event : Event ) : void
		{
			materialFactory.removeEventListener( Event.COMPLETE, handleMaterialBuildComplete );

			textureMaterialComponent.textureMaterial = materialFactory.getResult();

			materialFactory.destroy();
			materialFactory = null;
			
			materialParam = null;
			
			onComplete.dispatch( this );
		}
	}
}
