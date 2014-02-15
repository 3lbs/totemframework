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

	import totem.monitors.promise.Deferred;

	/**
	 * The PathRequest class describes a request to be handled by the Astar class.
	 * @author Jeroen Beckers
	 */
	public class PathRequest extends Deferred
	{

		internal static var _disposed : Vector.<PathRequest> = new Vector.<PathRequest>();

		public static function create( start : IAstarTile, end : IAstarTile, map : IMap, priority : uint = 10 ) : PathRequest
		{
			if ( _disposed.length > 0 )
			{
				return _disposed.pop().setTo( start, end, map, priority );
			}

			return new PathRequest( start, end, map, priority );
		}

		/**
		 * Analyzers. The neighbours returned by the INeighboursCollector are passed through these analyzers to eliminate non-eligible neighbours
		 */
		private var _analyzer : Analyzer;

		private var _end : IAstarTile;

		private var _map : IMap;

		private var _priority : uint;

		private var _start : IAstarTile;

		/**
		 * Creates a new PathRequest
		 *
		 * @param start		The start point
		 * @param end		The end point
		 * @param map		The map to search in
		 * @param priority	The priority of this request
		 */
		public function PathRequest( start : IAstarTile, end : IAstarTile, map : IMap, priority : uint = 10 )
		{
			if ( start == null )
			{
				throw new AstarError( "Invalid start point" );
			}

			if ( end == null )
			{
				throw new AstarError( "Invalid end point" );
			}

			if ( map == null )
			{
				throw new AstarError( "Invalid map point" );
			}
			this._start = start;
			this._end = end;
			this._priority = priority;
			this._map = map;

			//initialize Analyzer list
			_analyzer = new Analyzer();

		}

		/**
		 * Add an analyzer to the analyzer chain
		 *
		 * @param analyzer	The analyzer to add to the analyzer chain
		 */
		public function addAnalyzer( analyzer : Analyzer ) : PathRequest
		{
			analyzer.setSubAnalyzer( _analyzer );
			this._analyzer = analyzer;

			return this;
		}

		override public function dispose() : void
		{
			super.dispose();

			
			this._analyzer = null;

			this._start = null;
			this._end = null;
			this._map = null;

			var a : PathRequest;
			var idx : int = _disposed.indexOf( this );
			if ( idx != -1 )
				return;

			_disposed.push( this );
		}

		/**
		 * Returns the Analyzer chain for this PathRequest
		 */
		public function getAnalyzers() : Analyzer
		{
			return this._analyzer;
		}

		/**
		 * Returns the end point of this request
		 *
		 * @return The end point
		 */
		public function getEnd() : IAstarTile
		{
			return _end;
		}

		/**
		 * Returns the map of this request
		 *
		 * @return The map
		 */
		public function getMap() : IMap
		{
			return _map;
		}

		/**
		 * Returns the start point of this request
		 *
		 * @return The start point
		 */
		public function getStart() : IAstarTile
		{
			return _start;
		}

		/**
		 * Returns true if the given tile is a target tile. Returns false otherwise. A* will stop searching if it find this tile as the best tile.
		 */
		public function isTarget( tile : IAstarTile ) : Boolean
		{
			return tile == this.getEnd();
		}

		/**
		 * Returns the priority of this request
		 *
		 * @return The priority
		 */
		public function get priority() : uint
		{
			return _priority;
		}

		/**
		 * Sets the priority of this request
		 *
		 * @param priority 		The priority
		 */
		public function set priority( priority : uint ) : void
		{
			_priority = priority;
		}

		/**
		 * Sets the end point of this request
		 *
		 * @param end		 The end point
		 */
		public function setEnd( end : IAstarTile ) : void
		{
			_end = end;
		}

		/**
		 * Sets the map of this request
		 *
		 * @param map 		The map
		 */
		public function setMap( map : IMap ) : void
		{
			_map = map;
		}

		/**
		 * Sets the start point of this request
		 *
		 * @param start		The start point
		 */
		public function setStart( start : IAstarTile ) : void
		{
			_start = start;
		}

		public function setTo( start : IAstarTile, end : IAstarTile, map : IMap, priority : uint = 10 ) : PathRequest
		{
			this._start = start;
			this._end = end;
			this._priority = priority;
			this._map = map;

			//initialize Analyzer list
			_analyzer = new Analyzer();
			return this;
		}
		
		override protected function clearListeners() : void
		{
			super.clearListeners();
			
			//dispose();
			
		}

	}
}
