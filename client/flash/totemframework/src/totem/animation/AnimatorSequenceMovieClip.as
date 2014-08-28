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

package totem.animation
{

	import flash.display.MovieClip;
	import flash.events.Event;

	public class AnimatorSequenceMovieClip extends AnimatorMovieClip
	{

		public static const SEQUENCE_COMPLETE_EVENT : String = "SequenceCompleteEvent";

		private var _sequence : Array;

		public function AnimatorSequenceMovieClip( mc : MovieClip, fps : int = 12, loop : Boolean = false )
		{
			super( mc, fps, loop );
		}

		override public function playAnimation( name : String, loop : Boolean = false ) : void
		{
			if ( !_sequence )
			{
				super.playAnimation( name, loop );
			}
		}

		public function playSequence( value : Array ) : void
		{
			_sequence = value;

			var _currentSequence : String = _sequence.shift();

			onPlayAniamtion( _currentSequence, false );
		}

		override protected function onUpdateAnimation() : void
		{

			if ( !_sequence )
			{
				super.onUpdateAnimation();
				return;
			}

			if ( currentFrame >= _currentAnimation.end )
			{
				if ( _sequence.length = 0 )
				{
					_sequence = null;
					stop();
					dispatchEvent( new Event( SEQUENCE_COMPLETE_EVENT ));
				}
				else if ( _sequence.length > 0 )
				{
					onPlayAniamtion( _sequence.shift(), false );
				}
			}
		}
	}
}
