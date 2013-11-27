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

	import org.casalib.util.StringUtil;

	import totem.utils.TypeUtility;

	public class State implements IState
	{
		/** @private */
		internal var stateMachine : Machine;

		private var _name : String;

		public function State( name : String = "" )
		{
			_name = name || TypeUtility.getObjectShortClassName( this ) + "_" + StringUtil.createRandomIdentifier( 3 );
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

		protected final function gotoState( value : String ) : void
		{
			stateMachine.setCurrentState( value );
		}
	}
}
