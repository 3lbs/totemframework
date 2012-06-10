package totem3d.controllers
{
	import away3d.animators.SmoothSkeletonAnimator;
	import away3d.animators.data.SkeletonAnimationSequence;
	import away3d.events.AnimatorEvent;
	
	import org.casalib.events.RemovableEventDispatcher;
	
	import totem.resource.ResourceEvent;
	
	import totem3d.away3d.AwayMD5AnimationResource;
	import totem3d.core.datatypeobject.AnimationParam;
	import totem3d.events.Animation3DEvent;
	
	public class Sequence3dAnimator extends RemovableEventDispatcher
	{
		private var controller : SmoothSkeletonAnimator;
		
		private var animationDataType : AnimationParam;
		
		private var resource : AwayMD5AnimationResource;
		
		public var sequence : SkeletonAnimationSequence;
		
		private var _updateRootAnimation : Boolean = false; 
		
		public function Sequence3dAnimator( data : AnimationParam, controller : SmoothSkeletonAnimator, resource : AwayMD5AnimationResource = null )
		{
			this.controller = controller;
			
			animationDataType = data;
			
			this.resource = resource;
			
			if ( resource )
			{
				if ( resource.isLoaded )
				{
					installSequence ( resource );
				}
				else
				{
					resource.addEventListener ( ResourceEvent.LOADED_EVENT, handleSequenceLoaded );
				}
			}
		}
		
		protected function handleSequenceLoaded( event : ResourceEvent ) : void
		{
			resource.removeEventListener ( ResourceEvent.LOADED_EVENT, handleSequenceLoaded );
			
			installSequence ( resource );
		}
		
		private function installSequence( resource : AwayMD5AnimationResource ) : void
		{
			
			/*var seq:SkeletonAnimationSequence = event.asset as SkeletonAnimationSequence;
			seq.name = event.asset.assetNamespace;
			animator.addSequence(seq);
			
			if (seq.name == IDLE_NAME || seq.name == WALK_NAME) {
				seq.looping = true;
			} else {
				seq.looping = false;
				seq.addEventListener(AnimatorEvent.SEQUENCE_DONE, onSequenceDone);
			}*/
			
			
			sequence = resource.sequence;
			sequence.name = animationDataType.id;
			
			controller.addSequence ( sequence );
			
			sequence.looping = animationDataType.loop;
			
			if ( !sequence.looping )
			{
			}
			
			sequence.addEventListener ( AnimatorEvent.SEQUENCE_DONE, onClipComplete );
			
			sequence.duration;
			
			//
			resource.destroy();
			resource = null;
		}
		
		public function playSequence() : void
		{
			controller.play ( sequence.name, .5 );
			
			// add animation attributes
			controller.updateRootPosition = animationDataType.updateRoot;
			
			dispatchEvent ( new Animation3DEvent ( Animation3DEvent.ANIMATION_START ) );
		}
		
		public function stopSequence() : void
		{
			controller.stop ();
		}
		
		public function get duration() : int
		{
			return sequence.duration || 0;
		}
		
		public function get id() : String
		{
			return animationDataType.id;
		}
		
		protected function onClipComplete( event : AnimatorEvent ) : void
		{
			
			trace ( "sequence is done" );
			dispatchEvent ( new Animation3DEvent ( Animation3DEvent.ANIMATION_COMPLETE ) );
		}
		
		public function get updateRootAnimation():Boolean
		{
			return animationDataType.updateRoot;
		}
		
		public function set updateRootAnimation(value:Boolean):void
		{
			animationDataType.updateRoot = value;
		}
		
		override public function destroy() : void
		{
			super.destroy ();
			
			animationDataType = null;
			
			resource = null;
			
			sequence = null;
			
			controller = null;
		}
	
	}
}

