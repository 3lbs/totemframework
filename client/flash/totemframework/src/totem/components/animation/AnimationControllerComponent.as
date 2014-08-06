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

	import org.casalib.util.NumberUtil;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	import totem.core.TotemComponent;
	import totem.core.params.animation.AnimationDataParam;

	public class AnimationControllerComponent extends TotemComponent
	{

		public var onAnimationComplete : ISignal = new Signal();

		public var onLoopComplete : ISignal = new Signal();

		private var _animationSet : AnimationSet;

		private var _playing : Boolean;

		private var animationComponent : AnimatorComponent;

		private var fps : int;

		public function AnimationControllerComponent()
		{
			super();
		}

		public function addAnimator( animator : AnimatorComponent ) : void
		{
			if ( animationComponent )
			{
				//animationComponent.broadcaster.removeNotifListener( AnimatorEvent.ANIMATION_FINISHED_EVENT, handleAnimationComplete );
			}

			animationComponent = animator;
			animationComponent.animationComplete.add( handleAnimationComplete );
			animationComponent.animationLoopComplete.add( handleLoopCopmlete );
		}

		public function playAnimation( name : String, type : AnimatorEnum = null ) : void
		{
			play( name, type );
		}

		public function playAnimationCommandMap( state : String, random : Boolean = false, type : AnimatorEnum = null ) : void
		{

			var data : AnimationDataParam = _animationSet.getRandomAnimationForState( state );

			if ( random )
			{
				_playing = true;
				var frame : int = 0; //NumberUtil.randomIntegerWithinRange( data.start, data.end ) - 1;
				animationComponent.goToAndPlay( data.name, frame, type );
			}
			else
			{
				play( data.name, type );
			}

		}

		public function playAnimationRandomFrame( name : String, type : AnimatorEnum = null ) : void
		{
			var animationData : AnimationDataParam = _animationSet.getAnimationData( name );
			var frame : int = NumberUtil.randomIntegerWithinRange( animationData.start, animationData.end );

			animationComponent.goToAndPlay( name, frame, type );

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

			onAnimationComplete.dispatch();
		}

		private function handleLoopCopmlete() : void
		{
			onLoopComplete.dispatch();
		}

		private function play( ani : String, type : AnimatorEnum = null ) : void
		{
			_playing = true;
			animationComponent.playAnimation( ani, type );
		}
	}
}
