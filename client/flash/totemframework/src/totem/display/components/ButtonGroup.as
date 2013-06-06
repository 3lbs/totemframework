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

	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	import totem.events.RemovableEventDispatcher;

	public class ButtonGroup extends RemovableEventDispatcher
	{

		private var _currentSelectButton : IButton;

		private var buttonGroup : Vector.<IButton> = new Vector.<IButton>();

		public function ButtonGroup( target : IEventDispatcher = null )
		{
			super( target );
		}

		public function addButton( button : IButton ) : IButton
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

		public function getButton( value : String ) : IButton
		{
			var i : int;

			for ( i = 0; i < buttonGroup.length; ++i )
			{
				if ( buttonGroup[ i ].name == value )
					return buttonGroup[ i ];
			}

			return null;
		}

		public function getButtonData( value : Object ) : IButton
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
			var button : IButton = getButtonData( value );
			setButtonState( button );
		}

		public function selectByName( value : String ) : void
		{
			var toggleButton : IButton = getButton( value );
			setButtonState( toggleButton );
		}

		private function handleButtonTrigged( eve : MouseEvent ) : void
		{
			if ( eve.target == _currentSelectButton )
				return;

			_currentSelectButton = eve.target as IButton;
			setButtonState( _currentSelectButton );
			
			dispatchEvent( new ButtonEvent( ButtonEvent.TRIGGERED, _currentSelectButton.data ));
		}

		private function setButtonState( button : IButton ) : void
		{
			var i : int;
			_currentSelectButton = button;

			for ( i = 0; i < buttonGroup.length; ++i )
			{
				buttonGroup[ i ].selected = ( buttonGroup[ i ] === button ) ? true : false;
			}
			
		}
	}
}
