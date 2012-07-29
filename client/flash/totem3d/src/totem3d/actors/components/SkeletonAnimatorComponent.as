package totem3d.actors.components
{
	import away3d.animators.AnimationStateBase;
	import away3d.animators.IAnimationState;
	import away3d.animators.SkeletonAnimationSet;
	import away3d.animators.SkeletonAnimationState;
	import away3d.animators.SkeletonAnimator;
	import away3d.animators.data.Skeleton;
	import away3d.animators.transitions.CrossfadeStateTransition;
	import away3d.entities.Mesh;
	import away3d.events.AnimationStateEvent;
	
	import flash.events.Event;
	
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	import totem.core.time.TickedComponent;
	import totem.enums.LoadStatusEnum;

	public class SkeletonAnimatorComponent extends TickedComponent implements IAnimatorComponent
	{
		public static const NAME : String = "Animation3dComponent";

		[Inject]
		public var spatialComponent : Spatial3DComponent;

		public var onUpdatePosition : ISignal = new Signal( SkeletonAnimatorComponent );

		public var onAnimationComplete : ISignal = new Signal( AnimationStateBase );
		
		public var animator : SkeletonAnimator;

		public var animationSet : SkeletonAnimationSet;

		public var skeleton : Skeleton;

		private var stateTransition : CrossfadeStateTransition = new CrossfadeStateTransition( 0.5 );

		public var actionSpeed : Number = 1;

		private var animationListStatus : int = LoadStatusEnum.EMPTY;

		private var isPlaying : Boolean = false;

		private var mesh : Mesh;

		private var _updateRoot : Boolean = false;

		public function SkeletonAnimatorComponent()
		{
			super();
		}

		override protected function onAdd() : void
		{
			super.onAdd();

			var meshComponent : Mesh3DComponent = getSibling( Mesh3DComponent );
			meshComponent.meshUpdate.add( handleMeshUpdateComplete );

			//owner.ticked.add( onTick );
			registerForTicks = true;
		}

		public function playAnimation( id : String ) : Boolean
		{
			if ( animationSet.hasState( id ))
			{
				animator.playbackSpeed = actionSpeed;
				animator.play( id, stateTransition );
				isPlaying = true;
				return true;
			}
			return false;
		}

		override public function onTick() : void
		{
			if ( isPlaying )
			{
				//updateRootAnimation && spatialComponent.updatePosition( mesh.position );
			}
		}

		public function stopAnimation() : void
		{
			isPlaying = false;
			animator.stop();
		}

		public function addAnimationState( id : *, state : SkeletonAnimationState ) : void
		{
			animationSet.addState( id, state );
			state.addEventListener( AnimationStateEvent.PLAYBACK_COMPLETE, onPlaybackComplete );
		}

		protected function onPlaybackComplete( event : AnimationStateEvent ) : void
		{
			trace( "finisehd anim" );
			onAnimationComplete.dispatch( event.animationState );
		}

		public function setStateLooping( id : *, looping : Boolean ) : void
		{
			var state : IAnimationState = animationSet.getState( id );

			if ( state )
				state.looping = looping;
		}

		public function getState( id : * ) : IAnimationState
		{
			return animationSet.getState( id );
		}

		protected function handleMeshUpdateComplete( component : Mesh3DComponent ) : void
		{
			mesh = component.mesh;
		}

		public function get updateRootAnimation() : Boolean
		{
			return _updateRoot;
		}

		public function set updateRootAnimation( value : Boolean ) : void
		{
			_updateRoot = value;

			if ( animator )
				animator.updateRootPosition = _updateRoot;
		}
		
		override protected function onRemove():void
		{
			super.onRemove();
			
			spatialComponent = null;
			mesh = null;
			
			animator = null;
			
			animationSet.dispose();
			animationSet = null;
			
			skeleton.dispose();
			skeleton = null;
		}
	}
}

