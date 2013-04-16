package totem3d.events
{
	import flash.events.Event;
	
	import totem3d.core.param.AnimationParam;
	
	public class Animation3DEvent extends Event
	{
		public static const ANIMATION_COMPLETE : String = "Animation3dEvent:animationComplete";
		
		public static const ANIMATION_START : String = "Animation3dEvent:AnimationStart";
		
		public static const LOAD_COMPLETE : String = "Animation3dEvent:LoadComplete";
		
		public var animations : Vector.<AnimationParam>;
		
		public function Animation3DEvent( type : String, data : Vector.<AnimationParam>, bubbles : Boolean = false, cancelable : Boolean = false )
		{
			animations = data;
			super ( type, bubbles, cancelable );
		}
	}
}

