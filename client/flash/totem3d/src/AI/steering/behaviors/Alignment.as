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

	public class Alignment extends ABehavior implements IGroupBehavior
	{

		private var averageHeading : Vector2D;

		private var neighborCount : int;

		private var ob : Boid2DComponent;

		public function Alignment()
		{
			super( AISettings.alignmentWeight, AISettings.alignmentPriority );
			averageHeading = new Vector2D();
		}

		override public function calculate() : Vector2D
		{
			averageHeading.x = 0;
			averageHeading.y = 0;
			neighborCount = 0;

			var i : int = agent.steering.neighbors.length;

			while ( --i >= 0 )
			{
				ob = agent.steering.neighbors[ i ];

				if ( ob != agent )
				{
					averageHeading.x += ob.heading.x;
					averageHeading.y += ob.heading.y;
					neighborCount++;
				}
			}

			if ( neighborCount > 0 )
			{
				averageHeading.x /= neighborCount;
				averageHeading.y /= neighborCount;

				averageHeading.x -= agent.heading.x;
				averageHeading.y -= agent.heading.y;
			}

			//trace( "<Alignment> avgHeading: " + averageHeading );
			return averageHeading;
		}
		
		override public function destroy():void
		{
			super.destroy();
			
			ob = null;
			
		}
	}
	
	
}
