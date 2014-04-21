//------------------------------------------------------------------------------
//a
//     _______ __ __           
//    |   _   |  |  |--.-----. 
//    |___|   |  |  _  |__ --| 
//     _(__   |__|_____|_____| 
//    |:  1   |                d
//                       sa
//   3lbs Copyright 2014 dw
//------------------------------------------------------------------------------

package totem.core.input
{

	import totem.core.IDestroyable;

	public interface IInputMonitor extends IDestroyable
	{

		function get enabled() : Boolean;

		function set enabled( value : Boolean ) : void;

		function subscribe( input : IMobileInput ) : void;

		function unSubscribe( input : IMobileInput ) : void;
	}
}
