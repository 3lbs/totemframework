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

package application.dialogs
{

	import flash.events.Event;
	import flash.events.MouseEvent;

	import threepounds.assets.dialogs.DateSecureConfirmPanel;

	import totem.display.components.MovieClipButton;
	import totem.ui.popup.BaseDialog;

	public class DateSecureConfirmDialog extends BaseDialog
	{
		public static const SECURE_CONFIRM_EVENT : String = "DateSecureConfirmDialog:Confirm";

		private var _attempts : int;

		private var _input : String = "";

		private var buttonList : Vector.<MovieClipButton> = new Vector.<MovieClipButton>();

		private var secureConfirmPanel : DateSecureConfirmPanel;

		public function DateSecureConfirmDialog()
		{
			super();
		}

		override public function destroy() : void
		{
			while ( buttonList.length )
				buttonList.pop().destroy();

			buttonList = null;

			super.destroy();
		}

		protected function handleAccpetButton( event : MouseEvent ) : void
		{

			trace( _input );
			
			var dateObj : Date = new Date();

			if ( dateObj.date.toString() == _input )
			{
				dispatchEvent( new Event( SECURE_CONFIRM_EVENT ));
				return;
			}

			_input = "";
			secureConfirmPanel.inputDisplay.htmlText = _input;

			_attempts++;

			if ( _attempts >= 3 )
			{
				dispatchEvent( new Event( Event.CLOSE ));

			}
		}

		protected function handleCancelButton( event : Event ) : void
		{
			dispatchEvent( new Event( Event.CLOSE ));
		}

		protected function handleNumberEntry( event : Event ) : void
		{
			
			if ( _input.length < 2 )
			{
				var num : MovieClipButton = event.target as MovieClipButton;
				_input += num.data;

				secureConfirmPanel.inputDisplay.htmlText = _input;
			}
			trace( _input );
		}

		override protected function initialize() : void
		{
			super.initialize();

			secureConfirmPanel = new DateSecureConfirmPanel();

			var acceptButton : MovieClipButton = new MovieClipButton( secureConfirmPanel.acceptButton );
			acceptButton.addEventListener( MouseEvent.CLICK, handleAccpetButton, false, 0, true );
			buttonList.push( acceptButton );

			var cancelButton : MovieClipButton = new MovieClipButton( secureConfirmPanel.CancelButton );
			cancelButton.addEventListener( MouseEvent.CLICK, handleCancelButton, false, 0, true );
			buttonList.push( cancelButton );

			secureConfirmPanel.inputDisplay.htmlText = _input;

			for ( var i : int = 0; i < 10; ++i )
			{
				var numbutton : MovieClipButton = new MovieClipButton( secureConfirmPanel[ "np" + i ]);

				numbutton.addEventListener( MouseEvent.CLICK, handleNumberEntry, false, 0, true );
				numbutton.data = i;
				numbutton.setText( String( i ));

				buttonList.push( numbutton );
			}

			addChild( secureConfirmPanel );

		}
	}
}
