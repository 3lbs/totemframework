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

	import totem.components.display.starling.DisplayStarlingRenderer;

	public class AnimatorComponent extends DisplayStarlingRenderer implements IAnimator
	{

		public var animationComplete : ISignal = new Signal();

		public var animationLoopComplete : ISignal = new Signal();

		public function AnimatorComponent( name : String )
		{
			super( name );
		}

		override public function destroy() : void
		{
			super.destroy();
			stopAnimation();
		}

		public function goToAndPlay( animName : String, frame : int, type : AnimatorEnum = null ) : void
		{
		}

		public function pauseAnimation() : void
		{

		}

		public function playAnimation( animName : String, type : AnimatorEnum = null ) : void
		{

		}

		public function stopAnimation() : void
		{

		}

		override protected function onRemove() : void
		{
			super.onRemove();
			
			animationComplete.removeAll();
			
			animationLoopComplete.removeAll();
			
			stopAnimation();
		}

		override protected function onRetire() : void
		{
			super.onRetire();
			stopAnimation();
		}
	}
}
