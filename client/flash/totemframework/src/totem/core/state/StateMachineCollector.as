package totem.core.state
{
	import org.swiftsuspenders.Injector;
	
	import totem.core.Destroyable;
	import totem.data.InList;

	public class StateMachineCollector extends Destroyable
	{
		/** @private */
		protected var stateMachines_ : InList = new InList();

		public function StateMachineCollector()
		{
		}

		public function add( stateMachine : StateMachine ) : void
		{
			//stateMachines_.add( stateMachine );
			//stateMachine.setInjector( getInjector());
			//stateMachine.owningGroup = this.owningGroup;
			
			//getInjector().injectInto( stateMachine );
		}
		
		/**
		 * @private
		 */
		internal function injectChildren( injector : Injector ) : void
		{
			
		}
		
		public function remove( stateMachine : StateMachine ) : void
		{
			//stateMachines_.remove( stateMachine );
			//stateMachine.setInjector( null );
			//stateMachine.owningGroup = this.owningGroup;

		}
		
		override public function destroy():void
		{
			super.destroy();
			
			
		}
	}
}
