package totem.utils.objectpool
{

	public interface IObjectPoolFactory
	{
		function create() : *;
		
		function destroy () : void;
	}
}
