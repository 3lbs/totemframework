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

package totem.math
{

	import starling.utils.getNextPowerOfTwo;

	/**
	 * I don't really use these functions directly...they are just a reference.
	 * In other words I usually copy them to be used locally by whatever class that
	 * needs them or what not. (mainly for speed).
	 * @author Colby Cheeze
	 *
	 */
	public class MathUtils
	{
		public static const DEG_TO_RAD : Number = ( Math.PI / 180 ); //0.017453293;

		//Multiply by these numbers to get your result.
		//EG: angleInRadians = 30 * DEG_TO_RAD;
		public static const RAD_TO_DEG : Number = ( 180 / Math.PI ); //57.29577951;

		//Returns the angle between two points
		public static function calcAngle( p1 : Vector2D, p2 : Vector2D ) : Number
		{
			var angle : Number = Math.atan(( p2.y - p1.y ) / ( p2.x - p1.x )) * RAD_TO_DEG;

			//if it is in the first quadrant
			if ( p2.y < p1.y && p2.x > p1.x )
			{
				return angle;
			}

			//if its in the 2nd or 3rd quadrant
			if (( p2.y < p1.y && p2.x < p1.x ) || ( p2.y > p1.y && p2.x < p1.x ))
			{
				return angle + 180;
			}
			//it must be in the 4th quadrant so:
			return angle + 360;
		}

		/**
		 * Keep a number between a min and a max.
		 */
		public static function clamp( v : Number, min : Number = 0, max : Number = 1 ) : Number
		{
			if ( v < min )
				return min;

			if ( v > max )
				return max;
			return v;
		}

		//origin means original starting radian, dest destination radian around a circle
		/**
		 * Determines which direction a point should rotate to match rotation the quickest
		 * @param objectRotationRadians The object you would like to rotate
		 * @param radianBetween the angle from the object to the point you want to rotate to
		 * @return -1 if left, 0 if facing, 1 if right
		 *
		 */
		public static function getSmallestRotationDirection( objectRotationRadians : Number, radianBetween : Number, errorRadians : Number = 0 ) : int
		{
			objectRotationRadians = simplifyRadian( objectRotationRadians );
			radianBetween = simplifyRadian( radianBetween );

			radianBetween += -objectRotationRadians;
			radianBetween = simplifyRadian( radianBetween );
			objectRotationRadians = 0;

			if ( radianBetween < -errorRadians )
			{
				return -1;
			}
			else if ( radianBetween > errorRadians )
			{
				return 1;
			}
			return 0;
		}

		/**
		 * Use to find a random value between two numbers.
		 * @param min
		 *
		 */
		public static function rand( min : int, max : int ) : int
		{
			return min + Math.floor( Math.random() * ( max - min + 1 ));
		}

		public static function simplifyRadian( radian : Number ) : Number
		{
			if ( radian > Math.PI || radian < -Math.PI )
			{
				var newRadian : Number;
				newRadian = radian - int( radian / ( Math.PI * 2 )) * ( Math.PI * 2 );

				if ( radian > 0 )
				{
					if ( newRadian < Math.PI )
					{
						return newRadian;
					}
					else
					{
						newRadian = -( Math.PI * 2 - newRadian );
						return newRadian;
					}
				}
				else
				{
					if ( newRadian > -Math.PI )
					{
						return newRadian;
					}
					else
					{
						newRadian = (( Math.PI * 2 ) + newRadian );
						return newRadian;
					}
				}
			}
			return radian;
		}

		/** Returns the next power of two that is equal to or bigger than the specified number. */
		public function getNextPowerOfTwo( number : int ) : int
		{
			if ( number > 0 && ( number & ( number - 1 )) == 0 ) // see: http://goo.gl/D9kPj
				return number;
			else
			{
				var result : int = 1;

				while ( result < number )
					result <<= 1;
				return result;
			}
		}
	}
}

