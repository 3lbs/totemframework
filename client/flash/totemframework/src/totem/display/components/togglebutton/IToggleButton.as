package totem.display.components.togglebutton
{
	import totem.core.IDestroyable;
	import totem.events.IRemovableEventDispatcher;

	public interface IToggleButton extends IRemovableEventDispatcher, IDestroyable
	{
		
		function get name () : String;
		
		function set data ( value : Object ) : void;
		
		function get data () : Object;
		
		function set selected ( value : Boolean ) : void;
		
		function get selected () : Boolean;
	}
}