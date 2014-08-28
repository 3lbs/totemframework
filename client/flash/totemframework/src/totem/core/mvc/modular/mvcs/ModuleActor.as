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

	import flash.events.Event;

	import totem.core.mvc.model.Model;
	import totem.core.mvc.modular.core.IModuleEventDispatcher;

	public class ModuleActor extends Model
	{
		/**
		 * @private
		 */
		protected var _moduleEventDispatcher : IModuleEventDispatcher;

		public function ModuleActor()
		{
		}

		public function addModuleListner( type : String, listener : Function ) : Boolean
		{
			return _moduleEventDispatcher.addEventListener( type, listener, false, 0, true );
		}

		override public function destroy() : void
		{
			super.destroy();

			_moduleEventDispatcher = null;
		}

		//---------------------------------------------------------------------
		//  API
		//---------------------------------------------------------------------

		/**
		 * @inheritDoc
		 */
		public function get moduleEventDispatcher() : IModuleEventDispatcher
		{
			return _moduleEventDispatcher;
		}

		[Inject]
		/**
		 * @private
		 */
		public function set moduleEventDispatcher( value : IModuleEventDispatcher ) : void
		{
			_moduleEventDispatcher = value;
		}

		protected function dispatchToModules( event : Event ) : Boolean
		{
			if ( moduleEventDispatcher.hasEventListener( event.type ))
				return moduleEventDispatcher.dispatchEvent( event );
			return true;
		}
	}
}
