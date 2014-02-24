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

package totem.core.state
{

	import totem.core.Destroyable;
	import totem.utils.UID;

	public class State extends Destroyable implements IState
	{
		/** @private */
		internal var stateMachine : Machine;

		private var _name : String;

		public function State( name : String = "" )
		{
			_name = name || UID.create( this );
		}

		public function enter( fsm : IMachine ) : void
		{
		}

		public function exit( fsm : IMachine ) : void
		{
		}

		public function get name() : String
		{
			return _name;
		}

		public function tick( fsm : IMachine ) : void
		{
		}

		protected final function goToPreviousState() : Boolean
		{
			return stateMachine.goToPreviousState();
		}

		protected final function gotoState( value : String ) : void
		{
			stateMachine.setCurrentState( value );
		}
	}
}
