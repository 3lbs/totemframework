
package totem3d.actors.components
{
	import away3d.materials.TextureMaterial;
	import away3d.materials.lightpickers.LightPickerBase;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.materials.methods.BasicNormalMethod;

	import totem.core.TotemComponent;
	import totem.core.command.CommandManagerComponent;

	import totem3d.actors.commands.SetTextureLightsCommand;
	import totem3d.core.dto.MaterialParam;

	public class LightComponent extends TotemComponent
	{

		private var _textureLights : LightPickerBase;

		private var _useLights : Boolean = true;

		public function LightComponent( param : MaterialParam = null )
		{
			if ( param )
			{
				_useLights = param.useLight;
			}
		}

		override protected function onAdd() : void
		{
			super.onAdd();

			//var materialComponent : ITextureMaterialComponent = getSibling( ITextureMaterialComponent );
			//materialComponent.onUpdateMaterial.add( handleUpdateMaterial );
		}

		public function handleUpdateMaterial( component : ITextureMaterialComponent = null ) : void
		{
			component ||= getSibling( ITextureMaterialComponent );
			var material : TextureMaterial = component.textureMaterial;
			
			if ( material )
			{
				material.lightPicker = ( useLights ) ? textureLights : new StaticLightPicker([]);
				material.normalMethod = new BasicNormalMethod();
			}
		}
		
		public function set useLights( value : Boolean ) : void
		{
			_useLights = value;
			handleUpdateMaterial();
		}

		public function get useLights() : Boolean
		{
			return _useLights;
		}

		public function get textureLights() : LightPickerBase
		{
			return _textureLights;
		}

		public function set textureLights( value : LightPickerBase ) : void
		{
			_textureLights = value;
			handleUpdateMaterial();			
		}
	}
}
