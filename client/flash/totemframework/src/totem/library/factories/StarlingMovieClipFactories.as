package totem.library.factories
{

	import starling.display.MovieClip;
	import starling.textures.Texture;

	import totem.utils.objectpool.IObjectPoolFactory;

	public class StarlingMovieClipFactories implements IObjectPoolFactory
	{

		private var textures : Vector.<Texture>;

		private var fps : Number;

		public function StarlingMovieClipFactories( t : Vector.<Texture>, f : Number = 12 )
		{
			fps = f;
			textures = t;
		}

		public function create() : *
		{
			var mc : MovieClip = new MovieClip( textures, fps );
			return mc;
		}

		public function destroy() : void
		{
			textures.length = 0;
			textures = null;
		}
	}
}
