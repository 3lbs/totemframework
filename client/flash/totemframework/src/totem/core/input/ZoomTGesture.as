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

	import totem.data.type.Point2d;

	public class ZoomTGesture extends TGesture
	{

		private var _delta : int = 20;

		private var _initialDistance : Number;

		private var _scale : Number = 1;

		private var _tempTouch : Point2d = new Point2d();

		private var _touch1 : Point2d = new Point2d();

		private var _touch2 : Point2d = new Point2d();

		private var _transformVector : Point2d = new Point2d();

		private var currTransformVector : Point2d = new Point2d();

		public function ZoomTGesture()
		{
			super();
		}

		override public function reset() : void
		{
			_scale = 1;

			_initialDistance = 0;

			_tempTouch.reset();
			_touch1.reset();
			_touch2.reset();

			_transformVector.reset();

			currTransformVector.reset();

			super.reset();
		}

		override protected function onTouchBegin( touches : Vector.<Touch> ) : void
		{
			if ( _touchesCount <= 1 )
			{
				failOrIgnoreTouch( touches );
				return;
			}

			_touch1.setTo( touches[ 0 ].globalX, touches[ 0 ].globalY );

			_touch2.setTo( touches[ 1 ].globalX, touches[ 1 ].globalY );

			_transformVector.copy( _touch2 ).subBy( _touch1 );

			updateLocation( touches[ 0 ].globalX, touches[ 0 ].globalY );

			_initialDistance = _transformVector.length;

		}

		override protected function onTouchEnd( touches : Vector.<Touch> ) : void
		{

			if ( _touchesCount == 0 )
			{
				if ( state == BEGAN || state == CHANGED )
				{
					setState( ENDED );
				}
				else if ( state == POSSIBLE )
				{

					setState( FAILED );
				}
			}

			_observers.handleTouchZoom( _scale, _offsetX, _offsetY, true );

		/*else //== 1
	{
		//_tempTouch.setTo( touch.globalX, touch.globalY );

		if ( _tempTouch.equals( _touch1 ) == true )
		{
			_touch1.copy( _touch2 );
				//_touch1 = _touch2;
		}

		//_touch2 = null;

		if ( state == BEGAN || state == CHANGED )
		{
			//updateLocation( touch.globalX, touch.globalY );
			state = ENDED;
		}
	}*/
		}

		override protected function onTouchMove( touches : Vector.<Touch> ) : void
		{

			if ( _touchesCount < 2 )
				return;

			// = _touch2.location.subtract( _touch1.location );

			_touch1.setTo( touches[ 0 ].globalX, touches[ 0 ].globalY );

			_touch2.setTo( touches[ 1 ].globalX, touches[ 1 ].globalY );

			currTransformVector.copy( _touch2 ).subBy( _touch1 );

			if ( state == POSSIBLE )
			{
				var d : Number = currTransformVector.length - _initialDistance;
				//var absD : Number = d >= 0 ? d : -d;

				var abs : int = ( d + ( d >> 31 )) ^ ( d >> 31 );

				if ( abs < _delta )
				{
					// Not recognized yet
					//return;
				}

				/*if ( slop > 0 )
				{
					// adjust _transformVector to avoid initial "jump"
					const slopVector : Point = currTransformVector.clone();
					slopVector.normalize( _initialDistance + ( d >= 0 ? slop : -slop ));
					_transformVector = slopVector;
				}*/

			}

			var prevLocationX : Number;
			var prevLocationY : Number;

			prevLocationX = _location.x;
			prevLocationY = _location.y;

			updateLocation( touches[ 0 ].globalX, touches[ 0 ].globalY );

			_offsetX = prevLocationX - _location.x;
			_offsetY = prevLocationY - _location.y;

			_scale = currTransformVector.length / _transformVector.length;

			_transformVector.x = currTransformVector.x;
			_transformVector.y = currTransformVector.y;

			//updateLocation( touch.globalX, touch.globalY );

			if ( state == POSSIBLE )
			{
				setState( BEGAN );
			}
			else
			{
				setState( CHANGED );
			}

			_observers.handleTouchZoom( _scale, _offsetX, _offsetY );
		}
	}
}
