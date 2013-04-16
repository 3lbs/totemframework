package totem.core.task.util
{

	import flash.events.Event;
	
	import starling.textures.TextureAtlas;
	
	import totem.loaders.starling.AtlasDataLoader;

	public class AtlasSpriteLoaderTask extends DisplayLoaderTask
	{
		private var atlasURL : String;

		private var spriteName : String;

		private var atlasLoader : AtlasDataLoader;

		public function AtlasSpriteLoaderTask( url : String, name : String )
		{
			atlasURL = url;
			spriteName = name;
			super();
		}

		override protected function doStart() : void
		{
			super.doStart();

			atlasLoader = new AtlasDataLoader( atlasURL, spriteName, false );
			atlasLoader.addEventListener( Event.COMPLETE, handleAtlasComplete );
			atlasLoader.start();
		}

		protected function handleAtlasComplete( event : Event ) : void
		{
			atlasLoader.removeEventListener( Event.COMPLETE, handleAtlasComplete );

			var atlas : TextureAtlas = atlasLoader.textureAtlas;

			//sprite = new Image( atlas.getTexture( spriteName ));

			complete();
		}

		override public function destroy() : void
		{
			super.destroy();

			atlasLoader = null;
			sprite = null;
		}
	}
}
