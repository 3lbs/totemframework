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
	import totem.core.Destroyable;
	import totem.monitors.promise.IPromise;

	public class PathPlanner extends Destroyable
	{
		public function PathPlanner()
		{
		}

		public function requestPathToItem( item : ISpatial2D ) : IPromise
		{
			return null;
		}
	}
}
