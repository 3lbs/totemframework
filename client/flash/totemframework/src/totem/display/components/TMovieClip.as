package totem.display.components
{

	import flash.display.MovieClip;
	
	import totem.animation.AnimationEvent;
	import totem.events.RemovableEventDispatcher;

	public class TMovieClip extends RemovableEventDispatcher
	{
		private var _movieClip : MovieClip;

		public function TMovieClip( m : MovieClip )
		{
			_movieClip = m;
			_movieClip.gotoAndStop( 1 );
			
			_movieClip.addFrameScript( _movieClip.totalFrames -1, handleEndMovieClip );
		}
		
		private function handleEndMovieClip () : void
		{
			_movieClip.stop();
			
			dispatchEvent( new AnimationEvent( AnimationEvent.ANIMATION_FINISHED_EVENT, null ) );
		}
		
		public function play() : void
		{
			movieClip.play();
		}

		public function stop() : void
		{
			movieClip.stop();
		}

		public function gotoAndPlay( value : uint ) : void
		{
			movieClip.gotoAndPlay( value );
		}
		
		public function get movieClip() : MovieClip
		{
			return _movieClip;
		}
		
		override public function destroy():void
		{
			super.destroy();
			
			_movieClip = null;
			
		}
	}
}
