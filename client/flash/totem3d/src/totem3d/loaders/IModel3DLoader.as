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

package totem3d.loaders
{

	import flare.core.Pivot3D;

	import totem.events.IRemovableEventDispatcher;

	public interface IModel3DLoader extends IRemovableEventDispatcher
	{
		function getMesh() : Pivot3D;
	}
}
