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

package totem.pathfinder.astar.basic3d 
{
	import totem.pathfinder.astar.core.PathRequest;
	import totem.pathfinder.astar.core.IAstarTile;
	import totem.pathfinder.astar.basic2d.IPositionTile;
	import totem.pathfinder.astar.core.IMap;

	import flash.geom.Point;

	/**
	 * A simple Map implementation for the IMap interface
	 * @author Jeroen Beckers
	 */
	public class Map3D implements IMap
	{
		
		private static const SQRT2:Number = 1.4;
		private static const SQRT3:Number = 1.7;
		
		private var _map : Array;
		private var _width : int;
		private var _height : int;
		private var _length : int;
		
		private var _defaultCost:int;

		private var _standardCost:Number = 1;
		
		/**
		 * Creates a new Map object with the specified width en height
		 * 
		 * @param width The width of the map
		 * @param height The height of the map
		 */
		public function Map3D(width:int, length:int, height:int, defaultCost:int = 1)
		{
			_width = width;
			_height = height;
			_length = length;
			
			_defaultCost = defaultCost;
			
			_map = new Array(_width * _length * _height);
			
			
		}
		
		
		/**
		 * Sets the standard cost for this map.
		 */
		public function set standardCost(p:Number):void
		{
			_standardCost = p;
		}
		
		/**
		 * Gets the standard cost for this map
		 */
		public function get standardCost():Number
		{
			return _standardCost;
		}
		
		
		/**
		 * Returns the IPositionTile at the given location
		 * 
		 * @param position	The point specifing the location for the tile
		 * @return IPositionTile at the given location
		 */
		
		public function getTileAt(position : Point) : IPositionTile
		{
			if(isValidPosition(position))
			{
				return _map[calcIndex(position)];
			}
			return null;
		}
		
		/**
		 * Sets the given tile at the given location
		 * 
		 * @param tile		The tile to place in the map
		 */
		public function setTile(tile : IPositionTile) : void
		{
			var pos:Point = tile.getPosition();
			if(isValidPosition(pos))
			{
				_map[calcIndex(pos)] = tile;
			}
		}
		
		private function calcIndex(pt:Point):int
		{
			var p3D:Point3D = Point3D(pt);
			return p3D.x * _width * _length + p3D.y * _length + p3D.z;
		}
		
		/**
		 * Returns whether or not the given position is located within the map
		 * 
		 * @param position The position to check
		 * 
		 * @return A boolean indicating if the given position is located within the map
		 */
		protected function isValidPosition(position:Point):Boolean
		{
			var pos3D:Point3D = Point3D(position);
			
			if(_map == null) return false;
			if(pos3D.x < 0 || pos3D.y < 0 || pos3D.z < 0) return false;
			
			return pos3D.x < this._width && pos3D.y < this._length && pos3D.z < this._height;
		}
		
		/**
		 * Returns a list with the neighbours of the given tile.
		 * 
		 * @param position The position of the tile to get the neighbours of
		 * 
		 * @return A list containing all the neighbouring tiles
		 */
		public function getNeighbours(tile : IAstarTile) : Vector.<IAstarTile>
		{
			var pos3D:Point3D = Point3D((tile as IPositionTile).getPosition());
			
			var x:Number = pos3D.x;
			var y:Number = pos3D.y;
			var z:Number = pos3D.z;
			
			var xp:int = 1 + x;
			var xm:int = (-1) + x;
			
			var yp:int = 1 + y;
			var ym:int = (-1) + y;
			
			var zp:int = 1 + z;
			var zm:int = (-1) + z;
			
			
			var neighbours:Vector.<IAstarTile> = new Vector.<IAstarTile>();
			
			//current level
			if(this.isValidPosition(new Point3D(xm, ym, z))) neighbours.push(this.getTileAt(new Point3D(xm, ym, z)));
			if(this.isValidPosition(new Point3D(xm, y, z))) neighbours.push(this.getTileAt(new Point3D(xm, y, z)));
			if(this.isValidPosition(new Point3D(xm, yp, z))) neighbours.push(this.getTileAt(new Point3D(xm, yp, z)));
			if(this.isValidPosition(new Point3D(x, ym, z))) neighbours.push(this.getTileAt(new Point3D(x, ym, z)));
			if(this.isValidPosition(new Point3D(x, yp, z))) neighbours.push(this.getTileAt(new Point3D(x, yp, z)));
			if(this.isValidPosition(new Point3D(xp, ym, z))) neighbours.push(this.getTileAt(new Point3D(xp, ym, z)));
			if(this.isValidPosition(new Point3D(xp, y, z))) neighbours.push(this.getTileAt(new Point3D(xp, y, z)));
			if(this.isValidPosition(new Point3D(xp, yp, z))) neighbours.push(this.getTileAt(new Point3D(xp, yp, z)));
			
			//one level down
			if(z > 0)
			{
				if(this.isValidPosition(new Point3D(xm, ym, zm))) neighbours.push(this.getTileAt(new Point3D(xm, ym, zm)));
				if(this.isValidPosition(new Point3D(xm, y, zm))) neighbours.push(this.getTileAt(new Point3D(xm, y, zm)));
				if(this.isValidPosition(new Point3D(xm, yp, zm))) neighbours.push(this.getTileAt(new Point3D(xm, yp, zm)));
				if(this.isValidPosition(new Point3D(x, ym, zm))) neighbours.push(this.getTileAt(new Point3D(x, ym, zm)));
				if(this.isValidPosition(new Point3D(x, yp, zm))) neighbours.push(this.getTileAt(new Point3D(x, yp, zm)));
				if(this.isValidPosition(new Point3D(xp, ym, zm))) neighbours.push(this.getTileAt(new Point3D(xp, ym, zm)));
				if(this.isValidPosition(new Point3D(xp, y, zm))) neighbours.push(this.getTileAt(new Point3D(xp, y, zm)));
				if(this.isValidPosition(new Point3D(xp, yp, zm))) neighbours.push(this.getTileAt(new Point3D(xp, yp, zm)));

				//directly below the start
				if(this.isValidPosition(new Point3D(x, y, zm))) neighbours.push(this.getTileAt(new Point3D(x, y, zm)));
				
			}
			
			//one level up
			if(zp < this._height) 
			{
				if(this.isValidPosition(new Point3D(xm, ym, zp))) neighbours.push(this.getTileAt(new Point3D(xm, ym, zp)));
				if(this.isValidPosition(new Point3D(xm, y, zp))) neighbours.push(this.getTileAt(new Point3D(xm, y, zp)));
				if(this.isValidPosition(new Point3D(xm, yp, zp))) neighbours.push(this.getTileAt(new Point3D(xm, yp, zp)));
				if(this.isValidPosition(new Point3D(x, ym, zp))) neighbours.push(this.getTileAt(new Point3D(x, ym, zp)));
				if(this.isValidPosition(new Point3D(x, yp, zp))) neighbours.push(this.getTileAt(new Point3D(x, yp, zp)));
				if(this.isValidPosition(new Point3D(xp, ym, zp))) neighbours.push(this.getTileAt(new Point3D(xp, ym, zp)));
				if(this.isValidPosition(new Point3D(xp, y, zp))) neighbours.push(this.getTileAt(new Point3D(xp, y, zp)));
				if(this.isValidPosition(new Point3D(xp, yp, zp))) neighbours.push(this.getTileAt(new Point3D(xp, yp, zp)));

				//directly above the start
				if(this.isValidPosition(new Point3D(x, y, zp))) neighbours.push(this.getTileAt(new Point3D(x, y, zp)));
			}
			
					
			return neighbours;
		}
		
		/**
		 * Returns the distance multiplier for the given two tiles. It can return the following:
		 * 
		 * SQRT(2) 	- If the tiles have only one axis in common
		 * SQRT(3) 	- If the tiles have no axis in common
		 * 1		- If the tiles have two axis in common
		 * 
		 * @param from 	The first point
		 * @param to	The second point
		 * 
		 * @return The multiplier to be used for setting the correct cost to go from the first tile to the second
		 */
		
		public function getDistance(f : IAstarTile, t : IAstarTile) : Number
		{
			var from:Point3D = Point3D((f as IPositionTile).getPosition());
			var to:Point3D = Point3D((t as IPositionTile).getPosition());
			
			if((from.x == to.x && from.y == to.y) || (from.z == to.z && from.y == to.y) || (from.y == to.y && from.z == to.z))
			{
				return 1;
			}
			else if(from.x == to.x || from.y == to.y || from.z == to.z)
			{
				return SQRT2;
			}
			return SQRT3;
		}
		
		public function getHeuristic(tile:IAstarTile, req:PathRequest):Number
		{
			var start3D:Point3D = Point3D((tile as IPositionTile).getPosition());
			var end3D:Point3D = Point3D((req.getEnd() as IPositionTile).getPosition());
			
			return Math.abs(end3D.x - start3D.x) * _standardCost + Math.abs(end3D.y - start3D.y) * _standardCost + Math.abs(end3D.z - start3D.z) * _standardCost;
		}
	}
}
