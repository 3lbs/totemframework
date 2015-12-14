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

	import flash.events.Event;

	import totem.animation.Animation;
	import totem.animation.AnimatorSequenceMovieClip;
	import totem.core.task.Task;

	public class AnimationSequenceTask extends Task
	{
		private var _animator : AnimatorSequenceMovieClip;

		private var _sequence : Vector.<Animation>;

		public function AnimationSequenceTask( animator : AnimatorSequenceMovieClip, sequence : Vector.<Animation> )
		{
			super();

			_animator = animator;
			_sequence = sequence;
		}

		override public function destroy() : void
		{
			_animator = null;
			_sequence = null;

			super.destroy();
		}

		override protected function doStart() : void
		{
			_animator.addEventListener( AnimatorSequenceMovieClip.SEQUENCE_COMPLETE_EVENT, handleSequenceComplete, false, 0, true );
			_animator.playSequence( _sequence );

		}

		protected function handleSequenceComplete( event : Event ) : void
		{
			_animator.removeEventListener( AnimatorSequenceMovieClip.SEQUENCE_COMPLETE_EVENT, handleSequenceComplete );
			_animator.stop();
			
			complete();

		}
	}
}
