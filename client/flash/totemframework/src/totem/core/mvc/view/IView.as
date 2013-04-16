package totem.core.mvc.view
{
	import totem.core.IDestroyable;
	
	public interface IView extends IDestroyable
	{
		function initialize () : void;
	}
}