package totem3d.actors.commands
{
	import away3d.materials.TextureMaterial;
	import away3d.materials.lightpickers.LightPickerBase;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.materials.methods.BasicNormalMethod;
	
	import mx.states.OverrideBase;
	
	import totem.core.mvc.controller.command.Command;
	
	import totem3d.actors.components.LightComponent;
	import totem3d.actors.components.TextureMaterialComponent;

	public class SetTextureLightsCommand extends Command
	{
		
		[Inject]
		public var textureMaterialComponent : TextureMaterialComponent;
		
		private var textureLights : LightPickerBase;
		
		private var useLights : Boolean;
		
		public function SetTextureLightsCommand( textureLights : LightPickerBase, useLights : Boolean )
		{
			super();
			
			this.textureLights = textureLights;
			this.useLights = useLights;
			
		}

		override public function execute() : void
		{
			super.execute();
			
			var material : TextureMaterial = textureMaterialComponent.textureMaterial;
			
			if ( !useLights )
			{
				material.lightPicker = new StaticLightPicker([]);
			}
			else
			{
				material.lightPicker = textureLights;
			}
			
			material.normalMethod = new BasicNormalMethod();
			
			onComplete.dispatch( this );
		}
		
		override public function destroy():void
		{
			super.destroy();
						
			textureMaterialComponent = null;
			textureLights = null;
		}
	}
}
