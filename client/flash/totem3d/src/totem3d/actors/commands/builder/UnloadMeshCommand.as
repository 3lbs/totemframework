package totem3d.actors.commands.builder
{
	import away3d.entities.Mesh;
	
	import flare.core.Mesh3D;
	
	import totem.core.mvc.controller.command.Command;
	
	import totem3d.components.Mesh3DComponent;
	import totem3d.components.Animator3DComponent;
	
	public class UnloadMeshCommand extends Command
	{
		
		[Inject]
		public var meshCommponent : Mesh3DComponent;
		
		[Inject]
		public var animationComponent : Animator3DComponent;
		
		
		public function UnloadMeshCommand()
		{
			super();
		}
		
		public override function execute():void
		{
			super.execute();
			
			var mesh : Mesh3D = meshCommponent.removeMeshFromComponent();
			
			meshCommponent.mesh = null; //Mesh3DComponent( meshCommponent ).debugBox;
			
		}
	}
}