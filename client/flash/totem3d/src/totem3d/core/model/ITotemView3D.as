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

package totem3d.core.model
{

	import flare.basic.Viewer3D;

	import totem.events.IRemovableEventDispatcher;

	public interface ITotemView3D extends IRemovableEventDispatcher
	{
		function get viewer3D() : Viewer3D;
		
		function reset () : void;
	}
}
