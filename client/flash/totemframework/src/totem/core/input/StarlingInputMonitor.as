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

	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class StarlingInputMonitor extends BaseInputMonitor
	{

		private var _touchTarget : DisplayObject;

		private var longPressGesture : LongPressTGesture;

		private var panGesture : PanTGesture;

		private var touches : Vector.<Touch> = new Vector.<Touch>();

		private var zoomGesture : ZoomTGesture;

		public function StarlingInputMonitor( target : DisplayObject )
		{
			super( target );

			touchTarget = target;

			panGesture = new PanTGesture();

			zoomGesture = new ZoomTGesture();

			longPressGesture = new LongPressTGesture();
			longPressGesture.minPressDuration = 250;

			panGesture.requireGestureToFail( longPressGesture );
		}

		override public function destroy() : void
		{
			_touchTarget.removeEventListener( TouchEvent.TOUCH, _handleTouch );
			_touchTarget = null;
			super.destroy();
		}

		override public function set enabled( value : Boolean ) : void
		{
			super.enabled = value;

			if ( enabled )
			{

				if ( _touchTarget )
				{
					_touchTarget.addEventListener( TouchEvent.TOUCH, _handleTouch );
				}
			}
			else
			{
				if ( _touchTarget )
				{
					_touchTarget.removeEventListener( TouchEvent.TOUCH, _handleTouch );
				}
			}
		}

		override public function subscribe( input : IMobileInput ) : void
		{
			super.subscribe( input );

			panGesture.subscribe( input );
			zoomGesture.subscribe( input );
			longPressGesture.subscribe( input );
		}

		/**
		 * By default, the touchTarget will be set to the state's viewroot,
		 * accessible from the state like so:
		 * <pre>((view as StarlingView).viewRoot as Sprite)</pre>
		 */
		public function get touchTarget() : DisplayObject
		{
			return _touchTarget;
		}

		public function set touchTarget( s : DisplayObject ) : void
		{
			if ( s != _touchTarget )
			{
				if ( _touchTarget )
				{
					_touchTarget.removeEventListener( TouchEvent.TOUCH, _handleTouch );
				}

				s.addEventListener( TouchEvent.TOUCH, _handleTouch );
				_touchTarget = s;
				_touchTarget.touchable = true;
			}
		}

		private function _handleTouch( e : TouchEvent ) : void
		{

			if ( !_enabled )
				return;

			var t : Touch = e.getTouch( _touchTarget );

			//trace( t );

			e.touches

			touches.length = 0;

			if ( t )
			{

				// pan gesture
				// zoom gesture3

				// tap gesture

				switch ( t.phase )
				{
					case TouchPhase.BEGAN:

						e.getTouches( _touchTarget, TouchPhase.BEGAN, touches );
						longPressGesture.touchBegin( touches );
						panGesture.touchBegin( touches );
						zoomGesture.touchBegin( touches );

						e.stopImmediatePropagation();
						break;
					case TouchPhase.ENDED:

						e.getTouches( _touchTarget, TouchPhase.ENDED, touches );
						longPressGesture.touchEnd( touches );
						panGesture.touchEnd( touches );
						zoomGesture.touchEnd( touches );
						//&& !longPressGesture.complete() 
						
						// this is wrong
						
						if ( !panGesture.complete() && !zoomGesture.complete() && !longPressGesture.complete())
						{
							_observers.handleSingleTouch( t.globalX, t.globalY );
						}

						longPressGesture.reset();
						panGesture.reset();
						zoomGesture.reset();

						e.stopImmediatePropagation();
						break;

					case TouchPhase.MOVED:

						e.getTouches( _touchTarget, TouchPhase.MOVED, touches );
						longPressGesture.touchMove( touches );
						panGesture.touchMove( touches );
						zoomGesture.touchMove( touches );
						e.stopImmediatePropagation();
						break;
				}
			}
		}
	}

}
