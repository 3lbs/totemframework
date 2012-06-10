package totem3d.components
{
	import away3d.animators.SmoothSkeletonAnimator;
	import away3d.animators.data.SkeletonAnimationState;
	import away3d.entities.Mesh;
	
	import flash.utils.Dictionary;
	
	import totem.animation.AnimationEvent;
	import totem.core.Component;
	import totem.enums.LoadStatusEnum;
	import totem.resource.ResourceManager;
	
	import totem3d.away3d.AwayMD5AnimationResource;
	import totem3d.controllers.Sequence3dAnimator;
	import totem3d.core.datatypeobject.AnimationParam;
	import totem3d.events.MeshEvent;
	
	public class Sequence3dAnimatorComponent extends Component implements IAnimatorComponent
	{
		
		[Inject]
		public var resourceManager : ResourceManager;
		
		public static const NAME : String = "Animation3dComponent";
		
		private var _controller : SmoothSkeletonAnimator;
		
		//public var meshPropRef : PropertyReference = new PropertyReference ( MeshComponent.MODEL_REFERENCE );
		
		//public var meshUpdatePropRef : PropertyReference = new PropertyReference ( MeshComponent.MODEL_UPDATE_REFERECENE );
		
		private var animationListStatus : int = LoadStatusEnum.EMPTY;
		
		private var animationDataMap : Dictionary;
		
		private var isPlaying : Boolean = false;
		
		private var animationList : Vector.<AnimationParam>;
		
		private var _updateRootAnimation : Boolean = false; 
		
		public function Sequence3dAnimatorComponent( animationData : Vector.<AnimationParam> )
		{
			
			animationList = animationData;
			super ();
		}
		
		/*public static function getComponent( entity : IEntity ) : Sequence3dAnimatorComponent
		{
			return entity.lookupComponentByName ( NAME ) as Sequence3dAnimatorComponent;
		}*/
		
		override public function onAdded() : void
		{
			super.onAdded ();
			
			animationDataMap = new Dictionary ();
			
			//owner.eventDispatcher.addEventListener ( MeshEvent.MESH_UPDATE, handleMeshUpdateComplete );
		}
		
		public function playAnimation( id : String ) : Boolean
		{
			if ( animationDataMap[ id ] )
			{
				var sequence : Sequence3dAnimator = animationDataMap[ id ];
				sequence.playSequence ();
				
				isPlaying = true;
				
				return true;
			}
			
			return false;
		}
		
		public function loadAnimations( data : Vector.<AnimationParam> ) : void
		{
			var animationData : AnimationParam;
			
			for each ( animationData in data )
			{
				if ( animationDataMap[ animationData.id ] )
				{
					// already loaded
					continue;
				}
				
				// load animation below
				var resource : AwayMD5AnimationResource = resourceManager.load ( animationData.projectURL (), AwayMD5AnimationResource ) as AwayMD5AnimationResource;
				var sequence : Sequence3dAnimator = new Sequence3dAnimator ( animationData, _controller, resource );
				
				sequence.addEventListener ( AnimationEvent.ANIMATION_FINISHED_EVENT, handleSequenceComplete );
				animationDataMap[ animationData.id ] = sequence;
			}
		}
		
		protected function handleSequenceComplete( event : AnimationEvent ) : void
		{
			var sequence : Sequence3dAnimator = event.target as Sequence3dAnimator;
			sequence.stopSequence ();
			isPlaying = false;
		}
		
		public function getAnimationSequence( id : String ) : Sequence3dAnimator
		{
			return animationDataMap[ id ];
		}
		
		public function purgeAnimation() : void
		{
			_controller.disposeAsset ();
		}
		
		public function onTick( deltaTime : Number ) : void
		{
			//super.onTick ( deltaTime );
			
			if ( isPlaying )
			{
				// update mesh and model
				//var mesh : Mesh = owner.getProperty ( meshPropRef ) as Mesh;
				
				//owner.setProperty ( meshUpdatePropRef, mesh.position );
			}
		}
		
		protected function handleMeshUpdateComplete( event : MeshEvent ) : void
		{
			//var mesh : Mesh = owner.getProperty ( meshPropRef ) as Mesh;
			
			//_controller = new SmoothSkeletonAnimator ( SkeletonAnimationState ( mesh.animationState ) );
			//_controller.timeScale = _timeScale;
			
			if ( animationList && animationList.length > 0 )
			{	
				loadAnimations ( animationList )
			}
		}
		
		public function get controller() : SmoothSkeletonAnimator
		{
			return _controller;
		}
		
		public function set controller( value : SmoothSkeletonAnimator ) : void
		{
			_controller = value;
		}
		
		public function get updateRootAnimation():Boolean
		{
			return _updateRootAnimation;
		}
		
		public function set updateRootAnimation(value:Boolean):void
		{
			_controller.updateRootPosition = _updateRootAnimation = value;
		}
	
	
	}
}

