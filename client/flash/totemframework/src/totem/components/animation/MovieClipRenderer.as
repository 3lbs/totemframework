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

	public class MovieClipRenderer extends AnimatorComponent
	{

		public static const NAME : String = "MovieClipAnimatorComponent";

		private var _movieClip : AnimationMovieClip;

		private var _paused : Boolean;

		public function MovieClipRenderer( mc : AnimationMovieClip )
		{
			super( NAME );

			movieClip = mc;

			displayObject = mc;
		}

		override public function goToAndPlay( animName : String, frame : int, loop : int = 1 ) : void
		{
			movieClip.play( animName, loop );

			movieClip.currentFrame = frame;
		}

		override public function hasAnimation( name : String ) : Boolean
		{
			return ( _movieClip.hasAnimation( name ));
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

		override public function playAnimation( animName : String, loop : int = 1 ) : void
		{
			movieClip.play( animName, loop );
		}

		override public function stopAnimation() : void
		{
			movieClip.stop();
		}

		private function handleAnimationComplete( event : Event ) : void
		{
			animationComplete.dispatch();
		}
	}
}
