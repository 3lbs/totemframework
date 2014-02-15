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
//   3lbs Copyright 2014 
//   For more information see http://www.3lbs.com 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

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

	import totem.pathfinder.astar.basic2d.IPositionTile;

	/**
	 * The AstarPath defines the path that is found by the Astar class.
	 *
	 * @author Jeroen Beckers
	 */
	public class AstarPath
	{

		private var _cost : Number;

		/**
		 * A list containing the path
		 */
		private var _path : Vector.<IAstarTile>;

		private var _simplifiedPath : Vector.<IAstarTile>;

		/**
		 * Creates a new AstarPath instance.
		 *
		 * @param cost		The total cost of this path
		 * @param path		The list of IAstarTiles making up the path
		 */

		public function AstarPath( cost : Number = 0, path : Vector.<IAstarTile> = null )
		{
			_path = path;

			if ( _path == null )
				_path = new Vector.<IAstarTile>();

			_cost = cost;
		}

		/**
		 * Gets the cost of this AstarPath
		 */
		public function get cost() : Number
		{
			return _cost;
		}

		/**
		 * Returns a list representation of the path
		 *
		 * @return A list containing the path
		 */
		public function get path() : Vector.<IAstarTile>
		{
			return _path.slice();
		}

		public function simplify() : Vector.<IAstarTile>
		{
			if ( _simplifiedPath )
				return _simplifiedPath;

			_simplifiedPath = _path.concat();

			var i : int;

			// Simplify the path by removing middle points in lines that have the same angle
			// var pl:int = points.length;
			// TODO: better understood closed loops
			var tileA : IPositionTile;
			var tileB : IPositionTile;
			var tileC : IPositionTile;

			for ( i = 1; i < _simplifiedPath.length - 1; i++ )
			{
				tileA = _simplifiedPath[i] as IPositionTile;
				tileB = _simplifiedPath[i-1] as IPositionTile;
				tileC = _simplifiedPath[i+1] as IPositionTile;
				
				if ( tileA.getPosition().equals( tileB.getPosition()) || Math.atan2( tileA.getPosition().y - tileB.getPosition().y, tileA.getPosition().x - tileB.getPosition().x ) == Math.atan2( tileC.getPosition().y - tileA.getPosition().y, tileC.getPosition().x - tileA.getPosition().x ))
				{
					// Same point or same angle
					_simplifiedPath.splice( i, 1 );
					i--;
				}
			}

			return _simplifiedPath;
		}

		/**
		 * Returns a string representation of the path
		 *
		 * @return A string representation of the path
		 */
		public function toString() : String
		{
			var str : String = "AstarPath: ";

			for ( var i : Number = 0; i < _path.length; i++ )
			{
				str += Object( _path[ i ]).toString();
			}
			return str;
		}
	}
}
