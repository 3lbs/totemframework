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

package totem.components.display
{

	import starling.display.DisplayObject;

	import totem.core.IDestroyable;

	public interface ISceneRenderer extends IDestroyable
	{
		function get displayObject() : DisplayObject;

		function get zIndex() : int;

		function set zIndex( value : int ) : void;
	}
}
