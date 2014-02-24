//------------------------------------------------------------------------------
//
//     _______ __ __           
//    |   _   |  |  |--.-----. 
//    |___|   |  |  _  |__ --| 
//     _(__   |__|_____|_____| 
//    |:  1   |                
//    |::.. . |                
//    `-------'      
//                       
//   3lbs Copyright 2014 
//   For more information see http://www.3lbs.com 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package totem.core.time
{

	import totem.core.TotemComponent;

	/**
	 * Base class for components which want to use think notifications.
	 *
	 * <p>"Think notifications" allow a component to specify a time and
	 * callback function which should be called back at that time. In this
	 * way you can easily build complex behavior (by changing which callback
	 * you pass) which is also efficient (because it is only called when
	 * needed, not every tick/frame). It is also light on the GC because
	 * no allocations are required beyond the initial allocation of the
	 * ThinkingComponent.</p>
	 */
	public class QueuedComponent extends TotemComponent implements IQueued
	{

		[Inject]
		public var timeManager : TimeManager;

		protected var _nextThinkCallback : Function;

		protected var _nextThinkTime : int;

		public function get nextThinkCallback() : Function
		{
			return _nextThinkCallback;
		}

		public function get nextThinkTime() : Number
		{
			return _nextThinkTime;
		}

		public function get priority() : int
		{
			return -_nextThinkTime;
		}

		public function set priority( value : int ) : void
		{
			throw new Error( "Unimplemented." );
		}

		/**
		 * Schedule the next time this component should think.
		 * @param nextCallback Function to be executed.
		 * @param timeTillThink Time in ms from now at which to execute the function (approximately).
		 */
		public function think( nextCallback : Function, timeTillThink : int ) : void
		{
			_nextThinkTime = timeManager.virtualTime + timeTillThink;
			_nextThinkCallback = nextCallback;

			timeManager.queueObject( this );
		}

		public function unthink() : void
		{
			timeManager.dequeueObject( this );
		}

		override protected function onRemove() : void
		{
			super.onRemove();

			// Do not allow us to be called back if we are still
			// in the queue.
			_nextThinkCallback = null;
		}
	}
}
