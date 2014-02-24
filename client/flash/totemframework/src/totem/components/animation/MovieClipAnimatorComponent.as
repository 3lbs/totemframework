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

package totem.components.animation
{

	import starling.events.Event;
	
	import totem.core.time.TimeManager;
	import totem.display.starling.AnimationMovieClip;

	public class MovieClipAnimatorComponent extends AnimatorComponent
	{

		public static const NAME : String = "MovieClipAnimatorComponent";

		private var _movieClip : AnimationMovieClip;

		private var _paused : Boolean;

		public function MovieClipAnimatorComponent( mc : AnimationMovieClip )
		{
			super( NAME );

			movieClip = mc;
		}

		public function get movieClip() : AnimationMovieClip
		{
			return _movieClip
		}

		public function set movieClip( value : AnimationMovieClip ) : void
		{

			if ( value == _movieClip )
				return;

			if ( _movieClip )
				_movieClip.dispose();

			_movieClip = value;
			_movieClip.addEventListener( Event.COMPLETE, handleAnimationComplete );
		}

		override public function onTick() : void
		{
			super.onTick();

			movieClip.advanceTime( TimeManager.TICK_RATE );
		}

		override public function pauseAnimation() : void
		{
			_paused = true;
		}

		override public function playAnimation( animName : String, type : AnimatorEnum = null ) : void
		{
			var loop : int = -1;

			if ( type != null )
				loop = ( type == AnimatorEnum.LOOP ) ? 1 : 0;

			movieClip.play( animName, loop );
		}

		override public function stopAnimation() : void
		{
			movieClip.stop();
		}

		private function handleAnimationComplete( event : Event ) : void
		{
			trace("did i dispatch");
			broadcaster.dispatchNotifWith( AnimatorEvent.ANIMATION_FINISHED_EVENT );
		}
	}
}
