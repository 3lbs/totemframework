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
	import totem.pathfinder.astar.core.Analyzer;
	import totem.pathfinder.astar.core.IAstarTile;
	import totem.pathfinder.astar.core.PathRequest;

	/**
	 * The FullClippingAnalyzer allows the path to go horizontal and vertical, but not diagonal.
	 * @author Jeroen
	 */
	public class FullClippingAnalyzer extends Analyzer 
	{
		/**
		 * Creates a new FullClippingAnalyzer
		 */
		public function FullClippingAnalyzer() {
			super();
		}
		
		override protected function analyze(mainTile : IAstarTile, allNeighbours:Vector.<IAstarTile>, neighboursLeft : Vector.<IAstarTile>, req:PathRequest) : Vector.<IAstarTile>
		{
			var main : IPositionTile = mainTile as IPositionTile;
			var newLeft:Vector.<IAstarTile> = new Vector.<IAstarTile>();
			for(var i:Number = 0; i<neighboursLeft.length; i++)
			{
				var currentTile : IPositionTile = neighboursLeft[i] as IPositionTile;
				
				//only allow horizontal and vertical movement
				if(currentTile.getPosition().x == main.getPosition().x || currentTile.getPosition().y == main.getPosition().y) newLeft.push(currentTile);
			}
			return newLeft;
		}
	}
}
