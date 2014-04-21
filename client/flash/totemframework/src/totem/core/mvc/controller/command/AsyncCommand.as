package totem.core.mvc.controller.command
{
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	import org.swiftsuspenders.Injector;
	
	import totem.totem_internal;

	use namespace totem_internal;
	
	public class AsyncCommand extends Command
	{
		public function AsyncCommand()
		{
			super();
		}
		
		totem_internal var onComplete : ISignal = new Signal( Boolean );
		
		private var _isComplete : Boolean;
		
		
		[Inject]
		/**
		 * @private
		 */
		public function injectChildren( injector : Injector ) : void
		{
			
		}
		
		public function get isComplete() : Boolean
		{
			return _isComplete;
		}
		
		protected final function complete( success : Boolean = true ) : void
		{
			_isComplete = true;
			onComplete.dispatch( success );
		}
		
		override public function destroy():void
		{
			super.destroy();
			
			onComplete.removeAll();
			onComplete = null;
				
		}
	}
}