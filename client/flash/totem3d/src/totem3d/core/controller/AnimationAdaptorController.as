package totem3d.core.controller
{
	import away3d.animators.SmoothSkeletonAnimator;
	import away3d.animators.data.SkeletonAnimationSequence;
	
	import flash.events.IEventDispatcher;
	
	import org.casalib.events.RemovableEventDispatcher;
	
	public class AnimationAdaptorController extends RemovableEventDispatcher
	{
		
		private var _controller : SmoothSkeletonAnimator;
		
		private var _sequences : Vector.<SkeletonAnimationSequence>;
		
		public function AnimationAdaptorController(target:IEventDispatcher=null)
		{
			super(target);
		}
	}
}

