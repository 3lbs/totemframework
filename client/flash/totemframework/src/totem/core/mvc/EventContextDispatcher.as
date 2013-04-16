package totem.core.mvc
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import totem.events.RemovableEventDispatcher;
	import totem.monitors.startupmonitor.IStartupProxy;
	
	public class EventContextDispatcher extends RemovableEventDispatcher implements IStartupProxy
	{
		[Inject]
		public var eventDispatcher : IEventDispatcher;
		
		public function EventContextDispatcher(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		protected function dispatchContext( e : Event ) : void
		{
			if ( eventDispatcher.hasEventListener( e.type ))
				eventDispatcher.dispatchEvent( e );
		}
		
		public function load():void
		{
			throw new Error("Must be overriden");
		}
	}
}