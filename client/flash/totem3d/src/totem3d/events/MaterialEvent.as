package totem3d.events
{
	import totem.events.ObjectEvent;
	
	public class MaterialEvent extends ObjectEvent
	{
		public static var MATERIAL_LOADED:String = "MaterialEvent.materialLoaded";
		
		public function MaterialEvent(type:String, data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, data, bubbles, cancelable);
		}
	
	
	}


}

