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

package totem.display.components.togglebutton
{

	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	import totem.events.RemovableEventDispatcher;

	public class ToggleButtonGroup extends RemovableEventDispatcher
	{

		private var _currentSelectButton : IToggleButton;

		private var buttonGroup : Vector.<IToggleButton> = new Vector.<IToggleButton>();

		public function ToggleButtonGroup( target : IEventDispatcher = null )
		{
			super( target );
		}

		public function addToggleButton( button : IToggleButton ) : IToggleButton
		{
			buttonGroup.push( button );
			button.addEventListener( MouseEvent.CLICK, handleButtonTrigged );
			
			return button;
		}

		public function get data() : Object
		{
			return ( _currentSelectButton ) ? _currentSelectButton.data : null;
		}

		override public function destroy() : void
		{
			super.destroy();

			while ( buttonGroup.length > 0 )
				buttonGroup.pop().destroy();

			_currentSelectButton = null;
		}

		public function getToggleButton( value : String ) : IToggleButton
		{
			var i : int;

			for ( i = 0; i < buttonGroup.length; ++i )
			{
				if ( buttonGroup[ i ].name == value )
					return buttonGroup[ i ];
			}

			return null;
		}

		public function getToggleButtonData( value : Object ) : IToggleButton
		{
			var i : int;

			for ( i = 0; i < buttonGroup.length; ++i )
			{
				if ( buttonGroup[ i ].data == value )
					return buttonGroup[ i ];
			}

			return null;
		}

		public function selectByData( value : Object ) : void
		{
			var toggleButton : IToggleButton = getToggleButtonData( value );
			setButtonState( toggleButton );
		}

		public function selectByName( value : String ) : void
		{
			var toggleButton : IToggleButton = getToggleButton( value );
			setButtonState( toggleButton );
		}

		private function handleButtonTrigged( eve : MouseEvent ) : void
		{
			if ( eve.target == _currentSelectButton )
				return;

			_currentSelectButton = eve.target as IToggleButton;
			setButtonState( _currentSelectButton );
			dispatchEvent( new ToggleButtonEvent( ToggleButtonEvent.TRIGGERED, _currentSelectButton.data ));
		}

		private function setButtonState( button : IToggleButton ) : void
		{
			var i : int;

			for ( i = 0; i < buttonGroup.length; ++i )
			{
				buttonGroup[ i ].selected = ( buttonGroup[ i ] === button ) ? true : false;
			}
		}
	}
}
