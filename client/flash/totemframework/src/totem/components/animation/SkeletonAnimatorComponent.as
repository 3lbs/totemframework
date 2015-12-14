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
	import dragonBones.Bone;
	import dragonBones.Slot;
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
			this.armature.addEventListener( AnimationEvent.LOOP_COMPLETE, handleAimationLoopComplete );
		}

		public function getArmature() : Armature
		{
			return armature;
		}

		public function getBone( name : String ) : Bone
		{
			return armature.getBone( name );
		}
		
		public function invalidateArmature () : void
		{
			armature.invalidUpdate();
		}
		
		public function getSlot ( name : String ) : Slot
		{
			return armature.getSlot( name );
		}
		
		public function removeSlotByName ( name : String ) : Slot
		{
			return armature.removeSlotByName( name );
		}

		override public function hasAnimation( name : String ) : Boolean
		{
			return ( armature.animation.hasAnimation( name ))
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

		override public function playAnimation( animName : String, loop : int = 1 ) : void
		{
			armature.animation.gotoAndPlay( animName, -1, -1, loop );
		}

		override public function stopAnimation() : void
		{
			armature.animation.stop();
		}

		protected function handleAimationLoopComplete( event : AnimationEvent ) : void
		{
			animationLoopComplete.dispatch();
		}

		protected function handleAnimationComplete( event : Event ) : void
		{
			animationComplete.dispatch();
		}

		override protected function onActivate() : void
		{
			super.onActivate();
		}

		override protected function onAdd() : void
		{
			super.onAdd();

		}

		override protected function onRetire() : void
		{
			super.onRetire();

			stopAnimation();
		}
	}
}
