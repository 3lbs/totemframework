package totem.library.factories
{

	import starling.display.BlendMode;
	import starling.display.DisplayObject;
	import starling.display.MovieClip;

	import totem.utils.objectpool.IObjectPoolHelper;

	public class StarlingMovieClipHelper implements IObjectPoolHelper
	{
		public function StarlingMovieClipHelper()
		{
		}

		public function retire( item : * ) : void
		{

			if ( item is MovieClip )
			{
				var m : MovieClip = item as MovieClip;
				
				m.stop();
				m.currentFrame = 0;
				
			}

			if ( item is DisplayObject )
			{
			
				var d : DisplayObject = item as DisplayObject;
				d.removeEventListeners();
				d.x = 0;
				d.y = 0;
				d.alpha = 1;
				d.blendMode = BlendMode.NORMAL;
				d.rotation = 0;
				d.scaleX = 1;
				d.scaleY = 1;
				d.visible = true;
				
			}

		}

		public function destroy( item : * ) : void
		{
			if ( item.hasOwnProperty( "dispose" ))
				item.dispose();
		}
	}
}
