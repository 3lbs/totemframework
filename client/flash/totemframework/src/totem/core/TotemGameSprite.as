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

package totem.core
{

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.StageOrientationEvent;
	import flash.events.UncaughtErrorEvent;
	
	import ladydebug.Logger;
	
	import org.casalib.util.StageReference;
	
	import totem.core.mvc.TotemContext;

	[SWF( frameRate = "60" )]
	public class TotemGameSprite extends Sprite
	{

		protected var context : TotemContext;

		public function TotemGameSprite()
		{
			super();
			addEventListener( Event.ADDED_TO_STAGE, handleAddToStage, false, 0, true );
			addEventListener( Event.RESIZE, handleResizeEvent );
			addEventListener( StageOrientationEvent.ORIENTATION_CHANGE, handleStageChange );

			// to make sure the stage is of size and ready.  might have to to go to a Delay or wait function
			addEventListener( Event.ENTER_FRAME, handleFirstEnterFrame );
			//trace( Capabilities.screenResolutionX, Capabilities.screenResolutionY )
		}
		
		private function handleFirstEnterFrame(event:Event):void
		{
			removeEventListener( Event.ENTER_FRAME, handleFirstEnterFrame );
			initialization();
		}
		
		protected function initialization () : void
		{
		}

		protected function handleAddToStage( event : Event ) : void
		{
			removeEventListener( Event.ADDED_TO_STAGE, handleAddToStage );

			loaderInfo.uncaughtErrorEvents.addEventListener( UncaughtErrorEvent.UNCAUGHT_ERROR, uncaughtErrorHandler );

			StageReference.setStage( this.stage );
			
			// do some init pause just for the many devices and might not be ready
		}

		protected function handleResizeEvent( event : Event ) : void
		{
		}

		protected function handleStageChange( event : Event ) : void
		{
			
		}

		private function uncaughtErrorHandler( e : UncaughtErrorEvent ) : void
		{
			trace( "Global error:", e.error );
			Logger.error( e.target, "uncaughtErrorhandler", e.error + ", " + e.text );
		}
	}
}

