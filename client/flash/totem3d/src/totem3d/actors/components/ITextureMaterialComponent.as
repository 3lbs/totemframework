package totem3d.actors.components
{
	import away3d.materials.TextureMaterial;

	public interface ITextureMaterialComponent
	{
		function get textureMaterial() : TextureMaterial;
		
		function set textureMaterial( mat : TextureMaterial ) : void;
		
	}
}