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

	public class Arrive extends ABehavior
	{

		public static function calc( a_agent : Boid2DComponent, a_target : Vector2D, a_speed : int = 3 ) : Vector2D
		{
			var toTarget : Vector2D = a_target.subtractedBy( a_agent.actualPos );
			var dist : Number = toTarget.length;

			if ( dist > 0.01 )
			{
				var spd : Number = dist / ( a_speed * AISettings.speedTweaker );

				spd = ( spd > a_agent.maxSpeed ? a_agent.maxSpeed : spd );

				toTarget.multiply( spd / dist );
				toTarget.subtract( a_agent.velocity );
				return toTarget;
			}
			return new Vector2D();
		}

		public var target : Vector2D;

		private var m_speed : int;

		public function Arrive( a_target : Vector2D, a_decelerationSpeed : int = 3 )
		{
			super( AISettings.arriveWeight, AISettings.arrivePriority );
			target = a_target;
			speed = a_decelerationSpeed;
		}

		override public function calculate() : Vector2D
		{
			var toTarget : Vector2D = target.subtractedBy( agent.actualPos );
			var dist : Number = toTarget.length;

			if ( dist > 0.01 )
			{
				var spd : Number = dist / ( m_speed * AISettings.speedTweaker );

				spd = ( spd > agent.maxSpeed ? agent.maxSpeed : spd );

				toTarget.multiply( spd / dist );
				toTarget.subtract( agent.velocity );
				return toTarget;
			}
			return new Vector2D();
		}

		override public function destroy() : void
		{
			super.destroy();

			target = null;

		}

		public function get speed() : int
		{
			return m_speed;
		}

		public function set speed( value : int ) : void
		{
			if ( value != AISettings.arriveFast && value != AISettings.arriveNormal && value != AISettings.arriveSlow )
			{
				value = AISettings.arriveNormal;
				trace( "<Arrive:set speed> Unknown value supplied. Defaulting to NORMAL" );
			}
			m_speed = value;

		}
	}
}

