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

	public class PanTGesture extends TGesture
	{
		private var _dragDelta : int = 150;

		public function PanTGesture()
		{
			super();
		}

		override protected function onTouchBegin( touches : Vector.<Touch> ) : void
		{
			if ( _touchesCount > 1 )
			{
				failOrIgnoreTouch( touches );
				return;
			}

			if ( _touchesCount >= 1 )
			{
				updateLocation( touches[ 0 ].globalX, touches[ 0 ].globalY );
			}
		}

		override protected function onTouchEnd( touches : Vector.<Touch> ) : void
		{
			if ( state == FAILED )
			{
				return;
			}
			else if ( state == POSSIBLE )
			{
				setState( FAILED );
			}
			else
			{
				setState(  ENDED );

				_observers.handlePan( _offsetX, _offsetY, true );
			}

		}

		override protected function onTouchMove( touches : Vector.<Touch> ) : void
		{
			if ( _touchesCount != 1 )
				return;

			var prevLocationX : Number;
			var prevLocationY : Number;

			var touch : Touch = touches[ 0 ];

			if ( state == POSSIBLE )
			{
				prevLocationX = _location.x;
				prevLocationY = _location.y;

				updateLocation( touch.globalX, touch.globalY );

				// Check if finger moved enough for gesture to be recognized

				var _dx : Number = prevLocationX - _location.x;
				var _dy : Number = prevLocationY - _location.y;

				var d : int = ( _dx * _dx + _dy * _dy );

				if (( d > _dragDelta ))
				{
					_offsetX = _dx;
					_offsetY = _dy;

					setState( BEGAN );
				}
			}
			else if ( state == BEGAN || state == CHANGED )
			{
				prevLocationX = _location.x;
				prevLocationY = _location.y;

				updateLocation( touch.globalX, touch.globalY );

				_offsetX = prevLocationX - _location.x;
				_offsetY = prevLocationY - _location.y;

				setState( CHANGED );
			}

			if ( state == BEGAN || state == CHANGED )
			{
				_observers.handlePan( _offsetX, _offsetY );
			}
		}
	}
}
