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

package AI.steering.behaviors
{

	import AI.AISettings;
	import AI.boid.Boid2DComponent;

	import totem.math.Vector2D;

	/**
	 * The agent will attempt to "dodge" or avoid other agents.
	 * @author colby
	 *
	 */
	public class Dodge extends ABehavior implements IGroupBehavior
	{

		public var seperationDistance : Number = 5;

		private var neighbor : Boid2DComponent;

		private var steeringForce : Vector2D;

		private var toAgent : Vector2D;

		public function Dodge()
		{
			super( AISettings.dodgeWeight, AISettings.dodgePriority, AISettings.dodgeProbability );
			steeringForce = new Vector2D();
			toAgent = new Vector2D();
		}

		override public function calculate() : Vector2D
		{
			var normalized : Vector2D = new Vector2D;
			steeringForce.x = 0;
			steeringForce.y = 0;

			var i : int = agent.steering.neighbors.length;

			while ( --i >= 0 )
			{
				neighbor = agent.steering.neighbors[ i ];

				if ( neighbor != agent )
				{

					var dist : Number = agent.actualPos.distanceTo( neighbor.position );
					dist = ( dist == 0 ? 0.001 : dist );

					var range : Number = agent.radius + neighbor.radius + seperationDistance;

					if ( dist < range )
					{
						toAgent.x = agent.actualPos.x - neighbor.position.x;
						toAgent.y = agent.actualPos.y - neighbor.position.y;
						normalized.x = ( toAgent.x == 0 ? 0.001 : toAgent.x / dist );
						normalized.y = ( toAgent.y == 0 ? 0.001 : toAgent.y / dist );

						steeringForce.addTo( normalized.multipliedBy(( range - dist )));
					}

				}
			}
			return steeringForce;
		}

		override public function destroy() : void
		{
			super.destroy();

			neighbor = null;
		}
	}
}

