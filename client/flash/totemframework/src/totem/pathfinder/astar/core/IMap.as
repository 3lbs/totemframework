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

/**
 * Defines an interface for maps to be used with the Astar class
 */

package totem.pathfinder.astar.core
{

	/**
	 * @author Jeroen Beckers
	 */
	public interface IMap 
	{
		/**
		 * Returns a Vector list of IAstarTiles that are neighbours of the given IAstarTile
		 */
		function getNeighbours(tile : IAstarTile) : Vector.<IAstarTile>;
		
		/**
		 * Returns the heuristic for the given tile and the given pathrequest.
		 */
		function getHeuristic(tile:IAstarTile, req:PathRequest):Number;
		
		/**
		 * Returns the distance for the given two tiles.
		 */
		function getDistance(start:IAstarTile, end:IAstarTile):Number;
	}
}
