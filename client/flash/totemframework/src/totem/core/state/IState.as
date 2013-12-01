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

package totem.core.state
{

	import totem.core.IDestroyable;

	/**
	 * A state in a state machine. It is given the opportunity each
	 * update of the machine to transition to a new state.
	 *
	 * Callbacks happen AFTER the previous/current state has been updated.
	 */
	public interface IState extends IDestroyable
	{
		/**
		 * Called when the machine enters this state.
		 */
		function enter( fsm : IMachine ) : void;

		/**
		 * Called when we transition out of this state.
		 */
		function exit( fsm : IMachine ) : void;

		/**
		 * Called every time the machine ticks and this is the current state.
		 *
		 * Typically this function will call setCurrentState on the FSM to update
		 * its state.
		 */
		function tick( fsm : IMachine ) : void;
	}
}
