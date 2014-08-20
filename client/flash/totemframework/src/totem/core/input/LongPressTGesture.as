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

	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import starling.events.Touch;

	public class LongPressTGesture extends TGesture
	{

		public var minPressDuration : uint = 500;

		public var numTouchesRequired : uint = 1;

		public var slop : Number = DEFAULT_SLOP;

		private var _numTouchesRequiredReached : Boolean;

		private var _timer : Object;

		public function LongPressTGesture()
		{
			super();

			_timer = new Timer( minPressDuration, 1 );
			_timer.addEventListener( TimerEvent.TIMER_COMPLETE, timer_timerCompleteHandler );
		}

		override protected function onTouchBegin( touches : Vector.<Touch> ) : void
		{
			if ( _touchesCount > numTouchesRequired )
			{
				failOrIgnoreTouch( touches );
				return;
			}

			if ( _touchesCount == numTouchesRequired )
			{
				var touch : Touch = touches[ 0 ];
				
				updateLocation( touches[ 0 ].globalX, touches[ 0 ].globalY );
				
				_numTouchesRequiredReached = true;
				_timer.reset();
				_timer.delay = minPressDuration || 1;
				_timer.start();
			}
		}

		override protected function onTouchEnd( touches : Vector.<Touch> ) : void
		{
			if (_numTouchesRequiredReached)
			{
				if (state == BEGAN || state == CHANGED)
				{
					updateLocation( _location.x, _location.y );
					_observers.handleLongPress( _offsetX, _offsetY, true );
					setState(ENDED);
				}
				else
				{
					setState(FAILED);
				}
			}
			else
			{
				setState(FAILED);
			}
			
		}

		
		override public function reset():void
		{
			super.reset();
			
			_numTouchesRequiredReached = false;
			_timer.reset();
		}
		
		
		override protected function onTouchMove( touches : Vector.<Touch> ) : void
		{

			if ( _touchesCount != 1 )
				return;

			var touch : Touch = touches[ 0 ];

//&& touch.locationOffset.length > slop 
			if ( state == POSSIBLE && slop > 0 )
			{
				setState( FAILED );
			}
			else if ( state == BEGAN || state == CHANGED )
			{
				updateLocation( touch.globalX, touch.globalY );
				_observers.handleLongPress( _location.x, _location.y );
				setState( CHANGED );
			}
		}

		protected function timer_timerCompleteHandler( event : TimerEvent = null ) : void
		{

			if ( state == POSSIBLE )
			{
				_observers.handleLongPress( _location.x, _location.y );
				setState( BEGAN );
			}
		}
	}
}
