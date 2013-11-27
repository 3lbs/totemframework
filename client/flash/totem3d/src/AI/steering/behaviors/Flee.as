package AI.steering.behaviors
{
	import AI.AISettings;
	import AI.boid.Boid2DComponent;
	
	import totem.math.Vector2D;
	
	;
	
	public class Flee extends ABehavior
	{
		
		public var fleeDistSq : Number;
		
		public var target : Vector2D;
		
		public function Flee( a_target : Vector2D, a_fleeDistSq : Number = 0 )
		{
			super ( AISettings.fleeWeight, AISettings.fleePriority );
			target = a_target;
			fleeDistSq = a_fleeDistSq;
		
		}
		
		override public function calculate() : Vector2D
		{
			if ( agent.actualPos.distanceSqTo ( target ) > fleeDistSq && fleeDistSq > 0 )
			{
				return new Vector2D ();
			}
			desiredVel = ( agent.actualPos.subtractedBy ( target ).getNormalized () ).multipliedBy ( agent.maxSpeed );
			return desiredVel.subtractedBy ( agent.velocity );
		}
		
		public static function calc( agent : Boid2DComponent, target : Vector2D, fleeDistSq : Number ) : Vector2D
		{
			if ( agent.position.distanceSqTo ( target ) > fleeDistSq && fleeDistSq > 0 )
			{
				return new Vector2D ();
			}
			var desiredVel : Vector2D = ( agent.position.subtractedBy ( target ).getNormalized () ).multipliedBy ( agent.maxSpeed );
			return desiredVel.subtractedBy ( agent.velocity );
		}
		
		private var desiredVel : Vector2D;
	
	}
}

