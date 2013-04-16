/* * hexagonlib - Multi-Purpose ActionScript 3 Library. *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/  LIBRARY _/ *            \__/  \__/ * * Licensed under the MIT License *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package totem.structures{	/**	 * The NullIterator is used to write classes that are iterable and adhere to an	 * iterable interface but that don't actually have any collection data.	 * <p>An	 * example for the use of a NullIterator is the leaf element of a composite object	 * in the Composite Pattern. In such cases it's necessary that the leaf elements	 * (which are containing no collection data) and the composite elements (that do	 * contain collection data) implement the same interface and be treated in the same	 * way. For recursive traversal purposes, it's necessary that the interface provides	 * access to an iterator for both composite and leaf elements.</p>	 */	public class NullIterator implements IIterator	{		//-----------------------------------------------------------------------------------------		// Public Methods		//-----------------------------------------------------------------------------------------				/**		 * Does nothing and only returns null. The NullIterator can't remove any		 * elements.		 * 		 * @return null.		 */		public function remove():*		{			return null;		}						/**		 * Does nothing. The NullIterator can't be resetted.		 */		public function reset():void		{		}						//-----------------------------------------------------------------------------------------		// Getters & Setters		//-----------------------------------------------------------------------------------------				/**		 * Returns false, regardless of the underlying data structure's condition.		 * 		 * @return false.		 */		public function get hasNext():Boolean		{			return false;		}						/**		 * Returns null, regardless of the underlying data structure's condition.		 * 		 * @return null.		 */		public function get next():*		{			return null;		}	}}