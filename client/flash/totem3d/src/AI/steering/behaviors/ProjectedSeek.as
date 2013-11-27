package AI.steering.behaviors
{
	import AI.AISettings;
	import AI.boid.Boid2DComponent;
	
	import totem.math.Vector2D;
	
	
	public class ProjectedSeek extends ABehavior
	{
		
		public var target : Vector2D;
		
		public var seekDistSq : Number;
		
		public var projectionDistance : Number
		
		public function ProjectedSeek( a_target : Vector2D, a_projectionDistance : Number, a_seekDistSq : Number = 0 )
		{
			super ( AISettings.seekWeight, AISettings.seekPriority );
			
			target = a_target;
			seekDistSq = a_seekDistSq;
			projectionDistance = a_projectionDistance;
		}
		
		override public function calculate() : Vector2D
		{
			
			if ( agent.actualPos.distanceSqTo ( target ) > seekDistSq && seekDistSq > 0 )
			{
				return new Vector2D ();
			}
			
			var normalized : Vector2D = agent.actualPos.subtractedBy ( target ).getNormalized ();
			var newTarget : Vector2D = target.addedTo ( normalized.multipliedBy ( projectionDistance ) );
			return newTarget.subtractedBy ( agent.actualPos );
		
		}
		
		public static function calc( a_agent : Boid2DComponent, a_target : Vector2D, a_projectionDistance : Number, a_seekDistSq : Number = 0 ) : Vector2D
		{
			if ( a_agent.position.distanceSqTo ( a_target ) > a_seekDistSq && a_seekDistSq > 0 )
			{
				return new Vector2D ();
			}
			
			var normalized : Vector2D = a_agent.position.subtractedBy ( a_target ).getNormalized ();
			var newTarget : Vector2D = a_target.addedTo ( normalized.multipliedBy ( a_projectionDistance ) );
			return newTarget.subtractedBy ( a_agent.position );
		}
		
		private var desiredVel : Vector2D;
	
	}
}


