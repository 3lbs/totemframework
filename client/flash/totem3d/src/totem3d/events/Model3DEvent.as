package totem3d.events
{
	import totem.events.ObjectEvent;
	
	public class Model3DEvent extends ObjectEvent
	{
		
		public static const ADD_MODEL_TO_VIEW : String = "Model3DEvent:AddModelToView";
		
		public static const  LOAD_MODEL : String = "Model3DEvent:LoadModel";
		
		public function Model3DEvent(type:String, data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, data, bubbles, cancelable);
		}
	}
}

