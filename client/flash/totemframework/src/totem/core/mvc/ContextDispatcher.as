package totem.core.mvc
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import totem.core.Destroyable;

	public class ContextDispatcher extends Destroyable 
	{

		[Inject]
		public var eventDispatcher : IEventDispatcher;

		protected function dispatchContext( e : Event ) : void
		{
			if ( eventDispatcher.hasEventListener( e.type ))
				eventDispatcher.dispatchEvent( e );
		}
		
		override public function destroy():void
		{
			super.destroy();
			
			eventDispatcher = null;
		}
	}
}
