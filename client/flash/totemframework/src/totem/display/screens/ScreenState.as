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

package totem.display.screens
{

	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import totem.core.Destroyable;
	import totem.display.layout.ScreenComposite;

	public class ScreenState extends Destroyable implements IScreenState
	{

		public var canBeDestroyed : Boolean = true;

		public var exitTransistion : String;

		public var isInitialized : Boolean = false;

		public var playOnce : Boolean = true;

		public var screen : ScreenComposite;

		protected var _completeDispatcher : ISignal = new Signal();

		public function ScreenState()
		{
			super();
		}

		public function get completeDispatcher() : ISignal
		{
			return _completeDispatcher;
		}

		public function enter( fsm : ScreenStateMachine ) : void
		{
			if ( !isInitialized )
				initialized();
		}

		public function exit( fsm : ScreenStateMachine ) : void
		{
			if ( canBeDestroyed && playOnce )
			{
				fsm.removeState( this );
					//destroy();
			}
		}

		public function initialized() : void
		{
			if ( isInitialized )
				return;
			doInitialized();
			isInitialized = true;
		}

		protected function doInitialized() : void
		{
		}
		;
	}
}
