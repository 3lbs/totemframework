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

package application.rateourapp
{

	import com.freshplanet.nativeExtensions.AirNetworkInfo;
	
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.Capabilities;
	
	import application.AppDatabaseService;
	import application.ApplicationConfig;
	
	import org.casalib.util.ConversionUtil;
	import org.osflash.vanilla.extract;
	
	import totem.events.RemovableEventDispatcher;
	import totem.monitors.startupmonitor.IStartupProxy;

	public class RateOurAppModel extends RemovableEventDispatcher implements IStartupProxy
	{

		public static const RATE_NEVER : int = 20;

		public static const RATE_NO : int = 0;

		public static const RATE_OUR_APP_EVENT : String = "RateOurApp:RateOurAppEvent";

		public static const RATE_YES : int = 10;

		public static const coolDownHours : int = 24;

		public static const maxNumberOfPrompts : int = 3;

		public static const minDaysTilPrompt : int = 0;

		public static const minLaunchesTilPrompt : int = 10;

		private static const RATE_APP_KEY : String = "RateAppKey";

		private var rateAppParam : RateParam;

		public function RateOurAppModel()
		{
		}

		public function canRateOurApp() : Boolean
		{

			// user hasnt opened the app enough times
			// user doesnt have an internet connection
			var connected : Boolean = AirNetworkInfo.networkInfo.isConnected();

			if ( AppDatabaseService.application.launches < minLaunchesTilPrompt || !connected )
			{
				return false;
			}

			if ( !rateAppParam )
			{
				// first run of app! We have used it enough to start!
				return true;
			}

			// never ask again or we have asked too many times
			if ( rateAppParam.notNever || rateAppParam.totalNumberOfPrompts >= maxNumberOfPrompts )
			{
				return false;
			}

			var coolDownDate : Date = new Date()
			coolDownDate.setTime( coolDownDate.getTime() - ConversionUtil.hoursToMilliseconds( coolDownHours ));

			if ( rateAppParam.lastRequest < coolDownDate.getTime())
			{
				return true;
			}

			return false;
		}

		public function isAndroid() : Boolean
		{
			return Capabilities.manufacturer.indexOf( 'Android' ) > -1;
		}

		public function load() : void
		{
			var rateAppObject : String = AppDatabaseService.getAppProp( RATE_APP_KEY );

			if ( rateAppObject )
			{
				rateAppParam = extract( JSON.parse( rateAppObject ), RateParam ) as RateParam;
			}

			dispatchEvent( new Event( Event.COMPLETE ));
		}

		// Open the review page in the app store
		//
		public function openRatePage( appID : String ) : void
		{
			var appUrl : String = ApplicationConfig.APP_STORE_BASE_URI + appID;

			if ( isAndroid())
			{
				appUrl = ApplicationConfig.PLAY_STORE_BASE_URI + appID + ApplicationConfig.PLAY_REVIEW;
			}

			// Open store URI 	
			var req : URLRequest = new URLRequest( appUrl );
			navigateToURL( req );
		}

		// yes, no or never
		public function userRateChoice( value : int ) : Boolean
		{
			if ( !rateAppParam )
				rateAppParam = new RateParam();

			if ( value == RATE_NEVER || value == RATE_YES )
				rateAppParam.notNever = true;

			rateAppParam.totalNumberOfPrompts += 1;
			rateAppParam.lastRequest = new Date().getTime();

			AppDatabaseService.setAppProp( RATE_APP_KEY, JSON.stringify( rateAppParam ));

			return ( value == RATE_YES );
		}
	}
}
