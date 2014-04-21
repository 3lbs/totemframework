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

package totem.core.input
{

	import starling.events.Touch;

	import totem.core.Destroyable;
	import totem.data.type.Point2d;

	public class TGesture extends Destroyable
	{

		public static const BEGAN : int = 2;

		public static const CANCELED : int = 4;

		public static const CHANGED : int = 5;

		public static const ENDED : int = 3;

		public static const FAILED : int = 1;

		public static const POSSIBLE : int = 0;

		protected var _location : Point2d = new Point2d();

		protected var _observers : IMobileInput;

		protected var _offsetX : Number = 0;

		protected var _offsetY : Number = 0;

		protected var _touchesCount : int = 0;

		protected var state : int;

		public function TGesture()
		{
			super();
		}

		public function complete() : Boolean
		{
			return state != FAILED;
		}

		public function reset() : void
		{
			_touchesCount = 0;

			_offsetX = 0;
			_offsetY = 0;

			state = POSSIBLE;
		}

		public function subscribe( input : IMobileInput ) : void
		{
			_observers = input;
		}

		public function unSubscribe( input : IMobileInput ) : void
		{
			_observers = null;
		}

		protected function failOrIgnoreTouch( touch : Vector.<Touch> ) : void
		{
			if ( state == POSSIBLE )
			{
				state = FAILED;
			}
		}


		protected function onTouchBegin( touch : Vector.<Touch> ) : void
		{

		}

		protected function onTouchEnd( touch : Vector.<Touch> ) : void
		{

		}

		protected function onTouchMove( touch : Vector.<Touch> ) : void
		{

		}

		protected function updateLocation( x : Number, y : Number ) : void
		{
			_location.x = x;
			_location.y = y;
		}

		internal function touchBegin( touches : Vector.<Touch> ) : void
		{

			if ( state == ENDED || state == FAILED )
			{
			}
				reset();

			_touchesCount = touches.length;

			onTouchBegin( touches );
		}

		internal function touchEnd( touches : Vector.<Touch> ) : void
		{
			_touchesCount = touches.length;

			onTouchEnd( touches );
		}

		internal function touchMove( touches : Vector.<Touch> ) : void
		{

			_touchesCount = touches.length;
			
			onTouchMove( touches );
		}
	}
}
