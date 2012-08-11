package totem3d.actors.commands.builder
{
	import away3d.animators.SkeletonAnimationState;
	
	import flash.events.Event;
	
	import totem.core.mvc.controller.command.Command;
	import totem.monitors.CompleteListMonitor;
	
	import totem3d.actors.components.SkeletonAnimatorComponent;
	import totem3d.builder.animation.AnimationLoader;
	import totem3d.core.dto.AnimationParam;

	public class LoadMD5AnimationCommand extends Command
	{

		[Inject]
		public var skeletonAnimationComponent : SkeletonAnimatorComponent;

		private var animationList : Vector.<AnimationParam>;

		private var completeMonitor : CompleteListMonitor;

		public function LoadMD5AnimationCommand( animationList : Vector.<AnimationParam> )
		{
			super();
			this.animationList = animationList;
		}

		override public function execute() : void
		{
			completeMonitor = new CompleteListMonitor();
			completeMonitor.addEventListener( Event.COMPLETE, handleAnimationListComplete );

			var animationData : AnimationParam;
			var animationLoader : AnimationLoader;

			for each ( animationData in animationList )
			{
				// load animation below
				animationLoader = new AnimationLoader( animationData );

				completeMonitor.addDispatcher( animationLoader );

				animationLoader.start();
			}
		}

		protected function handleAnimationListComplete( event : Event ) : void
		{
			completeMonitor.removeEventListener( Event.COMPLETE, handleAnimationListComplete );

			var list : Array = completeMonitor.list;

			var loader : AnimationLoader;
			var state : SkeletonAnimationState;
			var animationData : AnimationParam;

			for ( var i : int = 0; i < list.length; ++i )
			{
				loader = list[ i ];

				if ( loader.isFailed )
				{
					// failed to load animation
				}

				animationData = loader.animationData;

				state = loader.resource.state;
				state.looping = animationData.loop;
				state.name = animationData.name;
			
				// Eddie we are going to need a type value for State Machine and AI animation
				// rate
				
				skeletonAnimationComponent.addAnimationState( animationData.id, state );
			}
			
			onComplete.dispatch( this );
		}

		override public function destroy() : void
		{
			super.destroy();

			animationList = null;
			skeletonAnimationComponent = null;

			completeMonitor.destroy();
			completeMonitor = null;
		}
	}
}
