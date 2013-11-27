package AI.steering.behaviors
{
	import AI.AISettings;
	import AI.boid.Boid2DComponent;
	
	import totem.math.Vector2D;
	
	
	public class Interpose extends ABehavior
	{
		
		public var targetA : Boid2DComponent;
		
		public var targetB : Boid2DComponent;
		
		public function Interpose( targetA : Boid2DComponent, targetB : Boid2DComponent )
		{
			super ( AISettings.interposeWeight, AISettings.interposePriority );
			this.targetA = targetA;
			this.targetB = targetB;
		}
		
		public override function calculate() : Vector2D
		{
			midPoint = ( targetA.position.addedTo ( targetB.position ) ).dividedBy ( 2 );
			
			var timeToReachMidPoint : Number = agent.actualPos.distanceTo ( midPoint ) / agent.maxSpeed;
			
			posA = targetA.position.addedTo ( targetA.velocity.multipliedBy ( timeToReachMidPoint ) );
			posB = targetB.position.addedTo ( targetB.velocity.multipliedBy ( timeToReachMidPoint ) );
			
			midPoint = ( posA.addedTo ( posB ) ).dividedBy ( 2 );
			
			return Arrive.calc ( agent, midPoint, AISettings.arriveFast );
		}
		
		private var midPoint : Vector2D;
		
		private var posA : Vector2D;
		
		private var posB : Vector2D;
		
		private var toTarget : Vector2D;
	
	}
}


