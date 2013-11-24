package AI.steering.behaviors
{
	import AI.AISettings;
	
	import totem.components.spatial.ISpatial2D;
	import totem.math.Vector2D;
	
	
	public class Seek extends ABehavior
	{
		
		public var target : Vector2D;
		
		public var seekDistSq : Number;
		
		public function Seek( a_target : Vector2D, a_seekDistSq : Number = 0 )
		{
			
			super ( AISettings.seekWeight, AISettings.seekPriority );
			
			target = a_target;
			seekDistSq = a_seekDistSq;
		}
		
		override public function calculate() : Vector2D
		{
			if ( agent.actualPos.distanceSqTo ( target ) > seekDistSq && seekDistSq > 0 )
			{
				return Vector2D.create();
			}
			
			// | target - agentPos | * agentMaxSpeed
			var desiredVel : Vector2D = ( target.subtractedBy ( agent.actualPos ).getNormalized () ).multipliedBy ( agent.maxSpeed );
			// desiredVelocity - agentVelocity
			return desiredVel.subtractedBy ( agent.velocity );
		}
		
		public static function calc( agent : ISpatial2D, target : Vector2D, seekDistSq : Number = 0 ) : Vector2D
		{
			if ( agent.actualPos.distanceSqTo ( target ) > seekDistSq && seekDistSq > 0 )
			{
				return Vector2D.create();
			}
			
			var desiredVel : Vector2D = ( target.subtractedBy ( agent.actualPos ).dispose().getNormalized ().dispose() ).multipliedBy ( agent.maxSpeed );
			return desiredVel.subtractedBy ( agent.velocity );
		}
	
	}
}


