
package totem3d.actors.components
{
	import away3d.entities.Mesh;
	import away3d.materials.TextureMaterial;
	import away3d.materials.methods.BasicNormalMethod;
	import away3d.textures.BitmapTexture;
	import away3d.textures.BitmapTextureCache;
	
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	import totem.core.TotemComponent;
	import totem.core.command.CommandManagerComponent;
	
	import totem3d.actors.commands.builder.BuildTextureMaterialCommand;
	import totem3d.core.dto.MaterialParam;
	import totem3d.texture.TextureConfig;
	import totem3d.utils.TextureMaterialUtil;
	
	public class TextureMaterialComponent extends TotemComponent implements ITextureMaterialComponent
	{
		public static const NAME : String = "TextureComponent";
		
		
		[Inject]
		public var meshComponent : IMesh3DComponent;
		
		protected var material : TextureMaterial ;
		
		private var bitmapData : BitmapTexture;
		
		private var smooth : Boolean = false;
		
		private var repeat : Boolean = true;
		
		private var _defaultMaterial : TextureMaterial;
		
		private var materialParam : MaterialParam;
		
		public var onUpdateMaterial : ISignal = new Signal( ITextureMaterialComponent );
		
		public function TextureMaterialComponent( param : MaterialParam = null )
		{
			materialParam = param;
			
			super ();
		}
		
		override protected function onAdd() : void
		{
			super.onAdd ();
			
			
			// loads all the material in the list
			if ( materialParam )
			{
				var commandComponent : CommandManagerComponent = owner.getComponent( CommandManagerComponent );
				commandComponent.executeCommandWithInjection( new BuildTextureMaterialCommand( materialParam ) );
			}
			else
			{
				material = defaultMaterial;
				applyMaterial ();
			}
			
			Mesh3DComponent ( meshComponent ).meshUpdate.add( handleMeshUpdate );
		}
		
		public function handleMeshUpdate( component : Mesh3DComponent ) : void
		{
			// handle material builder!
			applyMaterial ();
		}
		
		protected function applyMaterial() : void
		{
			var meshStatus : int = meshComponent.meshStatus;
			
			// could just test for mesh
			if ( meshStatus == Mesh3DComponent.LOADED )
			{
				var mesh : Mesh = meshComponent.mesh;
				
				if ( mesh.material == material )
					return;
				
				mesh.material = material;
				
				onUpdateMaterial.dispatch( this );
			} 
		}
		
		public function updateMaterialMethod () : void
		{
			if ( material )
			{
				material.normalMethod = new BasicNormalMethod();
			}
		}
		
		public function get textureMaterial() : TextureMaterial
		{
			return material;
		}
		
		public function set textureMaterial( mat : TextureMaterial ) : void
		{
			material = mat;
			applyMaterial ();
		}
		
		private function destroyMaterial( mat : TextureMaterial ) : void
		{
			TextureMaterialUtil.disposeMaterial ( mat );
			mat.dispose ();
		}
		
		override protected function onRemove() : void
		{
			super.onRemove ();
			
			if ( material )
			{
				destroyMaterial ( material );
			}
			
			if ( defaultMaterial )
			{
				TextureMaterialUtil.disposeMaterial ( defaultMaterial );
				
				defaultMaterial.dispose ();
				_defaultMaterial = null;
			}
		
		}
		
		private function get defaultMaterial() : TextureMaterial
		{
			if ( !_defaultMaterial )
				_defaultMaterial = createDefaultTextureMaterial ();
			
			return _defaultMaterial;
		}
		
		private function createDefaultTextureMaterial() : TextureMaterial
		{
			// add default material
			var defaultBitmapTexture : BitmapTexture = BitmapTextureCache.getInstance ().getTexture ( TextureConfig.defaultModelBitmapData );
			var mat : TextureMaterial = new TextureMaterial ( defaultBitmapTexture );
			return mat;
		}
		
	}
}

