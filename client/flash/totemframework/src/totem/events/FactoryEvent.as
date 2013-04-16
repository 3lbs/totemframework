package totem.events
{
	import flash.events.Event;
	
	public class FactoryEvent extends Event
	{
		
		public static const BUILD_ERROR : String = "FactoryEvent:BuildError";
		
		/**
		 * Dispatched when a resource and all of its dependencies is retrieved.
		 */
		public static const BUILD_COMPLETE : String = "FactoryEvent:buildComplete";
		
		/**
		 * Dispatched when a resource's dependency is retrieved and resolved.
		 */
		public static const DEPENDENCY_COMPLETE : String = "FactoryEvent:dependencyComplete";
		
		
		public function FactoryEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}