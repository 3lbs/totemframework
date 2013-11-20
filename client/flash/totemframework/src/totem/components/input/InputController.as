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

package totem.components.input
{

	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import totem.core.Destroyable;

	public class InputController extends Destroyable
	{

		public var actionEvent : ISignal = new Signal();

		public function InputController()
		{
		}
	}
}
