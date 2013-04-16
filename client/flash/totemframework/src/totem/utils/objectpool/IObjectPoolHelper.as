package totem.utils.objectpool
{
	public interface IObjectPoolHelper
	{
		function retire ( item : * ) : void;
		
		function destroy ( item : * ) : void;
	}
}