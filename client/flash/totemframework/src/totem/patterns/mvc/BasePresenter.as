package totem.patterns.mvc
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import org.casalib.events.RemovableEventDispatcher;
	import org.swiftsuspenders.Injector;

	public class BasePresenter extends RemovableEventDispatcher
	{
		[Inject]
		public var eventDispatcher : IEventDispatcher;
		
		
		public function BasePresenter( target : IEventDispatcher = null )
		{
			super( target );
		}
		
		[PostConstruct]
		public function initialize () : void
		{
			
		}
		
		protected function contextDispatchEvent ( e : Event ) : void
		{
			if ( eventDispatcher.hasEventListener( e.type ))
				eventDispatcher.dispatchEvent( e );
		}
		
	}
}
