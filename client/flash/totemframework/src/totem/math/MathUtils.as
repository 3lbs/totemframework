
package totem.math
{
	
	import flash.geom.Point;
	
	/**
	 * I don't really use these functions directly...they are just a reference.
	 * In other words I usually copy them to be used locally by whatever class that
	 * needs them or what not. (mainly for speed).
	 * @author Colby Cheeze
	 *
	 */ 	
	public class MathUtils
	{
		
		//Multiply by these numbers to get your result.
		//EG: angleInRadians = 30 * DEG_TO_RAD;
		public static const RAD_TO_DEG:Number = (180 / Math.PI); //57.29577951;
		public static const DEG_TO_RAD:Number = (Math.PI / 180); //0.017453293;
		
		/**
		 * Use to find a random value between two numbers.
		 * @param min
		 * @param max
		 * @return
		 *
		 */ 		
		public static function rand(min:int, max:int):int
		{
			return min + Math.floor(Math.random() * (max - min + 1));
		}
		
		//Returns the angle between two points
		public static function calcAngle( p1:Vector2D, p2:Vector2D ):Number
		{
			var angle:Number = Math.atan( (p2.y - p1.y) / (p2.x - p1.x) ) * RAD_TO_DEG;
			
			//if it is in the first quadrant
			if( p2.y < p1.y && p2.x > p1.x )
			{
				return angle;
			}
			//if its in the 2nd or 3rd quadrant
			if( ( p2.y < p1.y && p2.x < p1.x ) || ( p2.y > p1.y && p2.x < p1.x ) )
			{
				return angle + 180;
			}
			//it must be in the 4th quadrant so:
			return angle + 360;
		}
		
		//origin means original starting radian, dest destination radian around a circle
		/**
		 * Determines which direction a point should rotate to match rotation the quickest
		 * @param objectRotationRadians The object you would like to rotate
		 * @param radianBetween the angle from the object to the point you want to rotate to
		 * @return -1 if left, 0 if facing, 1 if right
		 *
		 */ 		
		public static function getSmallestRotationDirection( objectRotationRadians:Number, radianBetween:Number, errorRadians:Number = 0 ):int
		{
			objectRotationRadians = simplifyRadian( objectRotationRadians );
			radianBetween = simplifyRadian( radianBetween );
			
			radianBetween += -objectRotationRadians;
			radianBetween = simplifyRadian( radianBetween );
			objectRotationRadians = 0;
			if( radianBetween < -errorRadians )
			{
				return -1;
			}
			else if( radianBetween > errorRadians )
			{
				return 1;
			}
			return 0;
		}
		
		public static function simplifyRadian( radian:Number ):Number
		{
			if( radian > Math.PI || radian < -Math.PI )
			{
				var newRadian:Number;
				newRadian = radian - int( radian / ( Math.PI *2 ) ) * ( Math.PI * 2 );
				if( radian > 0)
				{
					if( newRadian < Math.PI )
					{
						return newRadian;
					}
					else
					{
						newRadian =- ( Math.PI * 2 - newRadian );
						return newRadian;
					}
				}
				else
				{
					if( newRadian > -Math.PI )
					{
						return newRadian;
					}
					else
					{
						newRadian = ( ( Math.PI * 2 ) + newRadian );
						return newRadian;
					}
				}
			}
			return radian;
		}
	
	}
}


