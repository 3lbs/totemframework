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

package totem.loaders.stage3d
{

	import flash.display.Stage3D;
	import flash.display3D.Context3DProfile;
	import flash.display3D.Context3DRenderMode;
	import flash.events.ErrorEvent;
	import flash.events.Event;

	/**
	 * A simple way to get an optimal Context3D. That is, an extended profile
	 * context is the first priority, then a baseline profile, then a
	 * constrained profile, and finally a software profile.
	 * @author Jackson Dunstan, JacksonDunstan.com
	 */
	public class GetContext3D
	{

		// Context3DProfile.BASELINE. Use a string literal instead of
		// the Context3DProfile class so that this class can still be compiled
		// for Flash Players before the Context3DProfile class existed.
		/*private static const BASELINE : String = "baseline";

		// Context3DProfile.BASELINE_CONSTRAINED. Use a string literal instead of
		// the Context3DProfile class so that this class can still be compiled
		// for Flash Players before the Context3DProfile class existed.
		private static const BASELINE_CONSTRAINED : String = "baselineConstrained";

		// Context3DProfile.BASELINE_EXTENDED. Use a string literal instead of
		// the Context3DProfile class so that this class can still be compiled
		// for Flash Players before the Context3DProfile class existed.
		private static const BASELINE_EXTENDED : String = "baselineExtended";*/

		/** Callback to call when the context is acquired or an error occurs
		 *   that prevents the context from being acquired. Passed a success
		 *   Boolean and a message String if the callback function takes two or
		 *   more parameters. If the callback function takes only one parameter,
		 *   only the success Boolean is passed. If the callback function takes
		 *   no parameters, none are passed.
		 */
		private var callback : Function;

		/** Profile to get */
		private var profile : String;

		/** Render mode to get */
		private var renderMode : String;

		/** Stage3D to get the context for */
		private var stage3D : Stage3D;

		/**
		 * Get the best Context3D for a Stage3D and call the callback when done
		 * @param stage3D Stage3D to get the context for
		 * @param callback Callback to call when the context is acquired or an
		 *        error occurs that prevents the context from being acquired.
		 *        Passed a success Boolean and a message String if the callback
		 *        function takes two or more parameters. If the callback
		 *        function takes only one parameter, only the success Boolean is
		 *        passed. If the callback function takes no parameters, none are
		 *        passed.
		 * @throws Error If the given stage3D or callback is null
		 */
		public function GetContext3D( stage3D : Stage3D, callback : Function )
		{
			// Callback and Stage3D must be non-null
			if ( callback == null )
			{
				throw new Error( "Callback can't be null" )
			}

			if ( stage3D == null )
			{
				throw new Error( "Stage3D can't be null" )
			}

			// Save the callback and Stage3D
			this.callback = callback;
			this.stage3D = stage3D;

			// Start by trying to acquire the best kind of profile
			renderMode = Context3DRenderMode.AUTO;
			profile = Context3DProfile.BASELINE_EXTENDED;
			stage3D.addEventListener( Event.CONTEXT3D_CREATE, onContext3DCreated );
			stage3D.addEventListener( ErrorEvent.ERROR, onStage3DError );
			requestContext();
		}

		/**
		 * Call the callback function and clean up
		 * @param success If the context was acquired successfully
		 * @param message Message about the context acquisition
		 */
		private function callCallback( success : Boolean, message : String ) : void
		{
			// Remove event listeners
			stage3D.removeEventListener( Event.CONTEXT3D_CREATE, onContext3DCreated );
			stage3D.removeEventListener( ErrorEvent.ERROR, onStage3DError );

			// Release reference to the callback after this function completes
			var callback : Function = this.callback;
			this.callback = null;

			// Release reference to the Stage3D
			stage3D = null;

			// Pass as many arguments as the callback function requires
			var numArgs : uint = callback.length;

			switch ( numArgs )
			{
				case 0:
					callback();
					break;
				case 1:
					callback( success );
					break;
				case 2:
					callback( success, message );
					break;
			}
		}

		/**
		 * Fall back to the next-best profile
		 */
		private function fallback() : void
		{
			// Check what profile we were trying to get
			switch ( profile )
			{
				// Trying to get extended profile. Try baseline.
				case  Context3DProfile.BASELINE_EXTENDED:
					profile =  Context3DProfile.BASELINE;
					requestContext();
					break;
				// Trying to get baseline profile. Try constrained.
				case  Context3DProfile.BASELINE:
					profile =  Context3DProfile.BASELINE_CONSTRAINED;
					requestContext();
					break;
				// Trying to get constrained profile. Try software.
				case  Context3DProfile.BASELINE_CONSTRAINED:
					profile =  Context3DProfile.BASELINE;
					renderMode = Context3DRenderMode.SOFTWARE;
					requestContext();
					break;
			}
		}

		/**
		 * Callback for when the context is created
		 * @param ev CONTEXT3D_CREATE event
		 */
		private function onContext3DCreated( ev : Event ) : void
		{
			// Got a software driver
			var driverInfo : String = stage3D.context3D.driverInfo.toLowerCase();
			var gotSoftware : Boolean = driverInfo.indexOf( "software" ) >= 0;

			if ( gotSoftware )
			{
				// Trying to get a non-software profile
				if ( renderMode == Context3DRenderMode.AUTO )
				{
					fallback();
				}
				else
				{
					// Trying to get software. Succeeded.
					callCallback( true, "Profile: " + profile );
				}
			}
			// Didn't get a software driver
			else
			{
				callCallback( true, "Profile: " + profile );
			}
		}

		/**
		 * Callback for when there is an error creating the context
		 * @param ev Error event
		 */
		private function onStage3DError( ev : ErrorEvent ) : void
		{
			callCallback( false, "Stage3D error ID: " + ev.errorID + "\n" + ev );
		}

		/**
		 * Request a context with the current profile
		 */
		private function requestContext() : void
		{
			try
			{
				// Only pass a profile when the parameter is accepted. Do this
				// dynamically so we can still compile for older versions.
				if ( stage3D.requestContext3D.length >= 2 )
				{
					stage3D.requestContext3D( renderMode, profile );
				}
				else
				{
					stage3D.requestContext3D( renderMode );
				}
			}
			catch ( err : Error )
			{
				// Failed to acquire the context. Fall back.
				fallback();
			}
		}
	}
}
