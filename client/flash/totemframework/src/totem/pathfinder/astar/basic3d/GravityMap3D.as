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
	import totem.pathfinder.astar.core.IAstarTile;
	import totem.pathfinder.astar.basic2d.IPositionTile;

	import flash.geom.Point;

	/**
	 * A simple Map implementation for the IMap interface
	 * @author Jeroen Beckers
	 */
	public class GravityMap3D extends Map3D
	{
		private var _width : int;
		private var _height : int;
		private var _length : int;

		
		/**
		 * Creates a new GravityMap object with the specified width en height
		 * 
		 * @param width The width of the map
		 * @param height The height of the map
		 */
		public function GravityMap3D(width:int, length:int, height:int)
		{
			_width = width;
			_height = height;
			_length = length;
			
			super(width, length, height);
			
			
		}
		
		/**
		 * Returns a list of IPositionTiles at the given (x,y) location. All the tiles in the specified column are returned
		 * 
		 * @parem position	The column's location. Only x and y are used
		 * 
		 * @return A vector list concisting of all the IAstarTiles in the given column
		 */
		public function getTilesInColumn(p:Point):Vector.<IAstarTile>
		{
			var ar:Vector.<IAstarTile> = new Vector.<IAstarTile>();
			var tile:IPositionTile;
			for(var i:int = 0; i<_height; i++)
			{
				tile = this.getTileAt(new Point3D(p.x, p.y, i));
				trace("Getting tile: " + new Point3D(p.x, p.y, i).toString(), tile);
				if(tile != null) ar.push(tile);
			}
			
			return ar;
		}
		
		
	
	
		
		/**
		 * Returns a list with the neighbours of the given tile.
		 * 
		 * @param position The position of the tile to get the neighbours of
		 * 
		 * @return A list containing all the neighbouring tiles
		 */
		override public function getNeighbours(tile : IAstarTile) : Vector.<IAstarTile>
		{
			var pos3D:Point3D = Point3D((tile as IPositionTile).getPosition());
			
			var neighbours:Vector.<IAstarTile> = new Vector.<IAstarTile>();
			if(this.isValidPosition(new Point3D(pos3D.x + 1, pos3D.y, 0))) neighbours = neighbours.concat(getTilesInColumn(new Point(pos3D.x + 1, pos3D.y)));
			if(this.isValidPosition(new Point3D(pos3D.x - 1, pos3D.y, 0))) neighbours = neighbours.concat(getTilesInColumn(new Point(pos3D.x - 1, pos3D.y)));
			if(this.isValidPosition(new Point3D(pos3D.x, pos3D.y + 1, 0))) neighbours = neighbours.concat(getTilesInColumn(new Point(pos3D.x, pos3D.y + 1)));
			if(this.isValidPosition(new Point3D(pos3D.x, pos3D.y - 1, 0))) neighbours = neighbours.concat(getTilesInColumn(new Point(pos3D.x, pos3D.y - 1)));
			
			return neighbours;
		}
		
		
		/**
		 * Returns the distance multiplier for the given two tiles. For a this 3D Map, the Eucledean distance is used 
		 * 
		 * 
		 * @param from 	The first point
		 * @param to	The second point
		 * 
		 * @return The multiplier to be used for setting the correct cost to go from the first tile to the second
		 */
		override public function getDistance(f : IAstarTile, t : IAstarTile) : Number
		{
			var start3D:Point3D = (f as IPositionTile).getPosition() as Point3D;
			var end3D:Point3D = (t as IPositionTile).getPosition() as Point3D;
			var xdiff:Number = end3D.x - start3D.x;
			var ydiff:Number = end3D.y - start3D.y;
			var zdiff:Number = end3D.z - start3D.z;
			
			return Math.sqrt(xdiff * xdiff + ydiff * ydiff + zdiff * zdiff );
		}
		
	}
}
