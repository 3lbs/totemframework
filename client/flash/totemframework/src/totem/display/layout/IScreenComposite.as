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

package totem.display.layout
{

	import totem.core.IDestroyable;

	public interface IScreenComposite extends IDestroyable
	{
		function addScreen( screen : ScreenComposite ) : void;

		function removeScreen( screen : ScreenComposite ) : ScreenComposite;
	}
}
