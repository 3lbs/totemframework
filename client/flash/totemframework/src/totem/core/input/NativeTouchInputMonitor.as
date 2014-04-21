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

	import flash.display.Stage;
	import flash.events.TouchEvent;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;

	import totem.core.Destroyable;
	import totem.data.type.Point2d;

	public class NativeTouchInputMonitor extends Destroyable implements IInputMonitor
	{

		private var _enabled : Boolean = true;

		private var _observers : IMobileInput;

		private var _stage : Stage;

		private var multiFinger : Boolean;

		private var touchPoint : Point2d = new Point2d();

		public function NativeTouchInputMonitor( stage : Stage )
		{
			super();

			_stage = stage;

			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;

			_stage.addEventListener( TouchEvent.TOUCH_BEGIN, handleTouch );

			_stage.addEventListener( TouchEvent.TOUCH_MOVE, handleTouch );

			_stage.addEventListener( TouchEvent.TOUCH_END, handleTouch );

		}

		override public function destroy() : void
		{
			enabled = false;

			super.destroy();
		}

		public function get enabled() : Boolean
		{
			return _enabled;
		}

		public function set enabled( value : Boolean ) : void
		{
			_enabled = value;

			if ( _enabled )
			{
				Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			}
			else
			{
				Multitouch.inputMode = MultitouchInputMode.NONE;
			}
		}

		public function subscribe( input : IMobileInput ) : void
		{
			_observers = input;
		}

		public function unSubscribe( input : IMobileInput ) : void
		{
			_observers = null;
		}

		protected function handleTouch( event : TouchEvent ) : void
		{
			// TODO Auto-generated method stub

			trace( "touch event" );
			trace( event.eventPhase );
			trace( event );

			if ( event.type == TouchEvent.TOUCH_BEGIN )
			{

				if ( event.isPrimaryTouchPoint )
				{
					multiFinger = false;
					//_observers.handleTouchBegin( event.stageX, event.stageY );
				}
				else
				{
					multiFinger = true;
				}
			}
			else if ( event.type == TouchEvent.TOUCH_MOVE )
			{
				if ( event.isPrimaryTouchPoint )
				{

					if ( multiFinger )
					{

					}
					else
					{

					}
					// do delta math?

					//_observers.handleTouchMove( event.stageX, event.stageY );
				}
				else if ( event.touchPointID == 1 )
				{
					touchPoint.x = event.stageX;
					touchPoint.y = event.stageY;
				}
			}
			else if ( event.type == TouchEvent.TOUCH_END )
			{
				if ( event.isPrimaryTouchPoint )
				{
					//_observers.handleTouchEnd( event.stageX, event.stageY );
					multiFinger = false;
					touchPoint.empty();
				}
			}

			event.stopImmediatePropagation();
		}
	}
}
