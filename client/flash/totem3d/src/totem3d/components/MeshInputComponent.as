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
//   For more information see http://www.3lbs.com 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package totem3d.components
{

	import flare.collisions.CollisionInfo;
	import flare.core.Mesh3D;
	import flare.events.MouseEvent3D;

	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import totem.core.TotemComponent;

	public class MeshInputComponent extends TotemComponent
	{
		public static const NAME : String = "InputComponent";

		[Inject]
		public var meshComponent : Mesh3DComponent;

		public var mouseDownDispatcher : ISignal = new Signal( CollisionInfo );

		public var mouseMoveDispatcher : ISignal = new Signal( CollisionInfo );

		public var mouseOutDispatcher : ISignal = new Signal( CollisionInfo );

		public var mouseOverDispatcher : ISignal = new Signal( CollisionInfo );

		public var mouseUpDispatcher : ISignal = new Signal( CollisionInfo );

		private var _enabled : Boolean = true;

		private var mesh : Mesh3D;

		public function MeshInputComponent( name : String = null )
		{
			super( name || NAME );
		}

		public function get enabled() : Boolean
		{
			return _enabled;
		}

		public function set enabled( value : Boolean ) : void
		{
			_enabled = value;
		}

		protected function handleMeshUpdateComplete( component : Mesh3DComponent ) : void
		{

			if ( mesh )
				removeEventListeners();

			mesh = component.mesh;
			
			if ( mesh )
				addEventListners();
		}

		protected function mouseDownEvent( event : MouseEvent3D ) : void
		{
			if ( _enabled )
				mouseDownDispatcher.dispatch( event.info );
		}

		protected function mouseMoveEvent( event : MouseEvent3D ) : void
		{
			if ( _enabled )
				mouseMoveDispatcher.dispatch( event.info );
		}

		protected function mouseOutEvent( event : MouseEvent3D ) : void
		{
			if ( _enabled )
				mouseOutDispatcher.dispatch( event.info );
		}

		protected function mouseOverEvent( event : MouseEvent3D ) : void
		{
			if ( _enabled )
				mouseOutDispatcher.dispatch( event.info );
		}

		protected function mouseUpEvent( event : MouseEvent3D ) : void
		{
			if ( _enabled )
				mouseUpDispatcher.dispatch( event.info );
		}

		override protected function onAdd() : void
		{
			super.onAdd();
			meshComponent.meshUpdate.add( handleMeshUpdateComplete );
		}

		override protected function onRemove() : void
		{
			super.onRemove();

			removeEventListeners();
			mesh = null;
		}

		private function addEventListners() : void
		{
			mesh.addEventListener( MouseEvent3D.MOUSE_OVER, mouseOverEvent );
			mesh.addEventListener( MouseEvent3D.MOUSE_OUT, mouseOutEvent );
			mesh.addEventListener( MouseEvent3D.MOUSE_MOVE, mouseMoveEvent );
			mesh.addEventListener( MouseEvent3D.MOUSE_DOWN, mouseDownEvent );
			mesh.addEventListener( MouseEvent3D.MOUSE_UP, mouseUpEvent );
		}

		private function removeEventListeners() : void
		{
			mesh.removeEventListener( MouseEvent3D.MOUSE_OVER, mouseOverEvent );
			mesh.removeEventListener( MouseEvent3D.MOUSE_OUT, mouseOutEvent );
			mesh.removeEventListener( MouseEvent3D.MOUSE_MOVE, mouseMoveEvent );
			mesh.removeEventListener( MouseEvent3D.MOUSE_DOWN, mouseDownEvent );
			mesh.removeEventListener( MouseEvent3D.MOUSE_UP, mouseUpEvent );
		}
	}
}
