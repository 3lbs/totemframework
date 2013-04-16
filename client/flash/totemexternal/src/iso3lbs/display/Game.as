package iso3lbs.display
{

	import flash.geom.Point;
	
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class Game extends Sprite
	{
		public function Game()
		{
			addEventListener( Event.ADDED_TO_STAGE, onAdded );
		}

		private function onAdded( e : Event ) : void
		{
			var q : Quad = new Quad( 50, 50, 0xFF0000 );
			q.x = stage.stageWidth / 2 - q.width / 2;
			q.y = stage.stageHeight / 2 - q.height / 2;
			q.addEventListener( TouchEvent.TOUCH, touchHandler );
			
			var sprite : Sprite = new Sprite();
			//sprite.addChild( q );
			sprite.addEventListener( TouchEvent.TOUCH, touchHandler );
			addChild( q );
		}

		private function touchHandler( e : TouchEvent ) : void
		{
			var touch : Touch = e.getTouch( stage );
			var position : Point = touch.getLocation( stage );
			var target : Quad = e.target as Quad;

			if ( touch.phase == TouchPhase.MOVED )
			{
				target.x = position.x - target.width / 2;
				target.y = position.y - target.height / 2;
			}
		}
	}
}
