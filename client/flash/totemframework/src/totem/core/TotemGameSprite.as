package totem.core
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import org.swiftsuspenders.Injector;
	
	import robotlegs.bender.framework.api.IContext;
	
	[SWF(frameRate="32",wmode="direct")]
	public class TotemGameSprite extends Sprite
	{
		
		public static var LOCAL_PLAY : Boolean = false;
		
		protected var context : IContext;
		
		public function TotemGameSprite()
		{
			super ();
			addEventListener ( Event.ADDED_TO_STAGE, handleAddToStage, false, 0, true );
		}
		
		protected function handleAddToStage( event : Event ) : void
		{
			removeEventListener ( Event.ADDED_TO_STAGE, handleAddToStage );
			
			if ( this.parent == this.stage )
			{
				TotemGameSprite.LOCAL_PLAY = true;
				parentInjector = null;
			}
		}
		
		/**
		 * We need to initialize our context by setting the parent
		 * injector for the module. This is actually injected by the
		 * shell, so no need to worry about it!
		 */
		[Inject]
		public function set parentInjector( value : Injector ) : void
		{
			throw new Error("This needs to be overriden");
		}
	
	}
}

