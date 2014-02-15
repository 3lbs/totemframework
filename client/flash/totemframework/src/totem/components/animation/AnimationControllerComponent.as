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
	import totem.observer.NotifBroadcaster;

	public class AnimationControllerComponent extends TotemComponent
	{

		public var onAnimationComplete : ISignal = new Signal( AnimationControllerComponent );

		public var onUpdatePosition : ISignal = new Signal( AnimationControllerComponent );

		private var _animationSet : AnimationSet;

		private var animationComponent : IAnimator;

		private var fps : int;

		public function AnimationControllerComponent()
		{
			super();
		}

		public function addAnimator( animator : IAnimator ) : void
		{
			animationComponent = animator;
		}

		public function get broadcaster() : NotifBroadcaster
		{
			return animationComponent.broadcaster;
		}

		public function playAnimation( state : String, type : AnimatorEnum = null ) : void
		{
			var data : AnimationDataParam = _animationSet.getRandomAnimationForState( state );
			animationComponent.playAnimation( data.name, type );
		}
		
		public function stopAnimation () : void
		{
			animationComponent.stopAnimation();
		}

		public function setAnimationData( animations : AnimationSet, fps : int ) : void
		{
			this.fps = fps;
			_animationSet = animations;
		}
	}
}
