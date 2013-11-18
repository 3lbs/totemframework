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

	import flash.events.IEventDispatcher;
	
	import totem.components.spatial.ISpatial2D;
	import totem.events.RemovableEventDispatcher;

	public class PathPlanner extends RemovableEventDispatcher
	{
		public function PathPlanner( target : IEventDispatcher = null )
		{
			super( target );
		}

		public function requestPathToItem( item : ISpatial2D ) : Vector.<PathEdge>
		{

			var paths : Vector.<PathEdge> = new Vector.<PathEdge>();
			paths.push( new PathEdge() );
			return paths;
		}
	}
}
