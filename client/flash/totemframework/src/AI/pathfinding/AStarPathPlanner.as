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

package AI.pathfinding
{

	import totem.data.type.Point2d;
	import totem.monitors.promise.IPromise;
	import totem.pathfinder.astar.basic2d.IPositionTile;
	import totem.pathfinder.astar.core.Analyzer;
	import totem.pathfinder.astar.core.Astar;
	import totem.pathfinder.astar.core.IAstarTile;
	import totem.pathfinder.astar.core.IMap;
	import totem.pathfinder.astar.core.PathRequest;

	public class AStarPathPlanner
	{
		private var _aStar : Astar;

		private var _analyzers : Vector.<Analyzer> = new Vector.<Analyzer>();

		private var _map : IMap;

		private var _pt : Point2d;

		public function AStarPathPlanner( astar : Astar, map : IMap )
		{
			_aStar = astar;
			_map = map;

		}

		public function addAnalyzer( analyzer : Analyzer ) : void
		{
			_analyzers.push( analyzer );
		}
		
		
		public function reset() : void
		{
			_aStar.reset();
		}
		

		public function getTile( x, y ) : IPositionTile
		{

			if ( _map )
			{
				_pt ||= new Point2d( x, y );
				_pt.x = x;
				_pt.y = y;

				return _map.getTileAt( _pt );
			}
			return null;
		}

		public function get map() : IMap
		{
			return _map;
		}

		public function set map( value : IMap ) : void
		{
			_map = value;
		}

		public function requestPathToItem( start : IAstarTile, end : IAstarTile ) : IPromise
		{
			var request : PathRequest = PathRequest.create( start, end, _map )

			for each ( var analyzer : Analyzer in _analyzers )
			{
				request.addAnalyzer( analyzer );
			}

			return _aStar.getPath( request );
		}
	}
}
