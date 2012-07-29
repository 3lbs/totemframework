package totem3d.builder.animation
{
	import gorilla.resource.Resource;
	import gorilla.resource.ResourceManager;
	
	import totem.monitors.CompleteProxy;
	import totem.net.URLManager;
	import totem.net.getURL;
	
	import totem3d.core.dto.AnimationParam;
	import totem3d.resource.away3d.AwayMD5AnimationResource;

	public class AnimationLoader extends CompleteProxy
	{
		public var resource : AwayMD5AnimationResource;

		public var animationData : AnimationParam;

		private var resourceManager : ResourceManager;

		public function AnimationLoader( resourceManager : ResourceManager, animationData : AnimationParam )
		{
			this.animationData = animationData;

			this.resourceManager = resourceManager;
		}

		override public function start() : void
		{
			var resource : AwayMD5AnimationResource = resourceManager.load( getURL( animationData.url, URLManager.ASSET_URL ), AwayMD5AnimationResource ) as AwayMD5AnimationResource;
			resource.id = animationData.id;
			resource.completeCallback( handleSequenceComplete );
			resource.failedCallback( handleSequenceFailed );
		}

		private function handleSequenceFailed( resouce : Resource ) : void
		{
			failed();
		}

		protected function handleSequenceComplete( resource : AwayMD5AnimationResource ) : void
		{
			this.resource = resource;
			finished();
		}
		
		override public function destroy():void
		{
			resourceManager = null;
			animationData = null;
			resource = null;
		}
	}
}
