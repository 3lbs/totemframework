package com.nocircleno.graffiti.events
{
	import flash.events.Event;
	
	public class DrawEvent extends Event
	{
		
		public static const UPDATE : String = "DrawEvent:Update";
		
		public function DrawEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}