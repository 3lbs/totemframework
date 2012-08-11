package totem.core.mvc.controller.command
{
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	import org.swiftsuspenders.Injector;
	
	import totem.core.Destroyable;
	import totem.core.TotemObject;

	public class Command extends Destroyable
	{
		/** @private */
		internal var isComplete : Boolean;

		public var onComplete : ISignal = new Signal( Command );

		public function Command()
		{
		}
		
		[Inject]
		/**
		 * @private
		 */
		internal function injectChildren( injector : Injector ) : void
		{

		}
		
		public function execute() : void
		{
		}
		
		
		protected final function complete():void
		{
			isComplete = true;
			onComplete.dispatch(this);
		}	
	}
}
