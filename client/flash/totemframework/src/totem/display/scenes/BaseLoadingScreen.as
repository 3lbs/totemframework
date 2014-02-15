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
		private var _displayContent : Boolean;

		public function BaseLoadingScreen()
		{
			super();
		}

		public function clearScreen() : void
		{
			removeLoadingScreen();
		}

		override public function destroy() : void
		{
			super.destroy();
			removeLoadingScreen();
		}

		public function set displayContent( value : Boolean ) : void
		{
			_displayContent = value;

		}

		public function finished() : void
		{
			removeLoadingScreen();
		}

		public function play() : void
		{

		}

		protected function removeLoadingScreen() : void
		{
		}
	}
}
