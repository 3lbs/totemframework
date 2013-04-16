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
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package AI.statemachine
{

	import totem.core.state.Machine;
	import totem.core.state.StateMachineComponent;

	public class BehaviorStateMachineComponent extends StateMachineComponent
	{
		public static const NAME : String = "BehaviorStateMachineComponent";

		public function BehaviorStateMachineComponent( machine : Machine )
		{
			super( machine );
		}
	}
}

