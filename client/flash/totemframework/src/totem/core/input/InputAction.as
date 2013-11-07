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

package totem.core.input
{

	/**
	 * InputAction reinforces the Action object structure (and typing.)
	 * it contains static action phase constants as well as helpful comparators.
	 */
	public class InputAction
	{

		// ------------ InputAction Pooling

		/**
		 * list of disposed InputActions. automatically disposed when they end in Input.as
		 */
		internal static var disposed : Vector.<InputAction> = new Vector.<InputAction>();

		/**
		 * clear the list of disposed InputActions.
		 */
		public static function clearDisposed() : void
		{
			disposed.length = 0;
		}

		/**
		 * creates an InputAction either from a disposed InputAction object or a new one.
		 */
		public static function create( name : String, controller : InputController, channel : uint = 0, value : Number = 0, message : String = null, phase : uint = 0, time : uint = 0 ) : InputAction
		{
			if ( disposed.length > 0 )
				return disposed.pop().setTo( name, controller, channel, value, message, phase, time );
			else
				return new InputAction( name, controller, channel, value, message, phase, time );
		}

		internal var _message : String;

		internal var _phase : uint;

		internal var _value : Number;

		private var _channel : uint;

		private var _controller : InputController;

		//read only action keys
		private var _name : String;

		private var _time : uint = 0;

		public function InputAction( name : String, controller : InputController, channel : uint = 0, value : Number = 0, message : String = null, phase : uint = 0, time : uint = 0 )
		{
			_name = name;
			_controller = controller;
			_channel = channel;

			_value = value;
			_message = message;
			_phase = phase;
			_time = time;
		}

		/**
		 * action channel id.
		 */
		public function get channel() : uint
		{
			return _channel;
		}

		/**
		 * Clones the action and returns a new InputAction instance with the same properties.
		 */
		public function clone() : InputAction
		{
			return InputAction.create( _name, _controller, _channel, _value, _message, _phase, _time );
		}

		/**
		 * comp is used to compare an action with another action without caring about which controller
		 * the actions came from. it is the most common form of action comparison.
		 */
		public function comp( action : InputAction ) : Boolean
		{
			return _name == action.name && _channel == action.channel;
		}

		/**
		 * InputController that triggered this action
		 */
		public function get controller() : InputController
		{
			return _controller;
		}

		public function dispose() : void
		{
			_controller = null;

			var a : InputAction;

			for each ( a in disposed )
				if ( this == a )
					return;

			disposed.push( this );
		}

		/**
		 * eq is almost a strict action comparator. It will not only compare names and channels
		 * but also which controller the actions came from.
		 */
		public function eq( action : InputAction ) : Boolean
		{
			return _name == action.name && _controller == action.controller && _channel == action.channel;
		}

		/**
		 * message the action carries
		 */
		public function get message() : String
		{
			return _message;
		}

		public function get name() : String
		{
			return _name;
		}

		/**
		 * action phase
		 */
		public function get phase() : Number
		{
			return _phase;
		}

		/**
		 * time (in frames) the action has been 'running' in the Input system.
		 */
		public function get time() : uint
		{
			return _time;
		}

		public function toString() : String
		{
			return "\n[ Action # name: " + _name + " channel: " + _channel + " value: " + _value + " phase: " + _phase + " controller: " + _controller + " time: " + _time + " ]";
		}

		/**
		 * value the action carries
		 */
		public function get value() : Number
		{
			return _value;
		}

		/**
		 * internal utiliy to keep public time read only
		 */
		internal function get itime() : uint
		{
			return _time;
		}

		internal function set itime( val : uint ) : void
		{
			_time = val;
		}

		/**
		 * set all InputActions's properties (internal for recycling)
		 */
		internal function setTo( name : String, controller : InputController, channel : uint = 0, value : Number = 0, message : String = null, phase : uint = 0, time : uint = 0 ) : InputAction
		{
			_name = name;
			_controller = controller;
			_channel = channel;
			_value = value;
			_message = message;
			_phase = phase;
			_time = time;
			return this;
		}
	}

}
