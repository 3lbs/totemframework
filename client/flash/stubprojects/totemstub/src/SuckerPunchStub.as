//------------------------------------------------------------------------------
//
//   Copyright 2011 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package
{
	import totemgamename.core.GameStubContext;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 *
	 * @author eddie
	 */
	public class SuckerPunchStub extends Sprite
	{
		
		/**
		 *
		 */
		public function SuckerPunchStub()
		{
			if ( stage )
			{
				initialize();
			}
			else
			{			
				addEventListener( Event.ADDED_TO_STAGE, initialize, false, 0, true );		
			}
		}
		
		private var gameContext : GameStubContext;
		
		protected function initialize( eve : Event = null ) : void
		{
			if ( hasEventListener( Event.ADDED_TO_STAGE ) )
				removeEventListener( Event.ADDED_TO_STAGE, initialize );
			
			gameContext = new GameStubContext ();
		}
	}
}


