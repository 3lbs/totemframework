package totem.resource
{
	public interface IResourceManager
	{
		function load( filename : String, resourceType : Class, forceReload : Boolean = false ) : IResource;
	}
}