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

package totem.pathfinder.astar.basic2d.analyzers  
{
	import totem.pathfinder.astar.basic2d.IPositionTile;
	import totem.pathfinder.astar.basic2d.IWalkableTile;
	import totem.pathfinder.astar.basic2d.Map;
	import totem.pathfinder.astar.core.Analyzer;
	import totem.pathfinder.astar.core.IAstarTile;
	import totem.pathfinder.astar.core.PathRequest;

	import flash.geom.Point;

	/**
	 * The SmartClippingAnalyzer allows the path to go diagonal, but only if the adjecent horizontal and vertical tiles are free.
	 * If the path would go 'right + up', both 'right' and 'up' should be walkable
	 * @author Jeroen
	 */
	public class SmartClippingAnalyzer extends Analyzer 
	{
		public function SmartClippingAnalyzer()
		{
			super();
		}
		override protected function analyze(mainTile : IAstarTile, allNeighbours:Vector.<IAstarTile>, neighboursLeft : Vector.<IAstarTile>, req:PathRequest) : Vector.<IAstarTile>
		{
			var main : IPositionTile = mainTile as IPositionTile;
			var mainPos : Point = main.getPosition();
			var newLeft:Vector.<IAstarTile> = new Vector.<IAstarTile>();
			for(var i:Number = 0; i<neighboursLeft.length; i++)
			{
				var currentTile : IPositionTile = neighboursLeft[i] as IPositionTile;
				var currentPos:Point = currentTile.getPosition();
				var tile:IWalkableTile;
				var tile2:IWalkableTile;
				
				var map:Map = req.getMap() as Map;
				
				if(currentPos.x == mainPos.x || currentPos.y == mainPos.y) newLeft.push(currentTile);
				else
				{
					if(currentPos.x < mainPos.x)
					{
						if(currentPos.y < mainPos.y)
						{
							tile = IWalkableTile(map.getTileAt(new Point(mainPos.x - 1, mainPos.y)));
							tile2 = IWalkableTile(map.getTileAt(new Point(mainPos.x, mainPos.y - 1)));
							if(tile.getWalkable() && tile2.getWalkable()) newLeft.push(currentTile);
						}
						else
						{
							tile = IWalkableTile(map.getTileAt(new Point(mainPos.x - 1, mainPos.y)));
							tile2 = IWalkableTile(map.getTileAt(new Point(mainPos.x, mainPos.y + 1)));
							if(tile.getWalkable() && tile2.getWalkable()) newLeft.push(currentTile);
						}
					}
					else
					{
						if(currentPos.y < mainPos.y)
						{
							tile = IWalkableTile(map.getTileAt(new Point(mainPos.x + 1, mainPos.y)));
							tile2 = IWalkableTile(map.getTileAt(new Point(mainPos.x, mainPos.y - 1)));
							if(tile.getWalkable() && tile2.getWalkable()) newLeft.push(currentTile);
						}
						else
						{
							tile = IWalkableTile(map.getTileAt(new Point(mainPos.x + 1, mainPos.y)));
							tile2 = IWalkableTile(map.getTileAt(new Point(mainPos.x, mainPos.y + 1)));
							if(tile.getWalkable() && tile2.getWalkable()) newLeft.push(currentTile);
						}
					}
				}
				
				if(currentTile.getPosition().x == main.getPosition().x || currentTile.getPosition().y == main.getPosition().y) newLeft.push(currentTile);
			}
			return newLeft;
		}
	}
}
