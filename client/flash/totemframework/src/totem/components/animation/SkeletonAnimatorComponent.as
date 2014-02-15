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

	import flash.events.Event;
	
	import dragonBones.Armature;
	import dragonBones.events.AnimationEvent;
	
	import totem.core.time.TimeManager;

	public class SkeletonAnimatorComponent extends AnimatorComponent implements IAnimator
	{

		public static const NAME : String = "SkeletonAnimatorComponent";

		private var _paused : Boolean;

		private var armature : Armature;

		public function SkeletonAnimatorComponent( armature : Armature )
		{
			super( NAME );

			this.armature = armature;
			this.armature.addEventListener( AnimationEvent.COMPLETE, handleAnimationComplete );
		}

		override public function onTick() : void
		{
			super.onTick();
			armature.advanceTime( TimeManager.TICK_RATE );
		}

		override public function pauseAnimation() : void
		{
			_paused = true;
			
			stopAnimation();
		}

		override public function playAnimation( animName : String, type : AnimatorEnum = null ) : void
		{
			var loop : int = ( type ) ? type.type : NaN;
			armature.animation.gotoAndPlay( animName, -1, -1, loop );
		}

		override public function stopAnimation() : void
		{
			armature.animation.stop();
		}
		
		private function handleAnimationComplete( event : Event ) : void
		{
			broadcaster.dispatchNotifWith( AnimatorEvent.ANIMATION_FINISHED_EVENT );
		}
	}
}
