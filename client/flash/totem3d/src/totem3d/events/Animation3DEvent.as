package totem3d.events
{
	import flash.events.Event;
	
	public class Animation3DEvent extends Event
	{
		public static const ANIMATION_COMPLETE : String = "Animation3dEvent:animationComplete";
		
		public static const ANIMATION_START : String = "Animation3dEvent:AnimationStart";
		
		public function Animation3DEvent( type : String, bubbles : Boolean = false, cancelable : Boolean = false )
		{
			super ( type, bubbles, cancelable );
		}
	}
}

