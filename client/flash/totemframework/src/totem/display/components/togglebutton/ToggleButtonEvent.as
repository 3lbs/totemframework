package totem.display.components.togglebutton
{
	import totem.events.ObjectEvent;
	
	public class ToggleButtonEvent extends ObjectEvent
	{
		public static const TRIGGERED : String = "ToggleButtonEvent:Triggered";
		
		public function ToggleButtonEvent(type:String, data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, data, bubbles, cancelable);
		}
	}
}