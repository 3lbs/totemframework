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

	import flash.system.Capabilities;
	import flash.utils.Dictionary;
	
	import starling.events.Touch;
	
	import totem.core.Destroyable;
	import totem.data.type.Point2d;

	public class TGesture extends Destroyable
	{

		public static const BEGAN : int = 2;

		public static const CANCELED : int = 4;

		public static const CHANGED : int = 5;

		public static var DEFAULT_SLOP : uint = Math.round( 20 / 252 * flash.system.Capabilities.screenDPI );

		public static const ENDED : int = 3;

		public static const FAILED : int = 1;

		public static const POSSIBLE : int = 0;

		protected var _gesturesToFail : Dictionary = new Dictionary( true );

		protected var _location : Point2d = new Point2d();

		protected var _observers : IMobileInput;

		protected var _offsetX : Number = 0;

		protected var _offsetY : Number = 0;

		protected var _touchesCount : int = 0;

		private var _state : int = POSSIBLE;

		public function TGesture()
		{
			super();
		}

		public function complete() : Boolean
		{
			return _state != FAILED;
		}

		override public function destroy() : void
		{
			_gesturesToFail = null;
		}

		public function requireGestureToFail( gesture : TGesture ) : void
		{
			_gesturesToFail[ gesture ] = true;
		}

		public function reset() : void
		{
			_touchesCount = 0;

			_offsetX = 0;
			_offsetY = 0;
			
			_location.reset();
			
/*
			if ( state == POSSIBLE )
			{
				// manual reset() call. Set to FAILED to keep our State Machine clean and stable
				setState( FAILED );
			}
			else if ( state == BEGAN || state == CHANGED )
			{
				// manual reset() call. Set to CANCELLED to keep our State Machine clean and stable
				setState( CANCELED );
			}
			else
			{
				// reset from GesturesManager after reaching one of the 4 final states:
				// (state == GestureState.RECOGNIZED ||
				// state == GestureState.ENDED ||
				// state == GestureState.FAILED ||
				// state == GestureState.CANCELLED)
			}*/
			setState( POSSIBLE );

			//_state = POSSIBLE;
		}

		public function get state() : int
		{
			return _state;
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
				_state = FAILED;
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

		protected function setState( newState : int ) : Boolean
		{
			if ( _state == newState && _state == CHANGED )
			{
				return true;
			}

			if ( newState == BEGAN )
			{
				var gestureToFail : TGesture;
				var key : *;

				// first we check if other required-to-fail gestures recognized
				// TODO: is this really necessary? using "requireGestureToFail" API assume that
				// required-to-fail gesture always recognizes AFTER this one.
				for ( key in _gesturesToFail )
				{
					gestureToFail = key as TGesture;

					if ( gestureToFail.state != POSSIBLE && gestureToFail.state != FAILED )
					{
						// Looks like other gesture won't fail,
						// which means the required condition will not happen, so we must fail
						setState( FAILED );
						return false;
					}
				}

			}

			_state = newState;

			return true;
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
