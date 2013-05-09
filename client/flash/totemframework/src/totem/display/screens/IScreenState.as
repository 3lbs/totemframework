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

	/**
	 * A state in a state machine. It is given the opportunity each
	 * update of the machine to transition to a new state.
	 *
	 * Callbacks happen AFTER the previous/current state has been updated.
	 */
	public interface IScreenState
	{

		function get completeDispatcher() : ISignal;
		
		/**
		 * Called when the machine enters this state.
		 */
		function enter( fsm : ScreenStateMachine ) : void;
		/**
		 * Called every time the machine ticks and this is the current state.
		 *
		 * Typically this function will call SetCurrentState on the FSM to update
		 * its state.
		 */
		//function tick(fsm:IMachine):void;

		/**
		 * Called when we transition out of this state.
		 */
		function exit( fsm : ScreenStateMachine ) : void;

		function initialized() : void;
	}
}
