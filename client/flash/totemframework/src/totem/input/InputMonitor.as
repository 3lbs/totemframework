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

package totem.input
{

	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	import totem.core.Destroyable;

	public class InputMonitor extends Destroyable
	{

		public var touchBegin : ISignal = new Signal( Number, Number );

		public var touchEnd : ISignal = new Signal( Number, Number )

		public var touchMove : ISignal = new Signal( Number, Number );

		private var _touchTarget : DisplayObject;

		public function InputMonitor( target : DisplayObject )
		{
			super();

			touchTarget = target;
		}

		override public function destroy() : void
		{
			_touchTarget.removeEventListener( TouchEvent.TOUCH, _handleTouch );
			_touchTarget = null;
			super.destroy();
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
					_touchTarget.removeEventListener( TouchEvent.TOUCH, _handleTouch );

				s.addEventListener( TouchEvent.TOUCH, _handleTouch );
				_touchTarget = s;
			}
		}

		private function _handleTouch( e : TouchEvent ) : void
		{
			var t : Touch = e.getTouch( _touchTarget );

			if ( t )
			{
				switch ( t.phase )
				{
					case TouchPhase.BEGAN:

						//triggerCHANGE(touchAction, 1, null, defaultChannel);
						touchBegin.dispatch( t.globalX, t.globalY );
						e.stopImmediatePropagation();
						break;
					case TouchPhase.ENDED:
						//triggerOFF(touchAction, 0, null, defaultChannel);
						touchEnd.dispatch( t.globalX, t.globalY );
						e.stopImmediatePropagation();
						break;

					case TouchPhase.MOVED:

						touchMove.dispatch( t.globalX, t.globalY );
						e.stopImmediatePropagation();
						break;
				}
			}
		}
	}

}
