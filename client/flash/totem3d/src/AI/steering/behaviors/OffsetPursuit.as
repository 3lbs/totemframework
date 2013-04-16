package AI.steering.behaviors
{
	import AI.AISettings;
	import AI.boid.Boid2DComponent;
	
	import totem.math.Transformations;
	import totem.math.Vector2D;
	
	
	public class OffsetPursuit extends ABehavior
	{
		
		public var leader : Boid2DComponent;
		
		public var offset : Vector2D;
		
		public function OffsetPursuit( a_leader : Boid2DComponent, a_offset : Vector2D )
		{
			super ( AISettings.offsetPursuitWeight, AISettings.offsetPursuitPriority );
			leader = a_leader;
			offset = a_offset;
		}
		
		public override function calculate() : Vector2D
		{
			if ( leader == null )
			{
				return new Vector2D ();
			}
			var worldOffsetPos : Vector2D = Transformations.pointToWorldSpace ( offset, leader.heading, leader.side, leader.actualPos );
			var toOffset : Vector2D = worldOffsetPos.subtractedBy ( agent.actualPos );
			
			var lookAheadTime : Number = toOffset.length / ( agent.maxSpeed + leader.velocity.length );
			
			return Arrive.calc ( agent, worldOffsetPos.addedTo ( leader.velocity.multipliedBy ( lookAheadTime ) ), AISettings.arriveFast );
		}
	
	}
}

