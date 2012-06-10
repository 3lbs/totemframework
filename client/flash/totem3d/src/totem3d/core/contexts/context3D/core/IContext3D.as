package totem3d.core.contexts.context3D.core
{
	import away3d.containers.View3D;
	
	/**
	 * @author Paul Tondeur
	 */
	public interface IContext3D
	{
		function get view3D() : View3D;
		
		function set view3D( value : View3D ) : void
		
		function get map3D() : IMediator3DMap;
		
		function set map3D( value : IMediator3DMap ) : void
	}
}


