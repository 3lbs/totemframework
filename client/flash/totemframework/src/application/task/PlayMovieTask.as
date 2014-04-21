//------------------------------------------------------------------------------
//
//     _______ __ __           
//    |   _   |  |  |--.-----. 
//    |___|   |  |  _  |__ --| 
//     _(__   |__|_____|_____| 
//    |:  1   |                
//    |::.. . |                
//    `-------'      
//                       
//   3lbs Copyright 2014 
//   For more information see http://www.3lbs.com 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package application.task
{

	import flash.events.Event;

	import totem.core.task.Task;
	import totem.display.MovieClipFPSThrottle;
	import totem.monitors.promise.wait;

	public class PlayMovieTask extends Task
	{
		private var _delay : int;

		private var _movieClip : MovieClipFPSThrottle;

		public function PlayMovieTask( m : MovieClipFPSThrottle, delay : int )
		{
			super();

			_movieClip = m;

			_delay = delay;
		}

		override public function destroy() : void
		{
			_movieClip.stop();
			_movieClip.removeEventListener( Event.COMPLETE, handleEnterFrame );
			_movieClip = null;

			super.destroy();
		}

		override protected function doStart() : void
		{
			_movieClip.addEventListener( Event.COMPLETE, handleEnterFrame, false, 0, true );
			_movieClip.play();

			if ( _delay > 0 )
				wait( _delay, complete );
		}

		protected function handleEnterFrame( event : Event ) : void
		{
			_movieClip.removeEventListener( Event.COMPLETE, handleEnterFrame );
			complete();
		}
	}
}
