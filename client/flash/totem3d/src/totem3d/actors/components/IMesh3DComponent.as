package totem3d.actors.components
{
	import away3d.entities.Mesh;
	
	import org.osflash.signals.ISignal;

	public interface IMesh3DComponent
	{
		function get meshStatus() : int;
		
		function get mesh() : Mesh;
		
		function set mesh ( value : Mesh ) : void;
			
		//function get meshUpdate () : ISignal;
		
	}
}