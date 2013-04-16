package totem.core.task.util
{

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import totem.core.task.SequenceTask;
	import totem.core.task.Task;

	public class SpriteToDisplayTask extends SequenceTask
	{

		public var loaderTask : DisplayLoaderTask;

		private var stageSprite : Sprite;

		private var spritePos : Point;

		public function SpriteToDisplayTask( sprite : Sprite, pos : Point )
		{
			stageSprite = sprite;

			spritePos = pos;
		}

		override protected function handleTaskComplete( t : Task ) : void
		{
			if ( t is DisplayLoaderTask )
			{
				
				var sprite : DisplayObject = DisplayLoaderTask( t ).sprite;
				sprite.x = - ( sprite.width * .5 );
				sprite.y = - ( sprite.height * .5 );
				
				stageSprite.addChild( sprite );
			}

			super.handleTaskComplete( t );
		}
		
		override public function destroy():void
		{
			super.destroy();
			
			loaderTask = null;
			
			stageSprite = null;
			
			spritePos = null;
		}
	}
}
