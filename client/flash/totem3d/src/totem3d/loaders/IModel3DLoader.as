package totem3d.loaders
{
	import flare.core.Pivot3D;
	
	import totem.events.IRemovableEventDispatcher;
	
	public interface IModel3DLoader extends IRemovableEventDispatcher
	{
		function getMesh ( value : String ) : Pivot3D;
	}
}