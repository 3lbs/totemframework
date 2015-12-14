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

		private var _sequence : Vector.<Animation>;

		public function AnimatorSequenceMovieClip( mc : MovieClip, fps : int = 12, loop : int = 0 )
		{
			super( mc, fps, loop );
		}

		override public function playAnimation( name : String, loop : int = 0 ) : void
		{
			if ( !_sequence )
			{
				super.playAnimation( name, loop );
			}
		}

		public function playSequence( value : Vector.<Animation> ) : void
		{

			_sequence = value;

			var _currentSequence : Animation = _sequence.shift();
			onPlayAniamtion( _currentSequence.name, _currentSequence.loop );

		}

		/*override protected function onPlayAniamtion( name : String, loop : int = 0 ) : Boolean
		{
			var result : Boolean = super.onPlayAniamtion( name, loop );
			
			if ( !result )
			{
				var _currentSequence : Animation = _sequence.shift();
				onPlayAniamtion( _currentSequence.name, _currentSequence.loop );
			}
			
			return result;
		}*/

		override protected function onUpdateAnimation() : void
		{

			if ( !_sequence )
			{
				super.onUpdateAnimation();
				return;
			}

			if ( currentFrame >= _currentAnimation.end )
			{

				_count += 1;

				if ( _loop == 0 || _count < _loop )
				{
					_movieClip.gotoAndStop( _currentAnimation.start );
				}
				else
				{
					//stop();
					//dispatchEvent( new Event( Event.COMPLETE ));

					if ( _sequence.length == 0 )
					{
						_sequence = null;
						stop();
						dispatchEvent( new Event( SEQUENCE_COMPLETE_EVENT ));
					}
					else if ( _sequence.length > 0 )
					{
						var _currentSequence : Animation = _sequence.shift();
						onPlayAniamtion( _currentSequence.name, _currentSequence.loop );
					}

				}
			}
		}
	}
}
