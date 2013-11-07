/*
Copyright (c) 2011 Jeroen Beckers

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

package totem.pathfinder.astar.core
{

	/**
	 * The AstarPath defines the path that is found by the Astar class.
	 * 
	 * @author Jeroen Beckers
	 */
	public class AstarPath
	{
		/**
		 * A list containing the path
		 */
		private var _path:Vector.<IAstarTile>;
		
		private var _cost:Number;
		
		/**
		 * Creates a new AstarPath instance.
		 * 
		 * @param cost		The total cost of this path
		 * @param path		The list of IAstarTiles making up the path
		 */
		
		public function AstarPath(cost:Number = 0, path:Vector.<IAstarTile> = null)
		{
			_path = path;
			if(_path == null) _path = new Vector.<IAstarTile>();
			
			_cost = cost;
		}
		
		/**
		 * Gets the cost of this AstarPath
		 */
		public function get cost():Number
		{
			return _cost;
		}
		
		
		/**
		 * Returns a list representation of the path
		 * 
		 * @return A list containing the path
		 */
		public function get path():Vector.<IAstarTile>
		{
			return _path.slice();
		}
		
		
		/**
		 * Returns a string representation of the path
		 * 
		 * @return A string representation of the path
		 */
		public function toString():String
		{
			var str:String = "AstarPath: ";
			for(var i:Number = 0; i<_path.length; i++)
			{
				str += Object(_path[i]).toString();
			}
			return str;
		}
	}
}
