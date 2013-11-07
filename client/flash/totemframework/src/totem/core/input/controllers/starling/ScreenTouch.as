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

package totem.core.input.controllers.starling
{

	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	import totem.core.input.InputController;

	/**
	 * ScreenTouch is a small InputController to get a starling touch into the input system :
	 * the common use case is if you want your hero to react on the touch of a screen and handle that
	 * in the hero's update loop without having to change your code, for example having ScreenTouch with
	 * "jump" for touchAction, let's you touch the touchTarget(the state by default) and make your Hero jump
	 * with no changes to Hero's code as it will respond to justDid("jump").
	 */
	public class ScreenTouch extends InputController
	{
		/**
		 * touch action is the action triggered on touch, it is jump by default.
		 */
		public var touchAction : String = "jump";

		protected var _touchTarget : DisplayObject;

		public function ScreenTouch( name : String, touchTarget : Sprite, params : Object = null )
		{
			super( name, params );

			//if ( !_touchTarget )
				///_touchTarget = (( _ce.state.view as StarlingView ).viewRoot as Sprite );

			_touchTarget = touchTarget;
		
			_touchTarget.addEventListener( TouchEvent.TOUCH, _handleTouch );
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
						triggerCHANGE( touchAction, 1, null, defaultChannel );
						e.stopImmediatePropagation();
						break;
					case TouchPhase.ENDED:
						triggerOFF( touchAction, 0, null, defaultChannel );
						e.stopImmediatePropagation();
						break;
				}
			}
		}
	}

}
