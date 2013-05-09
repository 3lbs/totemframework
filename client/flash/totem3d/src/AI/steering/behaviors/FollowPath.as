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

	import totem.math.Vector2D;

	public class FollowPath extends ABehavior
	{
		public var isPatrolling : Boolean;

		public var path : Array;

		public var seekDistanceSq : Number;

		private var m_wpIndex : int;

		/**
		 * Agent will follow a set path
		 * @param a_path
		 * @param a_pathSeekDistance
		 *
		 */
		public function FollowPath( a_path : Array, a_isPatrolling : Boolean = false, a_pathSeekDistanceSq : Number = 900 )
		{
			super( AISettings.followPathWeight, AISettings.followPathPriority, AISettings.followPathProbability );
			path = a_path;
			seekDistanceSq = a_pathSeekDistanceSq;
			isPatrolling = a_isPatrolling;
		}

		override public function calculate() : Vector2D
		{
			var len : int = path.length;

			if ( path[ m_wpIndex ].distanceSqTo( agent.actualPos ) < seekDistanceSq )
			{
				( ++m_wpIndex >= len && isPatrolling ) ? m_wpIndex = 0 : m_wpIndex;
			}

			return ( m_wpIndex < len ? Seek.calc( agent, path[ m_wpIndex ]) : Arrive.calc( agent, path[ m_wpIndex ]));
		}
	}
}

