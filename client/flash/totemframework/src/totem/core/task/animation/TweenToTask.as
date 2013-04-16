package totem.core.task.animation
{

	import com.greensock.TweenMax;
	
	import flash.geom.Point;

	public class TweenToTask extends AnimationTask
	{
		private var endPt : Point;

		public var target : Object;

		public var delay : Number = 0;

		public function TweenToTask( endPt : Point = null, target : Object = null )
		{
			this.endPt = endPt;
			this.target = target;
			
			super();
		}

		override protected function doStart() : void
		{

			TweenMax.to( target, 1, { delay: delay, x: endPt.x, onComplete: complete });
			TweenMax.to( target, .7, { delay: delay, y: endPt.y });

			//complete();
		}

		override public function destroy() : void
		{
			super.destroy();

			target = null;
		}

	}
}
