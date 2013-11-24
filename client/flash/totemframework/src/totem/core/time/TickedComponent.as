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
//   3lbs Copyright 2013 
//   For more information see http://www.3lbs.com 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package totem.core.time
{

	import totem.core.TotemComponent;

	/**
	 * Base class for components that need to perform actions every tick. This
	 * needs to be subclassed to be useful.
	 */
	public class TickedComponent extends TotemComponent implements ITicked
	{

		[Inject]
		public var timeManager : TimeManager;

		/**
		 * The update priority for this component. Higher numbered priorities have
		 * onInterpolateTick and onTick called before lower priorities.
		 */
		public var updatePriority : Number = 0.0;

		private var _isRegisteredForUpdates : Boolean = false;

		private var _registerForUpdates : Boolean = true;

		public function TickedComponent( name : String = "" )
		{
			super( name );
		}

		/**
		 * @inheritDoc
		 */
		public function onTick() : void
		{
		}

		/**
		 * @private
		 */
		public function get registerForTicks() : Boolean
		{
			return _registerForUpdates;
		}

		/**
		 * Set to register/unregister for tick updates.
		 */
		public function set registerForTicks( value : Boolean ) : void
		{
			_registerForUpdates = value;

			if ( _registerForUpdates && !_isRegisteredForUpdates )
			{
				// Need to register.
				_isRegisteredForUpdates = true;
				timeManager.addTickedObject( this, updatePriority );
			}
			else if ( !_registerForUpdates && _isRegisteredForUpdates )
			{
				// Need to unregister.
				_isRegisteredForUpdates = false;
				timeManager.removeTickedObject( this );
			}
		}

		override protected function onActivate() : void
		{
			super.onActivate();

			registerForTicks = true;
		}

		override protected function onAdd() : void
		{
			super.onAdd();

			// This causes the component to be registerd if it isn't already.
			registerForTicks = registerForTicks;
		}

		override protected function onRemove() : void
		{
			super.onRemove();

			// Make sure we are unregistered.
			registerForTicks = false;
		}

		override protected function onRetire() : void
		{
			super.onRetire();

			registerForTicks = false;
		}
	}
}
