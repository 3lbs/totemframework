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
	import totem.pathfinder.astar.basic2d.IWalkableTile;
	import totem.pathfinder.astar.core.Analyzer;
	import totem.pathfinder.astar.core.IAstarTile;
	import totem.pathfinder.astar.core.PathRequest;

	/**
	 * The OccupationAnalyzer eliminates tiles on which there isn't enough room to walk upon
	 * @author Jeroen
	 */
	public class OccupationAnalyzer extends Analyzer {
		
		
		private var max:Number;
		private var weight:Number;
		
		
		/**
		 * Creates a new OccupationAnalyzer
		 */
		public function OccupationAnalyzer(max:Number, weight:Number) {
			this.weight = weight;
			this.max = max;
			super();
		}
		
		
		override public function analyzeTile(tile: IAstarTile, req:PathRequest):Boolean
		{
			return (tile as IWalkableTile).getWalkable();	
		}
		override protected function analyze(mainTile : IAstarTile, allNeighbours:Vector.<IAstarTile>, neighboursLeft : Vector.<IAstarTile>, req:PathRequest) : Vector.<IAstarTile>
		{
			var newLeft:Vector.<IAstarTile> = new Vector.<IAstarTile>();
			for(var i:Number = 0; i<neighboursLeft.length; i++)
			{
				var currentTile : IOccupationTile = neighboursLeft[i] as IOccupationTile;
				if(currentTile.getOccupation() + this.weight <= max) newLeft.push(currentTile);
			}
			return newLeft;
		}
		
		
		/**
		 * Sets the maximum occupation
		 * 
		 * @param max The maximum occupation
		 */
		public function setMax(max:Number):void
		{
			this.max = max;
		}
		
		/**
		 * Sets the height of the object for which the path is searched
		 * 
		 * @param weight The weight of the object for which the path is searched
		 */
		public function setWeight(weight:Number):void
		{
			this.weight = weight;
		}
	}
}