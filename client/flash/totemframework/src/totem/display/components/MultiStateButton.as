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

package totem.display.components
{

	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	
	import totem.utils.DestroyUtil;

	public class MultiStateButton extends MovieClipButton implements IButton
	{
		private var _currentState : ButtonState;

		private var _selected : Boolean;

		private var states : Dictionary = new Dictionary();

		public function MultiStateButton( mc : MovieClip )
		{
			super( mc );
		}

		override public function destroy():void
		{
			super.destroy();
			DestroyUtil.destroyDictionary( states );
			states = null;
		}
		
		public function addState( state : ButtonState ) : void
		{
			states[ state.name ] = state;
		}

		public function getCurrentState() : ButtonState
		{
			return _currentState;
		}

		public function get selected() : Boolean
		{
			return _selected;
		}
		
		override public function get data () : Object
		{
			if ( _currentState && _currentState.data )
			{
				return _currentState.data;
			}
			
			return super.data;
		}
		
		public function set selected( value : Boolean ) : void
		{
			_selected = value;
		}

		public function setState( name : String ) : void
		{
			if ( states[ name ])
			{
				_currentState = states[ name ];

				UP_STATE_FRAME = _currentState.UP_STATE_FRAME;
				DOWN_STATE_FRAME = _currentState.DOWN_STATE_FRAME;
				OVER_STATE_FRAME = _currentState.OVER_STATE_FRAME;
				
				resetContent();
			}
		}

		public function get stateName() : String
		{
			return _currentState ? _currentState.name : "";
		}
	}
}
