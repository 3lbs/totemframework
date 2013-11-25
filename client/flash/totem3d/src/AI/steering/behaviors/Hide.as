package AI.steering.behaviors
{
	import AI.AISettings;
	import AI.boid.Boid2DComponent;
	
	import totem.math.Vector2D;
	
	
	public class Hide extends ABehavior
	{
		
		public var distFromBoundary : Number;
		
		public var obstacles : Array;
		
		public var hunter : Boid2DComponent;
		
		public function Hide( a_hunter : Boid2DComponent, a_obstacles : Array, a_distFromBoundary : Number = 30 )
		{
			super ( AISettings.hideWeight, AISettings.hidePriority );
			
			hunter = a_hunter;
			obstacles = a_obstacles;
			distFromBoundary = a_distFromBoundary;
		}
		
		public override function calculate() : Vector2D
		{
			var ob : Boid2DComponent;
			var distToClosest : Number = Number.MAX_VALUE;
			
			var i : int = obstacles.length;
			
			while ( --i >= 0 )
			{
				ob = obstacles[ i ];
				hidingSpot = getHidingPosition ( ob.actualPos, ob.radius );
				var dist : Number = hidingSpot.distanceTo ( agent.actualPos );
				
				if ( dist < distToClosest )
				{
					distToClosest = dist;
					bestHidingSpot = hidingSpot;
					closest = ob;
				}
			}
			
			//hunter
			return ( distToClosest == Number.MAX_VALUE ? Evade.calc ( agent, null ) : Arrive.calc ( agent, bestHidingSpot, AISettings.arriveFast ) );
		}
		
		private function getHidingPosition( a_obPos : Vector2D, a_obRadius : Number ) : Vector2D
		{
			//calc how far away the agent is to be from the obstacles radius
			var distAway : Number = distFromBoundary + a_obRadius;
			
			toOb = a_obPos.subtractedBy ( hunter.actualPos ).getNormalized ();
			
			return ( toOb.multipliedBy ( distAway ) ).addedTo ( a_obPos );
		}
		
		
		private var bestHidingSpot : Vector2D;
		
		private var hidingSpot : Vector2D;
		
		private var closest : Boid2DComponent;
		
		private var toOb : Vector2D;
	
	
	}
}

