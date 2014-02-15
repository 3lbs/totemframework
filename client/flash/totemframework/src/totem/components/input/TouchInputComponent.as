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

package totem.components.input
{

	import totem.core.TotemComponent;
	import totem.core.input.InputMonitor;
	import totem.observer.NotifBroadcaster;

	public class TouchInputComponent extends TotemComponent implements IInputComponent
	{
		public static const NAME : String = "TouchInputCompoment";

		private var _broadcaster : NotifBroadcaster = new NotifBroadcaster();

		private var _controller : InputMonitor;

		private var _enabled : Boolean;

		public function TouchInputComponent( controller : InputMonitor, name : String = null )
		{
			super( NAME || name );

			this.controller = controller;
		}

		public function addController( controller : InputMonitor ) : void
		{
			controller.touchBegin.add( handleTouchBegin );
			controller.touchEnd.add( handleTouchEnd );
			controller.touchMove.add( handleTouchMove )
		}

		public function get broadcaster() : NotifBroadcaster
		{
			return _broadcaster;
		}

		public function get controller() : InputMonitor
		{
			return _controller;
		}

		public function set controller( value : InputMonitor ) : void
		{
			_controller = value;

			addController( _controller );
		}

		public function get enabled() : Boolean
		{
			return _enabled;
		}

		public function set enabled( value : Boolean ) : void
		{
			_enabled = value;

		}

		public function removeController() : void
		{
			_controller.touchBegin.remove( handleTouchBegin );
			_controller.touchEnd.remove( handleTouchMove );
			_controller.touchMove.remove( handleTouchMove );
		}

		protected function handleTouchBegin( globalX : Number, globalY : Number ) : void
		{
			trace( "stupid show" );
		}

		protected function handleTouchEnd( globalX : Number, globalY : Number ) : void
		{
			// TODO Auto Generated method stub

			trace( "anyphse" );
		}

		protected function handleTouchMove( globalX : Number, globalY : Number ) : void
		{
			// TODO Auto Generated method stub

			trace( "look at this" );
		}
	}
}
