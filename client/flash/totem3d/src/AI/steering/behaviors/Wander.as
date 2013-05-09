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

	import totem.math.Transformations;
	import totem.math.Vector2D;

	public class Wander extends ABehavior
	{

		public var distance : Number;

		public var jitter : Number;

		public var m_target : Vector2D;

		public var radius : Number;

		public var v1 : Vector2D;

		private const JITTER_TICK_SIZE : Number = 33 * .001;

		private var v2 : Vector2D;

		public function Wander()
		{
			super( AISettings.wanderWeight, AISettings.wanderPriority );
			jitter = AISettings.wanderJitter;
			radius = AISettings.wanderRadius;
			distance = AISettings.wanderDistance;

			var theta : Number = Math.random() * Math.PI * 2.0;

			//create a vector to a target position on the wander circle
			m_target = new Vector2D( radius * Math.cos( theta ), radius * Math.sin( theta ));

			v1 = new Vector2D();
			v2 = new Vector2D();
		}

		override public function calculate() : Vector2D
		{
			var jitterThisStep : Number = jitter * JITTER_TICK_SIZE;
			v1.x = ( Math.random() - Math.random()) * jitterThisStep;
			v1.y = ( Math.random() - Math.random()) * jitterThisStep;
			m_target.addTo( v1 );

			m_target.normalize();
			m_target.multiply( radius );

			v2.x = distance;
			v2.y = 0;
			v1 = m_target.addedTo( v2 );
			v2 = Transformations.pointToWorldSpace( v1, agent.heading, agent.side, agent.actualPos );

			var steerForce : Vector2D = Seek.calc( agent, v2 );
			return steerForce;
		}

		override public function destroy() : void
		{
			super.destroy();

		}
	}
}

