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
//   3lbs Copyright 2014 
//   For more information see http://www.3lbs.com 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package totem.utils
{

	public class EaseFuncUtil
	{
		public static function easeInCubic( t : Number, b : Number, c : Number, d : Number ) : Number
		{
			return c * ( t /= d ) * t * t + b;
		}

		public static function easeInQuad( t : Number, b : Number, c : Number, d : Number ) : Number
		{
			return c * ( t /= d ) * t + b;
		}

		public static function easeInQuart( t : Number, b : Number, c : Number, d : Number ) : Number
		{
			return c * ( t /= d ) * t * t * t + b;
		}

		public static function easeOutCubic( t : Number, b : Number, c : Number, d : Number ) : Number
		{
			return c * (( t = t / d - 1 ) * t * t + 1 ) + b;
		}

		public static function easeOutQuad( t : Number, b : Number, c : Number, d : Number ) : Number
		{
			return -c * ( t /= d ) * ( t - 2 ) + b;
		}

		public static function easeOutQuart( t : Number, b : Number, c : Number, d : Number ) : Number
		{
			return -c * (( t = t / d - 1 ) * t * t * t - 1 ) + b;
		}

		public function EaseFuncUtil()
		{
		}
	}
}
