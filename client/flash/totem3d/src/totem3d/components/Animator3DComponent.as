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
//   3lbs Copyright 2013 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package totem3d.components
{

	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import flare.core.Label3D;
	import flare.core.Mesh3D;
	import flare.core.Pivot3D;
	
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	import totem.core.time.TickedComponent;
	import totem.enums.LoadStatusEnum;
	import totem.monitors.promise.wait;

	public class Animator3DComponent extends TickedComponent
	{
		public static const NAME : String = "Animation3dComponent";

		public var actionSpeed : Number = 1;

		[Inject]
		public var meshComponent : Mesh3DComponent;

		public var onAnimationComplete : ISignal = new Signal( Animator3DComponent );

		public var onUpdatePosition : ISignal = new Signal( Animator3DComponent );

		private var animationDictionary : Dictionary;

		private var animationListStatus : int = LoadStatusEnum.EMPTY;

		private var isPlaying : Boolean = false;

		private var mesh : Mesh3D;

		private var tempAnimationName : String;

		public function Animator3DComponent()
		{
			super();
			animationDictionary = new Dictionary();
		}

		public function addAnimationLabel( label : Label3D ) : void
		{
			animationDictionary[ label.name ] = label;
		}

		override public function onTick() : void
		{
			if ( isPlaying )
			{
				//updateRootAnimation && spatialComponent.updatePosition( mesh.position );
			}
		}

		public function playAnimation( id : String ) : Boolean
		{
			mesh.gotoAndPlay( id );
			return true;
		}

		public function stopAnimation() : void
		{
			isPlaying = false;

			
			//if ( mesh )
			//	mesh.stop();
		}

		protected function handleAnimationComplete( event : Event ) : void
		{
			trace("complete animation event");
			onAnimationComplete.dispatch( this );
			
			//stopAnimation();
			
			//mesh.stop();
			
		//	mesh.prevFrame();
			//mesh.gotoAndPlay( "t-pose", 0, Pivot3D.ANIMATION_STOP_MODE );
		}

		protected function handleMeshUpdateComplete( component : Mesh3DComponent ) : void
		{
			stopAnimation();
			
			if ( mesh )
			{
				mesh.removeEventListener( Pivot3D.ANIMATION_COMPLETE_EVENT, handleAnimationComplete );
			}
			
			mesh = component.mesh;

			var labels : Object = mesh.labels;
			mesh.addEventListener( Pivot3D.ANIMATION_COMPLETE_EVENT, handleAnimationComplete, false, 0, true );

			for each ( var label : Label3D in animationDictionary )
			{
				//mesh.addLabel( label );
			}
			//mesh.gotoAndPlay( mesh.frames.length - 1, 0, Pivot3D.ANIMATION_STOP_MODE );
			//mesh.prevFrame();
			//mesh.gotoAndPlay( "walk", 0, Pivot3D.ANIMATION_LOOP_MODE );
			//mesh.gotoAndPlay( "t-pose", 0, Pivot3D.ANIMATION_STOP_MODE );
			//stopAnimation();
			mesh.gotoAndStop( 1 );
			wait( 500, handleAnimationDelay );
		}
		
		private function handleAnimationDelay () : void
		{
			mesh.gotoAndStop( 1 );
			mesh.stop();
		}
		
		override protected function onAdd() : void
		{
			super.onAdd();

			meshComponent.meshUpdate.add( handleMeshUpdateComplete );
			registerForTicks = true;
		}

		override protected function onRemove() : void
		{
			super.onRemove();

			stopAnimation();

			if ( mesh )
			{
				mesh.removeEventListener( Pivot3D.ANIMATION_COMPLETE_EVENT, handleAnimationComplete );
			}
				
			
			mesh = null;

			if ( animationDictionary )
			{
				for ( var key : String in animationDictionary )
				{
					animationDictionary[ key ] = null;
					delete animationDictionary[ key ];
				}

				animationDictionary = null;
			}

			onUpdatePosition.removeAll();
			onAnimationComplete.removeAll();

		}
	}
}

