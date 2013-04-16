package totem.core.task.animation
{

	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.events.Event;

	public class StarlingMovieClipTask extends AnimationTask
	{

		private var movieClip : MovieClip;

		public function StarlingMovieClipTask( mc : MovieClip, time : int )
		{
			super();

			movieClip = mc;
		}

		override protected function doStart() : void
		{

			movieClip.play();
			movieClip.addEventListener( Event.COMPLETE, handleClipPlayComplete );
		}

		private function handleClipPlayComplete( event : Event ) : void
		{
			// delay?
			
			
			Starling.juggler.remove( movieClip );
			
			complete();
		}
		
		override public function destroy():void
		{
			super.destroy();
			
			movieClip = null;
		}
	}
}
