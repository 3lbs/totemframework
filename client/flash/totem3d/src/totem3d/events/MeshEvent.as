package totem3d.events
{
	import flash.events.Event;
	
	public class MeshEvent extends Event
	{
		
		public static const MESH_COMPLETE : String = "MeshEvent:MeshComplete";
		
		public static const MESH_UPDATE : String = "MeshEvent:MeshUpdate";
		
		public static const POSITION_CHANGE:String = "MeshEvent:PositionChange";
		
		public function MeshEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new MeshEvent( type, bubbles, cancelable );
		}
	}
}

