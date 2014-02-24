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

	import org.casalib.math.Percent;

	public class PercentUtil
	{
		public function PercentUtil()
		{
		}

		/**
		 Determines a percentage of a value in a given range.

		 @param value: The value to be converted.
		 @param minimum: The lower value of the range.
		 @param maximum: The upper value of the range.
		 @example
		 <code>
		 trace(NumberUtil.normalize(8, 4, 20).decimalPercentage); // Traces 0.25
		 </code>
		 */
		public static function normalize( value : Number, minimum : Number, maximum : Number ) : Percent
		{
			return new Percent(( value - minimum ) / ( maximum - minimum ));
		}
	}
}
