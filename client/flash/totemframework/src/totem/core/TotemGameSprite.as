package totem.core
{

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.UncaughtErrorEvent;
	
	import ladydebug.Logger;
	
	import org.casalib.util.StageReference;
	
	import totem.core.mvc.TotemContext;

	[SWF( frameRate = "60" )]
	public class TotemGameSprite extends Sprite
	{

		public static var STAGE_HEIGHT : Number = 0;
		
		public static var STAGE_WIDTH : Number = 0;
		
		public static var LOCAL_PLAY : Boolean = false;

		protected var context : TotemContext;

		public function TotemGameSprite()
		{
			super();
			addEventListener( Event.ADDED_TO_STAGE, handleAddToStage, false, 0, true );
		}

		protected function handleAddToStage( event : Event ) : void
		{
			removeEventListener( Event.ADDED_TO_STAGE, handleAddToStage );

			loaderInfo.uncaughtErrorEvents.addEventListener( UncaughtErrorEvent.UNCAUGHT_ERROR, uncaughtErrorHandler );

			StageReference.setStage( this.stage );
		}

		private function uncaughtErrorHandler( e : UncaughtErrorEvent ) : void
		{
			trace( "Global error:", e.error );
			
			Logger.error( e.target, "uncaughtErrorhandler", e.error + ", " + e.text );
			
	
		}

	}
}

