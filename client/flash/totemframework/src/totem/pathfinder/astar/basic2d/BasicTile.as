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

package totem.pathfinder.astar.basic2d
{

	import flash.geom.Point;
	import totem.pathfinder.astar.core.IAstarTile;
	import totem.pathfinder.astar.core.ICostTile;

	/**
	 * Provides basic implementation for the IPositionTile, IWalkable and ICostTile interfaces
	 * @author Jeroen
	 */
	public class BasicTile implements IPositionTile, IWalkableTile, ICostTile, IAstarTile
	{
		private var cost : Number;

		private var position : Point;

		private var walkable : Boolean;

		public function BasicTile( cost : Number, position : Point, walkable : Boolean )
		{
			this.cost = cost;
			this.position = position;
			this.walkable = walkable;
		}

		public function getCost() : Number
		{
			return cost;
		}

		public function getPosition() : Point
		{
			return position;
		}

		public function getWalkable() : Boolean
		{
			return walkable;
		}

		public function setCost( cost : Number ) : void
		{
			this.cost = cost;
		}

		public function setPosition( p : Point ) : void
		{
			position = p;
		}

		public function setWalkable( walkable : Boolean ) : void
		{
			this.walkable = walkable;
		}
	}
}
