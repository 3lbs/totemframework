package totem.utils.objectpool.helpers
{

	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	
	import totem.core.IDestroyable;
	import totem.utils.objectpool.IObjectPoolHelper;

	public class DisplayObjectObjectPoolHelper implements IObjectPoolHelper
	{
		public function DisplayObjectObjectPoolHelper()
		{
		}

		public function retire( item : * ) : void
		{
			// built in helper or defualt helper
			// Reset display objects
			if ( item is MovieClip )
			{
				var m : MovieClip = item as MovieClip;
				m.gotoAndStop( 1 );
			}

			if ( item is Sprite )
			{
				var s : Sprite = item as Sprite;
				s.graphics.clear();
			}

			if ( item is Shape )
			{
				var sh : Shape = item as Shape;
				sh.graphics.clear();
			}

			if ( item is DisplayObject )
			{

				var d : DisplayObject = item as DisplayObject;
				d.x = 0;
				d.y = 0;
				d.alpha = 1;
				d.blendMode = BlendMode.NORMAL;
				d.cacheAsBitmap = false;
				d.filters = [];
				d.mask = null;
				d.rotation = 0;
				d.scaleX = 1;
				d.scaleY = 1;
				d.scrollRect = null;
				d.visible = true;
				d.transform.matrix = new Matrix();
				d.transform.colorTransform = new ColorTransform();
			}
		}
		
		public function destroy ( item : * ) : void
		{
			if ( item is IDestroyable )
				IDestroyable( item );
			
			if ( item is DisplayObjectContainer )
				DisplayObjectContainer( item ).removeChildren();
		}
	}
}
