package iso3lbs.graphics
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class CenterPoint extends starling.display.Sprite
	{
		public function CenterPoint( color : int = 0xFF0000 )
		{
			super();
			
			var sprite : flash.display.Sprite = new flash.display.Sprite();
			var g : Graphics = sprite.graphics;
			
			g.beginFill( color );
			g.drawCircle( 20, 20, 20 );
			g.endFill();
			
			var bd : BitmapData = new BitmapData( sprite.width, sprite.height, true );
			bd.draw( sprite );
			
			var image : Image = new Image( Texture.fromBitmapData( bd, false ) );
			
			addChild( image );
		}
	}
}