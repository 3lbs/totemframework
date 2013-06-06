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

		public static const AUTO_NEAREST_FORMAT : uint = 3;

		public static const CODE_HOURS : String = "h";

		public static const CODE_MINUTES : String = "m";

		public static const CODE_SECONDS : String = "s";

		public static const HOURS : uint = 2;

		public static const MINUTES : uint = 1;

		public static const SECONDS : uint = 0;

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
				case CODE_HOURS:
				{
					totalTime = ConversionUtil.hoursToMilliseconds( inTime );
					break;
				}
				case CODE_MINUTES:
				{
					totalTime = ConversionUtil.minutesToMilliseconds( inTime );
					break;
				}
				case CODE_SECONDS:
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
		
		public static function printTimeCode ( code : String ) : String
		{
			
			var whitespace : RegExp = /[\s\r\n]*/gim;
			code = code.replace( whitespace, '' );
			
			var _inTime : String = code;
			
			var units = code;
			
			var reg : RegExp = /\d/g;
			units = units.replace( reg, '' );
			
			reg = /\D/g;
			var inTime : Number = Number( _inTime.replace( reg, '' ));
			
			
			return  inTime + " " + units;
		}

		public static function formatTime( time : Number, detailLevel : uint = AUTO_NEAREST_FORMAT ) : String
		{
			var hours = Math.floor( time / 3600000 );
			var minutes = Math.floor(( time % 3600000 ) / 60000 );
			var seconds = Math.floor((( time % 3600000 ) % 60000 ) / 1000 );

			// print

			if ( detailLevel == AUTO_NEAREST_FORMAT )
			{
				detailLevel = MINUTES;

				if ( hours > 0 )
				{
					detailLevel = HOURS;
				}
			}

			var hourString : String = detailLevel == HOURS ? hours + ":" : "";
			var minuteString : String = detailLevel >= MINUTES ? (( detailLevel == HOURS && minutes < 10 ? "0" : "" ) + minutes + ":" ) : "0:";
			var secondString : String = (( seconds < 10 ) ? "0" : "" ) + seconds;

			return hourString + minuteString + secondString;
		}
	}
}
