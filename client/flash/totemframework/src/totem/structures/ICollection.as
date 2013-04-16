/* * hexagonlib - Multi-Purpose ActionScript 3 Library. *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/  LIBRARY _/ *            \__/  \__/ * * Licensed under the MIT License *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package totem.structures{	/**	 * The base interface for most collection types.	 */	public interface ICollection extends IIterable	{		//-----------------------------------------------------------------------------------------		// Query Operations		//-----------------------------------------------------------------------------------------				/**		 * The number of elements that the collection contains.		 * 		 * @return The number of elements that the collection contains.		 */		function get size():int;						/**		 * Determines if the collection is empty or not. If true is returned, the collection		 * is empty, if false is returned, the collection contains any number of elements.		 * 		 * @return true If the collection contains no elements, otherwise false.		 */		function get isEmpty():Boolean;						/**		 * Determines if the collection contains the specified element.		 * 		 * @return true if the element is contained in the collection, false if not.		 */		function contains(element:*):Boolean;						/**		 * Checks if the collection is equal to the specified collection.		 * 		 * @param collection The collection to be checked against this collection.		 * @return true if both collection are equal, false if not.		 */		function equals(collection:ICollection):Boolean;						/**		 * Clones the collection by returning a new instance of it which equals this		 * collection.		 * 		 * @return A clone of the collection.		 */		function clone():*;						/**		 * Returns an array representation of the collection.		 * 		 * @return An array with the elements of the collection.		 */		function toArray():Array;						/**		 * Returns a string representation of the collection.		 * 		 * @param args Optional parameters that are combined with the resulting String.		 * @return A string representation of the collection.		 */		function toString(...args):String;						/**		 * Returns a dump output of the collection for debugging purposes.		 * 		 * @eturn A dump output of the collection.		 */		function dump():String;						//-----------------------------------------------------------------------------------------		// Modification Operations		//-----------------------------------------------------------------------------------------				/**		 * Adds the specified element to the collection.		 * 		 * @param element The element to add to the collection.		 * @return true if the element was added successfully to the collection or false		 *         if it failed to add the element.		 */		function add(element:*):Boolean;						/**		 * Removes the specified element from the collection and returns it.		 * 		 * @param element The element to remove from the collection.		 * @return The element that was removed.		 */		function remove(element:*):*;						//-----------------------------------------------------------------------------------------		// Bulk Operations		//-----------------------------------------------------------------------------------------				/**		 * Adds all elements of the specified collection to this collection.		 * 		 * @param collection The collection with elements to add to this collection.		 * @return true if the elements of the specified Collection were added successfully.		 */		function addAll(collection:ICollection):Boolean;						/**		 * Removes all elements from this collection that are in the specified collection.		 * 		 * @param collection The collection with elements to remove from this collection.		 * @return true if the elements of the specified Collection were removed successfully.		 */		function removeAll(collection:ICollection):Boolean;						/**		 * Retains all elements in this collection that are also in the specified collection.		 * 		 * @param collection The collection with elements to retain in this collection.		 * @return true if the elements of the specified Collection were retained successfully.		 */		function retainAll(collection:ICollection):Boolean;						/**		 * Checks whether the collection contains all of the elements that are in the		 * specified collection and returns true if all of the elements are found or false		 * if any elements are missing.		 * 		 * @param collection The collection with elements to be checked for containment in		 *            this collection.		 * @return true If the collection contains all of the elements in the specified		 *         collection, otherwise false.		 * @throws com.hexagonstar.exception.NullReferenceException if the specified		 *             collection is null.		 * @throws com.hexagonstar.exception.UnsupportedOperationException if this method is		 *             not supported by the collection.		 */		function containsAll(collection:ICollection):Boolean;						/**		 * Clears the collection. The collection will be empty after a call to this method.		 */		function clear():void;	}}