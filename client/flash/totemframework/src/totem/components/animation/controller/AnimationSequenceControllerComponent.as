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

package totem.components.animation.controller
{

	import totem.utils.Rndm;

	public class AnimationSequenceControllerComponent extends AnimationControllerComponent
	{

		public static const NAME : String = "AnimationSequenceController";

		private var _count : int;

		private var _random : Boolean;

		private var _sequence : Vector.<AnimationAction>;

		private var loop : int;

		public function AnimationSequenceControllerComponent( name : String = null )
		{
			super( name || NAME );
		}

		public function getAnimationSequenceByBias( key : String, length : int = 0, result : Vector.<AnimationAction> = null ) : Vector.<AnimationAction>
		{
			result ||= new Vector.<AnimationAction>();

			if ( _animationAction[ key ])
			{
				var actionList : Vector.<AnimationAction> = _animationAction[ key ].list;
				var len : int = length || actionList.length;
				var i : int;

				for ( ; i < len; ++i )
				{
					result.push( actionList[ Rndm.instance( actionList.length )]);
				}
			}

			return result;
		}

		public function getRandomLinearSequence( key : String ) : Vector.<AnimationAction>
		{
			var result : Vector.<AnimationAction>;

			if ( _animationAction[ key ])
			{
				result = _animationAction[ key ].list.concat().sort( Rndm.sortRandom );
			}

			return result;
		}

		public function playAnimationSequence( sequence : Vector.<AnimationAction>, loop : int = 1, random : Boolean = false ) : void
		{

			if ( playing )
			{
				stopAnimation();
			}

			_count = 0;
			_random = random;
			_sequence = sequence;

			this.loop = loop;

			if ( _activated )
				playSequence();
		}

		public function get sequence() : Vector.<AnimationAction>
		{
			return _sequence;
		}

		override public function stopAnimation() : void
		{
			if ( _sequence )
				_sequence.length = 0;

			_sequence = null;
			super.stopAnimation();
		}

		override protected function handleAnimationComplete() : void
		{
			continueAnimation();
		}

		override protected function handleLoopCopmlete() : void
		{
			//continueAnimation();
		}

		override protected function onActivate() : void
		{

			super.onActivate();

			if ( _sequence )
			{
				playSequence();
			}
		}

		private function continueAnimation() : void
		{
			_count++;

			//  just play the sequence normally
			if ( loop > 0 && _count >= _sequence.length && !_random )
			{
				stopAnimation();
			}
			// play a random animation to loop count
			else if ( loop > 0 && _count >= loop && _random )
			{
				stopAnimation();
			}
			else
			{
				if ( _count >= _sequence.length )
				{
					_count = 0;
				}

				playSequence();
			}

		}

		private function playSequence() : void
		{
			var _action : AnimationAction;

			if ( _random )
			{
				_action = _sequence[ Rndm.integer( 0, _sequence.length )];
				play( _action.name, Rndm.integer( 1, _action.max ));
			}
			else
			{
				_action = _sequence[ _count ];
				play( _action.name, Rndm.integer( 1, _action.max ));
			}
		}
	}
}
