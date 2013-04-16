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

package totem.utils
{

	import org.casalib.util.ConversionUtil;

	public class TimeCodeUtil
	{
		public static const HOURS : String = "h";

		public static const MINUTES : String = "m";

		public static const SECONDS : String = "s";

		public static function convertTimeCodeToMilliseconds( code : String ) : Object
		{

			var whitespace : RegExp = /[\s\r\n]*/gim;
			code = code.replace( whitespace, '' );

			var units = code;
			var _inTime : String = code;

			var reg : RegExp = /\d/g;
			units = units.replace( reg, '' );

			reg = /\D/g;
			var inTime : Number = Number( _inTime.replace( reg, '' ));

			var totalTime : Number = 0;

			switch ( units )
			{
				case HOURS:
				{
					totalTime = ConversionUtil.hoursToMilliseconds( inTime );
					break;
				}
				case MINUTES:
				{
					totalTime = ConversionUtil.minutesToMilliseconds( inTime );
					break;
				}
				case SECONDS:
				{
					totalTime = ConversionUtil.secondsToMilliseconds( inTime );
					break;
				}
				default:
				{
					totalTime = inTime;
					break;
				}
			}

			var timeObject : Object = new Object();

			timeObject.time = totalTime;
			timeObject.unit = units;

			return timeObject;

		}
	}
}
