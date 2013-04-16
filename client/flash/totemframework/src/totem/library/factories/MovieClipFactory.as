
package totem.library.factories
{

	import flash.display.MovieClip;
	
	import gorilla.resource.SWFResource;
	
	import totem.animation.AnimationEvent;
	import totem.utils.objectpool.IObjectPoolFactory;

	public class MovieClipFactory implements IObjectPoolFactory
	{
		private var resource : SWFResource;

		private var classID : String;

		public function MovieClipFactory( swfResource : SWFResource, id : String )
		{

			resource = swfResource;
			classID = id;
		}

		public function create() : *
		{
			//var mc : MovieClip = new MovieClip( textures, fps );

			var clazz : Class = resource.getAssetClass( classID );
			var mc : MovieClip = new clazz();

			mc.addFrameScript( mc.totalFrames - 1, function handleEndMovieClip() : void
			{
				mc.stop();

				mc.dispatchEvent( new AnimationEvent( AnimationEvent.ANIMATION_FINISHED_EVENT, null ));
			})

			return mc;
		}

		public function destroy() : void
		{
			resource = null;
		}
	}
}
