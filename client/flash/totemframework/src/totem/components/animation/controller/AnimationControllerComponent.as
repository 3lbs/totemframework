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

	import flash.utils.Dictionary;

	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import totem.components.animation.AnimatorComponent;
	import totem.core.TotemComponent;
	import totem.core.params.animation.AnimationInfo;
	import totem.utils.Rndm;

	public class AnimationControllerComponent extends TotemComponent
	{

		public static const NAME : String = "AnimationControllerComponent";

		public var onAnimationComplete : ISignal = new Signal();

		public var onLoopComplete : ISignal = new Signal();

		protected var _animationAction : Dictionary = new Dictionary();

		protected var _animations : Dictionary = new Dictionary();

		private var _playing : Boolean;

		private var animationComponent : AnimatorComponent;

		public function AnimationControllerComponent( name : String = null )
		{
			super( name || NAME );
		}

		public function addAnimationData( data : AnimationInfo ) : void
		{
			_animations[ data.name ] = data;
		}

		public function addAnimator( animator : AnimatorComponent ) : void
		{
			animationComponent = animator;
			animationComponent.animationComplete.add( handleAnimationComplete );
			animationComponent.animationLoopComplete.add( handleLoopCopmlete );
		}

		public function addHashObject( hash : AnimationHash ) : void
		{
			_animationAction[ hash.name ] = hash;
		}

		public function playAnimation( name : String, loop : int = 1 ) : void
		{
			play( name, loop );
		}

		public function playAnimationHash( aniName : String, loop : int = 1 ) : void
		{
			if ( _animationAction[ aniName ])
			{
				var animationActionList : Vector.<AnimationAction> = _animationAction[ aniName ].list;
				var animationAction : AnimationAction = animationActionList[ Rndm.integer( 0, animationActionList.length )];

				play( animationAction.name, loop );
			}
			else
			{
				play( aniName, loop );
			}

		}

		public function get playing() : Boolean
		{
			return _playing;
		}

		public function stopAnimation() : void
		{
			_playing = false;
			animationComponent.stopAnimation();
		}

		protected function handleAnimationComplete() : void
		{
			_playing = false;
			onAnimationComplete.dispatch();
		}

		protected function handleLoopCopmlete() : void
		{
			onLoopComplete.dispatch();
		}

		override protected function onActivate() : void
		{
			super.onActivate();
		}

		override protected function onRetire() : void
		{
			stopAnimation();

			super.onRetire();
		}

		protected function play( ani : String, loop : int = 1 ) : void
		{
			_playing = true;

			if ( animationComponent.hasAnimation( ani ) == false )
			{
				handleAnimationComplete();
			}
			else
			{
				animationComponent.playAnimation( ani, loop );
			}
		}
	}
}
