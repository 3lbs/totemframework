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

package totem.structures
{

	public interface ICollection extends IIterable
	{
		function add( element : * ) : Boolean;

		function addAll( collection : ICollection ) : Boolean;

		function clear() : void;

		function clone() : *;

		function contains( element : * ) : Boolean;

		function containsAll( collection : ICollection ) : Boolean;

		function dump() : String;

		function equals( collection : ICollection ) : Boolean;

		function get isEmpty() : Boolean;

		function remove( element : * ) : *;

		function removeAll( collection : ICollection ) : Boolean;

		function retainAll( collection : ICollection ) : Boolean;

		function get size() : int;

		function toArray() : Array;

		function toString( ... args ) : String;
	}
}
