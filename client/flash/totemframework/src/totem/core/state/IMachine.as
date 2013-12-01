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
	 * Base interface for a finite state machine.
	 */
	public interface IMachine extends IDestroyable
	{

		/**
		 * Register a state under a name.
		 */
		function addState( name : String, state : IState ) : void;

		/**
		 * Get the name of the current state.
		 */
		function get currentStateName() : String;

		/**
		 * What state are we on this tick?
		 */
		function getCurrentState() : IState;

		/**
		 * What state were we on on the previous tick?
		 */
		function getPreviousState() : IState;

		/**
		 * Get the state registered under the provided name.function get owner() : TotemEntity
		 */
		function getState( name : String ) : IState;

		/**
		 * If this state is registered with us, give back the name it is under.
		 */
		function getStateName( state : IState ) : String;


		/**
		 * Update the FSM to be in a new state. Current/previous states
		 * are updated accordingly, and callbacks and events are dispatched.
		 */
		function setCurrentState( name : String ) : Boolean;
		/**
		 * Update the state machine. The current state is given the opportunity
		 * to transition to another state.
		 */
		function tick() : void;
	}
}
