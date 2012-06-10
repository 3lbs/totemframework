package totem3d.events
{
	import totem.events.ObjectEvent;
	
	import flash.events.Event;
	
	public class View3DEvent extends ObjectEvent
	{
		
		public static const RESIZE_VIEW : String = "View3DEvent:ResizeView";
		
		public static var VIEW_INIT: String = "View3DEvent:ViewInit";
		
		public function View3DEvent(type:String, data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, data, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new View3DEvent( type, data, bubbles, cancelable ) as Event;
		}
	}
}

