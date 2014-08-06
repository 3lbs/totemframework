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
Copyright (c) 2011 Jeroen Beckers - http://www.dauntless.be

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

/*
*  	+-----------------------------------------------------------+
*	|			              _             					|
* 	|			    /\       | |            					|
* 	|			   /  \   ___| |_ __ _ _ __ 					|
* 	|			  / /\ \ / __| __/ _` | '__|					|
* 	|			 / ____ \\__ \ || (_| | |   					|
* 	|			/_/    \_\___/\__\__,_|_|   v1.3				|
* 	|															|
* 	+-----------------------------------------------------------+
* 	| 	Implementation by Jeroen Beckers a.k.a. Dauntless		|
* 	|	Website: http://www.dauntless.be/astar					|
* 	|	Contact: info@dauntless.be								|
* 	+-----------------------------------------------------------+
* 	|	Change log (dd/mm/yyyy):								|
* 	|		05/08/2008: 1.0 beta								|
*   |		09/11/2009: 1.1 									|
*	|		19/07/2010: 1.2										|
*	|		04/10/2011: 1.3										|
*	|		09/06/2012: 1.3.1									|
* 	+-----------------------------------------------------------+
* 	|	Do you want a feature, or do you know ways of 			|
* 	|	making the algorithm faster? Contact me!				|
* 	+-----------------------------------------------------------+
*/

/*
Update log:
1.0
---
Initial release


1.1
---
Added toArray to AstarPath

1.2
---
Fixed memory leak thanks to Mario Benedek

1.3
---
Added the ability to add analyzers to a pathrequest
Added Astar.NORMAL_CHECK and Astar.NO_CHECK
Added Astar.safety, to be used with the new constants
Added static map option


Removed Astar.DIAGONAL_FACTOR. Is now only used in the IMap implementations
Removed Astar.getStandardCost and Astar.setStandardCost. That logic has been moved to the IMap implementations
Removed start != end check
Removed Iterator for path


Changed Astar.setIterations and Astar.setIntervalTime to Astar.iterations and Astar.intervalTime
Rearanged packages & classes
Moved BinaryHeap & SortedQueue to Astar.as

1.3.1
-----
Fixed indexing bug in basic2d.Map

 */

package totem.pathfinder.astar.core
{

	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;

	import totem.core.Destroyable;
	import totem.monitors.promise.IPromise;

	/**
	 * The main search algorithm and core class of this Astar library.
	 * @author Jeroen Beckers
	 */
	public class Astar extends Destroyable
	{

		/**
		 * If Astar.safeMode is set to NORMAL_CHECK (default), the following will be tested:
		 *
		 * - The end tile has to be a valid tile according to the analyzers (Analyzer.analyzeTile)
		 *
		 * Note that only the end tile is checked. It is assumed that you start from a valid position.
		 */
		public static const NORMAL_CHECK : String = "normalCheck";

		/**
		 * If Astar.safeMode is set to NO_CHECK, nothing will be checked for at the start of a new search
		 */
		public static const NO_CHECK : String = "noCheck";

		/**
		 * The list of analyzers, identical for all PathRequests
		 */
		private var _analyzers : Analyzer;

		/**
		 * Indicates whether or not to cache found paths
		 */
		private var _cache : Boolean;

		/**
		 * Contains all the cached paths
		 */
		private var _cachedPaths : Dictionary = new Dictionary();

		/**
		 * The PathRequest that is being processed
		 */
		private var _currentRequest : PathRequest;

		/**
		 * Used for mapping the DataTiles to the tiles given by the user
		 */
		private var _dataTiles : Dictionary;

		/**
		 * The end tile
		 */
		private var _end : DataTile;

		/**
		 * The heap stores all the tiles in the open list
		 */
		private var _heap : BinaryHeap;

		/**
		 * The interval that is used to schedule iteration sequences, expressed in milliseconds. (Default = 100)
		 */
		private var _intervalTime : Number = 100;

		/**
	   * Indicates whether the there is being looked for a path or not
			 */
		private var _isSearching : Boolean = false;

		/**
		 * The number of iterations to do within one timespan. For small maps, this can be equal to the total size (=number of tiles) of your maps.
		 * For bigger maps, you can use a lower value. (Default = 1000)
		 */
		private var _iterations : Number = 1000;

		/**
		 * Indicates whether or not a path has been found.
		 */
		private var _pathFound : Boolean;

		/**
		 * A queue containing all the paths that have to be found.
		 */
		private var _queue : SortedQueue;

		/**
		 * The list of requestAnalyzers, possibly unique for every PathRequest
		 */
		private var _requestAnalyzers : Analyzer;

		/**
		 * Indicates whether or not to check all prerequisites before searching for a path
		 */
		private var _safeMode : String = NORMAL_CHECK;

		/**
		 * The source map
		 */
		private var _sourceMap : IMap;

		/**
		 * The start tile
		 */
		private var _start : DataTile;

		/**
		 * Used for cycles
		 */
		private var _timer : Timer;

		/**
		 * Creates a new Astar instance
		 *
		 * @param cache		If set to true, Astar will remember paths that have been found and it will returned cached paths in stead of searching for the path again. Set to true if your map always stays the same and all your PathRequests will have the same conditions. (Default = false)
		 */
		public function Astar( cache : Boolean = false )
		{
			_cache = cache;

			_queue = new SortedQueue();

			//initialize Analyzer list
			_analyzers = new Analyzer();
		}

		/**
		 * Add an analyzer to the analyzer chain. Analyzers added to the Astar instance will be checked before analyzers added to the PathRequest
		 *
		 * @param analyzer	The analyzer to add to the analyzer chain
		 */
		public function addAnalyzer( analyzer : Analyzer ) : void
		{
			analyzer.setSubAnalyzer( _analyzers );
			this._analyzers = analyzer;
		}

		/**
		 * Clears the cached paths
		 */
		public function clearCache() : void
		{
			_cachedPaths = new Dictionary();
		}

		/**
		 * Enqueues the given PathRequest or executes the request if the queue is empty. When a path is found, an AstarEvent.PATH_FOUND event is dispatched. If caching is set to true and a cached path is found, the PathRequest will not be added to the queue and the cached path will be dispatched immediately.
		 * @param	item	The PathRequest containing the search info
		 */
		public function getPath( item : PathRequest ) : IPromise
		{
			//check if startpoint is valid, endpoint is valid, etc. Will throw AstarError on error
			if ( _safeMode == NORMAL_CHECK )
			{
				checkNormal( item.getEnd(), item.getAnalyzers(), _analyzers, item );
			}

			//if caching is on and a path has already been found, dispatch that path

			if ( _cache )
			{
				var path : AstarPath = getCachedPath( item );

				if ( path != null )
				{
					//this.dispatchEvent(new AstarEvent(AstarEvent.PATH_FOUND, path, item));

					item.resolve( path );
					return item;
				}
			}

			//add to the queue
			_queue.enqueue( item );

			//if not already searching, start searching
			if ( !_isSearching )
				searchForNextPath();

			return item;
		}

		/**
		 * Sets the time between two consecutive iteration series.
		 *
		 * @param	intervalTime	The time between two consecutive iteration series
		 */
		public function set intervalTime( intervalTime : Number ) : void
		{
			_intervalTime = intervalTime;
		}

		/**
		 * Sets the number of iterations done within 1 timespan.
		 * @param	iterations	The number of iterations
		 */
		public function set iterations( iterations : Number ) : void
		{
			_iterations = iterations;
		}

		public function reset() : void
		{
			clearCache();

			this._timer.stop();
			this._timer.reset();

			this._isSearching = false;
			
			if ( _currentRequest )
				_currentRequest.dispose();

			this._currentRequest = null;
			this._start = null;
			this._end = null;

			this._requestAnalyzers = null;

			this._sourceMap = null;

			_heap = null;

			_queue.dispose();

			_queue = new SortedQueue();

		}

		/**
		 * Returns the current safety level.
		 */
		public function get safety() : String
		{
			return _safeMode;
		}

		///////////////////////////////////////////////////////////////////////////////////////////
		// PUBLIC METHODS
		///////////////////////////////////////////////////////////////////////////////////////////

		/**
		 * Sets the level of safety. Set this to Astar.NORMAL_CHECK, Astar.NO_CHECK. See constants for more information.
		 *
		 * The default value is Astar.NORMAL_CHECK;
		 */
		public function set safety( p : String ) : void
		{
			if ( p == NO_CHECK || p == NORMAL_CHECK )
			{
				_safeMode = p;
			}
		}

		/**
		 * Used to cast error
		 */
		private function abort( msg : String ) : void
		{
			throw new AstarError( msg );
		}

		/**
		 * Builds the path starting from the end and working its way back.
		 *
		 * @return path The path from start to end.
		 */
		private function buildPath() : AstarPath
		{

			var tile : DataTile = _end;

			var pathArray : Vector.<IAstarTile> = new Vector.<IAstarTile>();

			var cost : Number = tile.getF();

			//work back
			while ( tile != _start )
			{
				pathArray.splice( 0, 0, tile.getTarget());
				tile = tile.getParent();
			}

			//add start
			pathArray.splice( 0, 0, tile.getTarget());

			return new AstarPath( cost, pathArray );
			;
		}

		private function checkNormal( end : IAstarTile, an : Analyzer, an2 : Analyzer, req : PathRequest ) : void
		{
			if ( !an.subAnalyzeTile( end, req ) || !an2.subAnalyzeTile( end, req ))
			{
				abort( "The end tile is not a valid tile" );
			}
		}

		/**
		 * Compares two tiles' F values. This method is used as the comparefunction in the binary heap
		 * @param	tile1	The first tile
		 * @param	tile2	The second tile
		 * @return	The difference in F value of tile1 en tile2
		 */
		private function compareFValues( tile1 : DataTile, tile2 : DataTile ) : Number
		{
			return tile1.getF() - tile2.getF();
		}

		private function getCachedPath( req : PathRequest ) : AstarPath
		{
			var paths : Dictionary = _cachedPaths[ req.getStart()];

			if ( paths != null )
			{
				return paths[ req.getEnd()];
			}
			return null;
		}

		/**
		 * Gets the datatile at the given location in the map. It returns null if the location is invalid.
		 * @param	x	x position of the tile
		 * @param	y	y position of the tile
		 * @return		Null if the location is invalid. Otherwise, it returns the tile at the given location
		 */
		private function getDataTile( tile : IAstarTile ) : DataTile
		{
			var searchResult : DataTile = _dataTiles[ tile ];

			if ( searchResult == null )
			{
				//no datatile has been created yet
				searchResult = new DataTile();
				searchResult.setTarget( tile );
				_dataTiles[ tile ] = searchResult;
			}
			return searchResult;
		}

		/**
		 * Returns all the neighbours of the specified tile. Each neighbour is passed through the analyzer chain to see if it is valid
		 *
		 * @param pos The position of the tile to get the neighbours for
		 *
		 * @return 		The neighbours that passed the analyzers
		 */
		private function getNeighbours( dataTile : DataTile ) : Vector.<DataTile>
		{
			var allNeighbours : Vector.<DataTile> = getStandardNeighbours( dataTile );

			var neighboursToPass : Vector.<IAstarTile> = new Vector.<IAstarTile>();

			var nb : DataTile = null;

			var dictionary : Dictionary = new Dictionary();

			//analyzers don't need the data tiles
			dictionary = new Dictionary();

			for ( var i : int = 0; i < allNeighbours.length; i++ )
			{
				// dict[tile] = datatile
				nb = allNeighbours[ i ] as DataTile;
				dictionary[ nb.getTarget()] = nb;
				neighboursToPass.push( nb.getTarget());
			}

			//pass array through to all analyzers: first global analyzers, then request analyzers		
			var analyzedNeighbours : Vector.<IAstarTile> = _analyzers.subAnalyze( dataTile, neighboursToPass, neighboursToPass, _currentRequest );
			analyzedNeighbours = _requestAnalyzers.subAnalyze( dataTile, neighboursToPass, analyzedNeighbours, _currentRequest );

			//turn all tiles back to DataTiles
			var finalNeighbours : Vector.<DataTile> = new Vector.<DataTile>();

			for ( i = 0; i < analyzedNeighbours.length; i++ )
			{
				finalNeighbours.push( dictionary[( analyzedNeighbours[ i ])]);
			}
			return finalNeighbours;
		}

		/**
		 * Returns the standard neighbours of the tile, according to the source map's getNeighbours method.
		 *
		 * @param pos The position for the tile to get the standard neighbours from
		 * @return	A list containing datatile instances representing the neighbour tiles
		 */
		private function getStandardNeighbours( dataTile : DataTile ) : Vector.<DataTile>
		{
			//the map determines which tiles are neighbours of the given tile
			var potNeighbours : Vector.<IAstarTile> = this._sourceMap.getNeighbours( dataTile.getTarget());

			//leave out all the tiles that are already closed
			var neighbours : Vector.<DataTile> = new Vector.<DataTile>();

			var tile : DataTile = null;
			var i : Number = 0;

			for ( i = 0; i < potNeighbours.length; i++ )
			{
				tile = this.getDataTile( potNeighbours[ i ]);

				if ( tile != null && !tile.getClosed())
					neighbours.push( tile );
			}

			return neighbours;
		}

		/**
		 * Inspects the neighbours array of the current tile.
		 * @param	current		The current tile that is being examined
		 * @param	neighbours	The array of neighbour tiles
		 */
		private function inspectNeighbours( current : DataTile, neighbours : Vector.<DataTile> ) : void
		{
			var i : Number = neighbours.length;
			var cN : DataTile = null;

			var newF : Number = 0;
			var pos : Number = 0;

			//loop through the array
			while ( i-- > 0 )
			{
				//not in open array?
				cN = neighbours[ i ] as DataTile;

				if ( !cN.getOpen())
				{
					//add to open-array					
					cN.setDistance( _sourceMap.getDistance( current.getTarget(), cN.getTarget()));
					openTile( cN, current.getG(), current );
				}
				else
				{
					//already in open, check if F via current node is lower	
					newF = cN.calculateUpdateF( current.getG());

					if ( newF < cN.getF())
					{
						pos = this._heap.getPosition( cN );

						cN.setParent( current );
						cN.setDistance( _sourceMap.getDistance( current.getTarget(), cN.getTarget()));
						cN.setG( current.getG());
						this._heap.update_heap( pos );
					}
				}
			}
		}

		/**
		 * Opens a tile. The tile's position is set, it's added to the open list, the G and H are set and the parent is set.
		 * Afterwards, the tile is added to the heap.
		 *
		 * @param pos		The position of the tile
		 * @param g			The G, the total cost from the start up untill this tile
		 * @param parent	The parent of the tile
		 */
		private function openTile( tile : DataTile, g : Number, parent : DataTile ) : void
		{
			tile.setOpen( true );
			tile.setG( g );
			tile.setH( _sourceMap.getHeuristic( tile.getTarget(), _currentRequest ));
			tile.setParent( parent );

			this._heap.add( tile );
		}

		/**
		 * The core is run when the Timer dispatches its TimerEvent.TIMER.
		 */
		private function runCore( e : TimerEvent = null ) : void
		{
			var current : DataTile;

			var neighbours : Vector.<DataTile> = null;

			//while there are items left to inspect
			for ( var i : int = 0; i < _iterations && this._heap.getLength() > 0; i++ )
			{
				//get new item
				current = this._heap.shift();

//				trace("Looking at ", current.getTarget().getPosition());

				//check if destination is reached
				if ( _currentRequest.isTarget( current.getTarget()))
				{
					_pathFound = true;

					//adjust end to the tile we found. This will be different fe in the color simulation
					_end = current;

					break;
				}

				//close current tile
				current.setClosed();

				//get surrounding neighbours
				neighbours = getNeighbours( current );

				//inspect neighbours & act accordingly
				inspectNeighbours( current, neighbours );
			}

			//if the heap is empty and the path hasn't been found, or the path has been found
			if (( _heap.getLength() == 0 && !_pathFound ) || _pathFound )
			{

				var event : AstarEvent;

				if ( !_pathFound )
				{
					//event = new AstarEvent(AstarEvent.PATH_NOT_FOUND, new AstarPath(), _currentRequest);
					_currentRequest.reject( null );
				}
				else
				{
					var path : AstarPath = buildPath();

					//event = new AstarEvent(AstarEvent.PATH_FOUND, path, _currentRequest);

					//store the path if caching is true
					if ( _cache )
					{
						var paths : Dictionary = _cachedPaths[ _currentRequest.getStart()];

						if ( paths == null )
						{
							_cachedPaths[ _currentRequest.getStart()] = paths = new Dictionary();
						}

						paths[ _currentRequest.getEnd()] = path;
					}
					_currentRequest.resolve( path );
				}

				//clear timer
				this._timer.stop();
				this._timer.reset();

				this._isSearching = false;

				//dispatch event
				//this.dispatchEvent(event);	

				//continue searching
				searchForNextPath();
			}
			//path is still being looked for...
		}

		///////////////////////////////////////////////////////////////////////////////////////////
		// PRIVATE METHODS
		///////////////////////////////////////////////////////////////////////////////////////////

		/**
		 * Searches for the next path in the queue
		 */
		private function searchForNextPath() : void
		{
			//if there is no next assignment, stop
			if ( !_queue.hasNext())
				return;

			_dataTiles = new Dictionary();

			//set request, start, end & sourcemap
			this._currentRequest = _queue.getNext();
			this._start = this.getDataTile( this._currentRequest.getStart());
			this._end = this.getDataTile( this._currentRequest.getEnd());

			this._requestAnalyzers = this._currentRequest.getAnalyzers();

			this._sourceMap = this._currentRequest.getMap();

			//set flag
			this._isSearching = true;

			_heap = new BinaryHeap( compareFValues );

			//no path found yet
			_pathFound = false;

			//open the starting tile and add it to the heap
			openTile( _start, 0, null );

			//initiate timer
			_timer = new Timer( _intervalTime );
			_timer.addEventListener( TimerEvent.TIMER, runCore );
			_timer.start();
			runCore();
		}
	}
}

import totem.pathfinder.astar.core.PathRequest;

/**
 * @private
 * @author Jeroen Beckers
 */
class SortedQueue
{
	private var _queue : Array;

	/**
	 * Creates a new SortedQueue
	 */
	public function SortedQueue()
	{
		_queue = new Array();
	}

	public function dispose() : void
	{
		while ( _queue.length )
			PathRequest( _queue.pop()).dispose();
	}

	/**
	 * Adds an item to this queue
	 *
	 * @param item 		The PathRequest to add to this queue
	 */
	public function enqueue( item : PathRequest ) : void
	{
		_queue.push( item );
		_queue.sortOn( "priority", Array.NUMERIC );
	}

	/**
	 * Returns the next PathRequest and deletes it fromt he queue
	 *
	 * @return The next PathRequest
	 */
	public function getNext() : PathRequest
	{
		if ( !hasNext())
			return null;
		var ob : PathRequest = _queue.shift();
		return ob;
	}

	/**
	 * Checks if the queue has another object
	 *
	 * @return 	A boolean indicating if the queue has another object
	 */
	public function hasNext() : Boolean
	{
		return _queue.length > 0;
	}

	/**
	 * Returns the next PathRequest without deleting it from the queue
	 *
	 * @return The next PathRequest
	 */
	public function peek() : PathRequest
	{
		if ( !hasNext())
			return null;
		return _queue[ 0 ];
	}
}

/**
 * @private
 * @author Jeroen Beckers
 */
class BinaryHeap
{
	private var _compare : Function;

	private var _heap : Array;

	public function BinaryHeap( p_compare : Function = null )
	{
		setFunction( p_compare );
	}

	/**
	 * Adds an object to the heap
	 */
	public function add( newObject : * ) : void
	{
		_heap.push( newObject );

		var cp : Number = _heap.length - 1; //cp = current position

		//as long as the item isnt in the first position
		while ( cp != 1 )
		{
			var n : Number = Math.floor( cp / 2 );

			if ( _compare( _heap[ cp ], _heap[ n ]) <= 0 )
			{
				//switch 'm
				var t : * = _heap[ n ];
				_heap[ n ] = _heap[ cp ];
				_heap[ cp ] = t;
				cp = n;
			}
			else
			{
				//destination reached
				break;
			}
		}
	}

	/**
	 * Returns the length of the heap
	 */
	public function getLength() : Number
	{
		return ( _heap.length - 1 );
	}

	/**
	 * Returns the first item in the heap, but it doesn't remove it from the heap
	 */
	public function getLowest() : *
	{
		return _heap[ 1 ];
	}

	public function getPosition( el : * ) : Number
	{
		for ( var i : Number = 1; i < _heap.length; i++ )
		{
			if ( _heap[ i ] == el )
				return i;
		}

		return -1;
	}

	/**
	 * Returns whether the given object is in the heap or not
	 */
	public function hasElement( element : * ) : Boolean
	{
		var i : Number = _heap.length;

		while ( i-- > 0 )
		{
			if ( _heap[ i ] == element )
				return true;
		}
		return false;
	}

	/**
	 * Returns the first item from the heap and removes it from the heap
	 */
	public function shift() : *
	{
		//lowest is stored at the beginning of the heap
		var lowest : * = _heap[ 1 ];

		//length = 2 -> heap is now empty
		if ( _heap.length == 2 )
		{
			_heap.pop();
		}
		else
		{
			//get last item and store it in 1st place
			_heap[ 1 ] = _heap.pop();
		}

		crawlDown( 1 );
		return lowest;
	}

	/**
	 * Returns an array representing the binary heap
	 */
	public function toArray() : Array
	{
		return _heap;
	}

	public function update_heap( start : Number ) : void
	{
		//move up or down?
		if ( start > 1 && _compare( _heap[ start ], _heap[ Math.floor( start / 2 )]) <= 0 )
		{
			//up!
			crawlUp( start );
		}
		else
		{
			//down	
			crawlDown( start );
		}
	}

	/**
	 * Moves an item down in the heap
	 */
	private function crawlDown( start : Number ) : void
	{
		var cp : Number = start;
		var np : Number;

		while ( true )
		{
			np = cp;
			var dnp : Number = 2 * np; //double np

			if ( dnp - ( -1 ) <= _heap.length - 1 )
			{
				if ( _compare( _heap[ np ], _heap[ dnp ]) >= 0 )
					cp = dnp;

				if ( _compare( _heap[ cp ], _heap[ dnp - ( -1 )]) >= 0 )
					cp = dnp - ( -1 );
			}
			else if ( dnp <= _heap.length - 1 )
			{
				if ( _compare( _heap[ np ], _heap[ dnp ]) >= 0 )
					cp = dnp;
			}

			//if np has changed, switch 'm
			if ( np != cp )
			{
				var t : * = _heap[ np ];
				_heap[ np ] = _heap[ cp ];
				_heap[ cp ] = t;
			}
			else
			{
				break;
			}
		}

	}

	/**
	 * Moves an item up in the heap
	 */
	private function crawlUp( start : Number ) : void
	{
		var cp : Number = start;

		//as long as the item isnt in the first position
		while ( cp != 1 )
		{
			var hcp : Number = Math.floor( cp / 2 );

			var _heapcp : * = _heap[ cp ];
			var _heaphcp : * = _heap[ hcp ];

			if ( _compare( _heapcp, _heaphcp ) <= 0 )
			{

				//if the current F is lower than or equal to its parent, switch them!
				var t : * = _heaphcp;
				_heap[ hcp ] = _heapcp;
				_heap[ cp ] = t;
				cp = hcp;
			}
			else
			{
				//destination reached!
				break;
			}
		}
	}

	private function setFunction( p_compare : Function ) : void
	{
		if ( p_compare == null )
		{
			this._compare = function( a : Number, b : Number ) : Number
			{
				return a - b;
			};

		}
		else
		{
			this._compare = p_compare;
		}

		_heap = new Array( null );

	}
}

