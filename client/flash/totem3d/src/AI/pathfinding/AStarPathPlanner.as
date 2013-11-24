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
//   3lbs Copyright 2013 
//   For more information see http://www.3lbs.com 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package AI.pathfinding
{

	
	import totem.components.spatial.ISpatial2D;
	import totem.monitors.promise.IPromise;
	import totem.pathfinder.astar.core.Astar;
	import totem.pathfinder.astar.core.IMap;
	import totem.pathfinder.astar.core.PathRequest;

	public class AStarPathPlanner extends PathPlanner
	{
		private var _aStar : Astar;

		private var _map : IMap;

		public function AStarPathPlanner( astar : Astar, map : IMap )
		{
			_aStar = astar;
			_map = map;
			
		}

		override public function requestPathToItem( item : ISpatial2D ) : IPromise 
		{
			return PathRequest.create( null, null, _map );
		}
	}
}
