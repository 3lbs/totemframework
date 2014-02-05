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

	public interface ITotemIterator
	{
		/**
		 * Determines whether the iterator has more elements to iterate over.
		 *
		 * @return true if there is any other element to iterate over or false if not.
		 */
		function hasNext() : Boolean;

		/**
		 * The next element that is iterated by the Iterator.
		 *
		 * @return The next element.
		 */
		function next() : *;

		/**
		 * Removes the currently iterated element from the iterated collection and
		 * returns it.
		 *
		 * @return The removed element.
		 */
		function remove() : *;

		/**
		 * Resets the iterator.
		 */
		function reset() : void;
	}
}
