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

package totem.display.scenes
{

	import totem.display.layout.ScreenComposite;

	public class BaseLoadingScreen extends ScreenComposite
	{
		protected var nextScene : ISceneState;

		public function BaseLoadingScreen()
		{
			super();
		}

		public function addLoadingScene( nextSceneState : ISceneState ) : void
		{
			nextScene = nextSceneState;
		}

		override public function destroy() : void
		{
			super.destroy();
			removeLoadingScreen();
		}

		public function finished() : void
		{
			removeLoadingScreen();
		}

		public function play() : void
		{

		}

		private function removeLoadingScreen() : void
		{
			nextScene = null;
		}
	}
}
