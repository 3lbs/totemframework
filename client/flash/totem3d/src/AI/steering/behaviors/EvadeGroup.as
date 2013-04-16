package AI.steering.behaviors
{
	import AI.AISettings;
	import AI.boid.Boid2DComponent;
	
	import totem.math.Vector2D;
	
	public class EvadeGroup extends ABehavior
	{
		public var pursuerType : String;
		
		public var pursuer : Boid2DComponent;
		
		public var fleeDistSq : Number;
		
		
		public function EvadeGroup( a_pursuers : String, a_fleeDistSq : Number = 0 )
		{
			//pursuer = a_pursuer;
			pursuerType = a_pursuers;
			
			fleeDistSq = a_fleeDistSq;
			super ( AISettings.evadeWeight, AISettings.evadePriority );
		}
		
		
		public override function calculate() : Vector2D
		{
			// get nearest pursuer and avoid!  error should be nearest
			pursuer = agent.steering.getFirstBoidOfType ( pursuerType );
			
			if ( !pursuer )
				return new Vector2D();
			
			var toPursuer : Vector2D = pursuer.actualPos.subtractedBy ( agent.actualPos );
			
			if ( toPursuer.lengthSq > fleeDistSq && fleeDistSq > 0 )
				return new Vector2D ();
			
			var lookAheadTime : Number = toPursuer.length / ( agent.maxSpeed + pursuer.velocity.length );
			//lookAheadTime += turnAroundTime();
			
			return ( agent.actualPos.subtractedBy ( pursuer.actualPos ).getNormalized () ).multipliedBy ( agent.maxSpeed ).subtractedBy ( agent.velocity );
		}
		
		public static function calc( a_agent : Boid2DComponent, a_pursuer : Boid2DComponent, a_fleeDistSq : Number = 0 ) : Vector2D
		{
			var toPursuer : Vector2D = a_pursuer.actualPos.subtractedBy ( a_agent.actualPos );
			
			if ( toPursuer.lengthSq > a_fleeDistSq && a_fleeDistSq > 0 )
				return new Vector2D ();
			
			var lookAheadTime : Number = toPursuer.length / ( a_agent.maxSpeed + a_pursuer.velocity.length );
			//lookAheadTime += turnAroundTime();
			
			return ( a_agent.actualPos.subtractedBy ( a_pursuer.actualPos ).getNormalized () ).multipliedBy ( a_agent.maxSpeed ).subtractedBy ( a_agent.velocity );
		}
		
		private function turnAroundTime( a_agent : Boid2DComponent, a_pursuer : Boid2DComponent ) : Number
		{
			var toTarget : Vector2D = a_pursuer.actualPos.subtractedBy ( a_agent.actualPos ).getNormalized ();
			var dot : Number = a_agent.heading.dotOf ( toTarget );
			
			//tweak this number to effect the time. EX:
			//If vehicle is heading opposite then 0.5 will mean
			//a 1 second turnaround time is returned
			var coefficient : Number = 0.5;
			
			return ( dot - 1.0 ) * -coefficient;
		}
	}
}

