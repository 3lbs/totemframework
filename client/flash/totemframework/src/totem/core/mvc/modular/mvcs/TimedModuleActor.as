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

package totem.core.mvc.modular.mvcs
{

	import totem.core.ITotemSystem;
	import totem.core.time.ITicked;
	import totem.core.time.TimeManager;

	public class TimedModuleActor extends ModuleActor implements ITicked, ITotemSystem
	{

		[Inject]
		public var timeManager : TimeManager;

		public var updatePriority : Number = 0.0;

		private var _isRegisteredForUpdates : Boolean;

		private var _lastUpdate : Number = 0;

		private var _registerForUpdates : Boolean;

		public function TimedModuleActor()
		{
			super();
		}

		override public function destroy() : void
		{
			registerForTicks = false;

			timeManager = null;

			super.destroy();
		}

		public function initialize() : void
		{
			registerForTicks = true;
		}

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
					//timeManager.addTickedObject( this, updatePriority );
			}
			else if ( !_registerForUpdates && _isRegisteredForUpdates )
			{
				// Need to unregister.
				_isRegisteredForUpdates = false;
					//timeManager.removeTickedObject( this );
			}
		}
	}
}
