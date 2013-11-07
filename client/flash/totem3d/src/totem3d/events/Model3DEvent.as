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

package totem3d.events
{

	import totem.events.ObjectEvent;

	public class Model3DEvent extends ObjectEvent
	{

		public static const ADD_MODEL_TO_VIEW : String = "Model3DEvent:AddModelToView";

		public static const LOAD_MODEL : String = "Model3DEvent:LoadModel";

		public function Model3DEvent( type : String, data : Object = null, bubbles : Boolean = false, cancelable : Boolean = false )
		{
			super( type, data, bubbles, cancelable );
		}
	}
}

