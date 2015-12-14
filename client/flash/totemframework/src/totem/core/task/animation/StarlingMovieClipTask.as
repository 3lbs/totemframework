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

package totem.core.task.animation
{

	import starling.display.MovieClip;
	import starling.events.Event;

	public class StarlingMovieClipTask extends AnimationTask
	{

		private var movieClip : MovieClip;

		public function StarlingMovieClipTask( mc : MovieClip, loop : int = 0 )
		{
			super();

			setRestartable( false );
			movieClip = mc;
		}

		override public function destroy() : void
		{
			super.destroy();

			movieClip = null;
		}

		override protected function doStart() : void
		{

			movieClip.play();
			movieClip.addEventListener( Event.COMPLETE, handleClipPlayComplete );
		}

		private function handleClipPlayComplete( event : Event ) : void
		{

			complete();
		}
	}
}
