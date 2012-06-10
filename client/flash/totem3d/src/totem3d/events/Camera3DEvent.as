package totem3d.events
{
	import totem.events.ObjectEvent;
	
	public class Camera3DEvent extends ObjectEvent
	{
		
		public static const START_HOVER : String = "Camera3DEvent:StartHover";
		
		public static const END_HOVER : String = "Camera3dEvent:EndHover";
		
		public static const HOVER_CAMERA:String = "Camera3dEvent:HoverCamera";
		
		public function Camera3DEvent(type:String, data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, data, bubbles, cancelable);
		}
	}
}

