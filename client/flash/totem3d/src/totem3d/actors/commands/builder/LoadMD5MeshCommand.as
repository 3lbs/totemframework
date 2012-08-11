package totem3d.actors.commands.builder
{
	import gorilla.resource.Resource;
	import gorilla.resource.ResourceManager;
	
	import totem.core.mvc.controller.command.Command;
	
	import totem3d.actors.components.IMesh3DComponent;
	import totem3d.actors.components.SkeletonAnimatorComponent;
	import totem3d.resource.away3d.AwayMD5MeshResource;

	public class LoadMD5MeshCommand extends Command
	{

		[Inject]
		public var meshCommponent : IMesh3DComponent;

		[Inject]
		public var animationComponent : SkeletonAnimatorComponent;

		private var url : String;

		public function LoadMD5MeshCommand( url : String )
		{
			super();
			this.url = url;
		}

		override public function execute() : void
		{
			var resource : Resource = ResourceManager.getInstance().load( url, AwayMD5MeshResource );
			resource.completeCallback( handleMeshLoaded );
			resource.failedCallback( handleMeshFailed );
		}

		private function handleMeshFailed( resouce : Resource ) : void
		{
			throw new Error( "Failed to load mesh " + url );
		}

		private function handleMeshLoaded( resource : AwayMD5MeshResource ) : void
		{
			animationComponent.animator = resource.animator;
			animationComponent.animator.updateRootPosition = true;
			animationComponent.animationSet = resource.animationSet;
			animationComponent.skeleton = resource.skeleton;
			
			meshCommponent.mesh = resource.mesh;
			
			onComplete.dispatch( this );
		}
		
		override public function destroy():void
		{
			super.destroy();
			
			meshCommponent = null;
			animationComponent = null;
		}
	}
}
