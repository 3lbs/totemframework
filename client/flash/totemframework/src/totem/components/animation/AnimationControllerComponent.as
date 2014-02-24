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

	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	import totem.core.TotemComponent;
	import totem.core.params.animation.AnimationDataParam;

	public class AnimationControllerComponent extends TotemComponent
	{

		public var onAnimationComplete : ISignal = new Signal( AnimationControllerComponent );

		private var _animationSet : AnimationSet;

		private var _playing : Boolean;

		private var animationComponent : IAnimator;

		private var fps : int;

		public function AnimationControllerComponent()
		{
			super();
		}

		public function addAnimator( animator : IAnimator ) : void
		{
			if ( animationComponent )
			{
				animationComponent.broadcaster.removeNotifListener( AnimatorEvent.ANIMATION_FINISHED_EVENT, handleAnimationComplete );
			}

			animationComponent = animator;
			animationComponent.broadcaster.addNotifListener( AnimatorEvent.ANIMATION_FINISHED_EVENT, handleAnimationComplete );
		}

		public function playAnimation( state : String, type : AnimatorEnum = null ) : void
		{

			var data : AnimationDataParam = _animationSet.getRandomAnimationForState( state );
			play( data.name, type );
		}

		public function playAnimationByName( name : String, type : AnimatorEnum = null ) : void
		{
			play( name, type );
		}

		public function get playing() : Boolean
		{
			return _playing;
		}

		public function setAnimationData( animations : AnimationSet, fps : int ) : void
		{
			this.fps = fps;
			_animationSet = animations;
		}

		public function stopAnimation() : void
		{
			_playing = false;
			animationComponent.stopAnimation();
		}

		private function handleAnimationComplete() : void
		{
			_playing = false;
			
			onAnimationComplete.dispatch( this );
		}

		private function play( ani : String, type : AnimatorEnum = null ) : void
		{

			_playing = true;
			animationComponent.playAnimation( ani, type );
		}
	}
}
