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

	import flare.core.Mesh3D;
	import flare.materials.Shader3D;
	
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	import totem.core.TotemComponent;

	public class TextureMaterialComponent extends TotemComponent
	{
		public static const NAME : String = "TextureComponent";

		[Inject]
		public var meshComponent : Mesh3DComponent;

		public var onUpdateMaterial : ISignal = new Signal( TextureMaterialComponent );

		protected var material : Shader3D;

		private var repeat : Boolean = true;

		private var smooth : Boolean = false;

		public function TextureMaterialComponent()
		{
			super();
		}

		public function handleMeshUpdate( component : Mesh3DComponent ) : void
		{
			// handle material builder!
			applyMaterial();
		}

		public function get textureMaterial() : Shader3D
		{
			return material;
		}

		public function set textureMaterial( mat : Shader3D ) : void
		{
			if ( mat == material )
				return;

			material = mat;
			applyMaterial();
		}

		public function updateMaterialMethod() : void
		{
		}

		protected function applyMaterial() : void
		{
			var meshStatus : int = meshComponent.meshStatus;

			// could just test for mesh
			if ( meshStatus == Mesh3DComponent.LOADED && material )
			{
				var mesh : Mesh3D = meshComponent.mesh;
				//mesh.getMaterialByName( "mElsa" ) as Shader3D;

				//if ( mesh.material == material )
				//return;

				//mesh.material = material;

				onUpdateMaterial.dispatch( this );
			}
		}

		override protected function onAdd() : void
		{
			super.onAdd();

			meshComponent.meshUpdate.add( handleMeshUpdate );
		}

		override protected function onRemove() : void
		{
			super.onRemove();

			if ( material )
			{
				//TextureMaterialUtil.disposeMaterial( material );
				material = null;
			}

			meshComponent = null;

			onUpdateMaterial.removeAll();
			onUpdateMaterial = null;

		}

		private function destroyMaterial( mat : * ) : void
		{
		}
	}
}

