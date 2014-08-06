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

package totem.display.scenes
{

	import flash.events.Event;
	
	import totem.core.task.util.ILoadTask;
	import totem.display.layout.ScreenComposite;

	public class BaseLoadingScreen extends ScreenComposite implements ILoadTask
	{
		protected static const COMPLETE : int = 2;

		protected static const EMPTY : int = 0;

		protected static const LOADING : int = 1;

		protected var _status : int = EMPTY;

		private var _displayContent : Boolean;

		public function BaseLoadingScreen()
		{
			super();
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

			_status = EMPTY;
		}

		public function isComplete() : Boolean
		{
			return _status == COMPLETE;
		}

		public function load() : void
		{
			if ( _status == COMPLETE )
			{
				onComplete();
			}
			else
			{
				_status == LOADING;
			}
		}

		public function play() : void
		{
		}

		public function get status() : Number
		{
			return _status;
		}

		public function unloadData() : void
		{
			_status = EMPTY;
		}

		protected function onComplete() : void
		{
			_status = COMPLETE;
			dispatchEvent( new Event( Event.COMPLETE ));
		}

		protected function removeLoadingScreen() : void
		{
		}
	}
}
