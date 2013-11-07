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
	 * The Analyzer class describes searching constraints for the Astar class.
	 * 
	 * Analyzers can be linked together using the Astar.addAnalyzer. You can create your own Analyzer by extending the Analyzer class
	 * and overriding the Analyzer.analyzeTile and Analyzer.analyze methods.
	 * 
	 * @author Jeroen Beckers
	 */
	public class Analyzer 
	{
		protected var _subAnalyzer:Analyzer;
		
		public function Analyzer()
		{
		}

		final protected function getSubAnalyzer():Analyzer
		{
			return _subAnalyzer;
		}
		
		/**
		 * Used to validate a single tile. This method is used to see if the start/end tile is a valid tile.
		 * 
		 * @param 	mainTile	The tile that is being analyzed
		 * @param 	req			The path request that is currently being executed
		 * 
		 * @return	A boolean indicating whether or not the tile is valid
		 */
		public function analyzeTile(mainTile : IAstarTile, req:PathRequest):Boolean
		{
			return true;
		}
		
		/**
		 * Analyzes if a single tile is valid. Used for start and end point
		 * 
		 * @param mainTile	The tile that is being analyzed
		 * @param req		The path request that is currently being executed
		 * 
		 * @return A boolean indicating whether or not the tile is valid
		 */
		final public function subAnalyzeTile(mainTile : IAstarTile, req:PathRequest) : Boolean
		{
			//if it doesnt pass this test, return false
			if(!this.analyzeTile(mainTile, req)) return false;
			//otherwise, return the subAnalyzeTile of the _subAnalyzer, or true if there isn't one
			else return (_subAnalyzer == null? true : _subAnalyzer.subAnalyzeTile(mainTile, req));
		}
		
		
		/**
		 * Chains the given subAnalyzer to this analyzer
		 * 
		 * @param subAnalyzer The subAnalyzer to chain to this analyzer
		 */
		final internal function setSubAnalyzer(subAnalyzer : Analyzer) : void
		{
			_subAnalyzer = subAnalyzer;
		}
		
		/**
		 * Eliminates neighbours from the given array and returns the neighbours that were valid.
		 * 
		 * 
		 * @param mainTile			The tile who's neighbours are passed
		 * @param allNeighbours  	A list consisting of all the neighbours, including those that were removed by other analyzers
		 * @param neighboursLeft	A list consisting of all the neighbours that have passed all the other analyzers. This is the list that should be modified and returned.
		 * @param request			The PathRequest that is currently being executed
		 * 
		 * @return					A list consisting of all the neighbours that passed this analyzer
		 */
		protected function analyze(mainTile : IAstarTile, allNeighbours:Vector.<IAstarTile>, neighboursLeft : Vector.<IAstarTile>, request:PathRequest) : Vector.<IAstarTile>
		{
			return neighboursLeft;
		}
		
		
		/**
		 * Manages the propper chaining of the subanalyzers. Backups are created, the DataTiles are converted to their containing tile, analyzed and converted back to DataTiles.
		 * 
		 * @param mainTile			The tile who's neighbours are being analyzed
		 * @param allNeighbours		A list containing all the neighbours of the mainTile
		 * @param neighboursLeft	A list containing the neighbours of the mainTile that have passed the other analyzers up untill now
		 * @param req				The PathRequest that is currently being executed
		 * 
		 * @return					A list with the tiles that have passed this analyzer
		 */
		final internal function subAnalyze(mainTile : DataTile, allNeighbours:Vector.<IAstarTile>, neighboursLeft : Vector.<IAstarTile>, req:PathRequest):Vector.<IAstarTile>
		{
			// Create backup of allNeighbours array
			var neighboursBackup:Vector.<IAstarTile> = new Vector.<IAstarTile>();
			for(var i:Number = 0; i<allNeighbours.length; i++)
			{
				neighboursBackup.push(allNeighbours[i]);	
			}
			
			// Create backup of neighboursLeft array
			var neighboursLeftBackup:Vector.<IAstarTile> = new Vector.<IAstarTile>();
			for(i = 0; i<neighboursLeft.length; i++)
			{
				neighboursLeftBackup.push(neighboursLeft[i]);	
			}
			
			var newNeighboursLeft:Vector.<IAstarTile> = this.analyze(mainTile.getTarget(), allNeighbours, neighboursLeft, req);
			if(newNeighboursLeft == null) newNeighboursLeft = neighboursLeftBackup;
			
			
			//if it's the base analyzer, return the neighbours & work our way up the chain
			if(this._subAnalyzer == null) 
			{
				return newNeighboursLeft;
			}
			else
			{
				//if not; send them deeper
				return this._subAnalyzer.subAnalyze(mainTile, neighboursBackup, newNeighboursLeft, req);
			}
				
		}
		
		
		/**
		 * Removes an analyzer from the chain. If this isn't the analyzer that has to be removed, it is passed along the chain.
		 * 
		 * @return Analyzer		The sub analyzer of the analyzer that is removed. This is used to maintain the chain property
		 */
		final internal function removeAnalyzer(toRemove:Analyzer):Analyzer
		{
			//if it's this analyzer that has to be removed, return this analyzer's sub analyzer
			if(toRemove == this)
			{
				return _subAnalyzer;	
			}
			else
			{
				//if not, keep this analyzer in the analyzer chain and try to remove the sub analyzer
				this.setSubAnalyzer(this._subAnalyzer.removeAnalyzer(toRemove));
				return this;	
			}
			
		}
	}
}

