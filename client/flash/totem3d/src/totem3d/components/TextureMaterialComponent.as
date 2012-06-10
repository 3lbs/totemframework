
package totem3d.components
{
	import away3d.entities.Mesh;
	import away3d.materials.TextureMaterial;
	import away3d.materials.lightpickers.LightPickerBase;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.materials.methods.BasicNormalMethod;
	import away3d.textures.BitmapTexture;
	import away3d.textures.BitmapTextureCache;
	
	import flash.events.Event;
	
	import totem.core.Component;
	
	import totem3d.builder.MaterialFactory;
	import totem3d.core.datatypeobject.MaterialParam;
	import totem3d.events.MaterialEvent;
	import totem3d.events.MeshEvent;
	import totem3d.texture.TextureConfig;
	import totem3d.utils.TextureMaterialUtil;
	
	public class TextureMaterialComponent extends Component
	{
		public static const NAME : String = "TextureComponent";
		
		private var material : TextureMaterial;
		
		//public var meshPropRef : PropertyReference = new PropertyReference ( MeshComponent.MODEL_REFERENCE );
		
		//public var meshStatusPropRef : PropertyReference = new PropertyReference ( MeshComponent.MESH_STATUS );
		
		private var bitmapData : BitmapTexture;
		
		private var smooth : Boolean = false;
		
		private var repeat : Boolean = true;
		
		private var _defaultMaterial : TextureMaterial;
		
		private var materialParam : MaterialParam;
		
		private var _textureLights : LightPickerBase;
		
		private var _useLights : Boolean = true;
		
		public function TextureMaterialComponent( param : MaterialParam = null )
		{
			materialParam = param;
			
			if ( materialParam )
			{
				_useLights = materialParam.useLight;
			}
			
			super ();
		}
		
		/*public static function getComponent( entity : IEntity ) : TextureMaterialComponent
		{
			return entity.lookupComponentByName ( NAME ) as TextureMaterialComponent;
		}*/
		
		override public function onAdded() : void
		{
			super.onAdded ();
			
			//owner.eventDispatcher.addEventListener ( MeshEvent.MESH_UPDATE, handleMeshUpdate );
			
			// loads all the material in the list
			if ( materialParam )
			{
				loadMaterial ( materialParam );
			}
			else
			{
				material = defaultMaterial;
				applyMaterial ();
			}
		
		}
		
		public function loadMaterial( param : MaterialParam ) : void
		{
			materialParam = param;
			
			_useLights = materialParam.useLight;
			
			var materialFactory : MaterialFactory = new MaterialFactory ( param );
			materialFactory.addEventListener ( Event.COMPLETE, handleMaterialBuildComplete );
			
			//context.injectInto ( materialFactory );
			
			materialFactory.start ();
		}
		
		protected function handleMaterialBuildComplete( event : Event ) : void
		{
			
			var factory : MaterialFactory = event.target as MaterialFactory;
			factory.removeEventListener ( Event.COMPLETE, handleMaterialBuildComplete );
			
			material = factory.getResult ();
			
			factory.destroy ();
			
			applyMaterial ();
		}
		
		private function handleMeshUpdate( eve : MeshEvent ) : void
		{
			// handle material builder!
			applyMaterial ();
		}
		
		private function applyMaterial() : void
		{
			var meshStatus : int = 0; //owner.getProperty ( meshStatusPropRef ) as int;
			
			// could just test for mesh
			if ( meshStatus == MeshComponent.LOADED )
			{
				var mesh : Mesh = null; //owner.getProperty ( meshPropRef );
				
				mesh.material = material;
				
				if ( material && textureLights && _useLights )
				{
					material.lightPicker = textureLights;
					material.normalMethod = new BasicNormalMethod();
				}
				
				//owner.eventDispatcher.dispatchEvent ( new MaterialEvent ( MaterialEvent.MATERIAL_LOADED ) );
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
		
		override public function onRemoved() : void
		{
			super.onRemoved ();
			
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
		
		public function set useLights( value : Boolean ) : void
		{
			
			_useLights = value;
			
			if ( !_useLights )
			{
				material.lightPicker = new StaticLightPicker([]);
				material.normalMethod = new BasicNormalMethod();
			}
			applyMaterial ();
		}
		
		public function setLights( lights : LightPickerBase ) : void
		{
			textureLights = lights;
			material.lightPicker = new StaticLightPicker([]);
			
			applyMaterial ();
		}
		
		public function get currentMaterial() : TextureMaterial
		{
			return material;
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
		
		public function get textureLights() : LightPickerBase
		{
			return _textureLights;
		}
		
		public function set textureLights( value : LightPickerBase ) : void
		{
			_textureLights = value;
		}
	
	}
}

