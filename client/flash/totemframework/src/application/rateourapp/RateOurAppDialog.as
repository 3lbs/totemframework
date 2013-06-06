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

package application.rateourapp
{

	import flash.events.Event;
	import flash.events.MouseEvent;

	import localization.injectLocalize;
	import localization.localize;

	import threepounds.assets.dialogs.RateOurAppPopUp;

	import totem.display.components.MovieClipButton;
	import totem.display.layout.TSprite;
	import totem.events.UIEvent;

	public class RateOurAppDialog extends TSprite
	{

		private var acceptButton : MovieClipButton;

		private var cancelButton : MovieClipButton;

		private var neverButton : MovieClipButton;

		private var rateOurAppWindow : RateOurAppPopUp;

		public function RateOurAppDialog()
		{
			injectLocalize( this );
			initialize();
		}

		override public function destroy() : void
		{
			super.destroy();

			acceptButton.destroy();
			acceptButton = null;

			cancelButton.destroy();
			acceptButton = null;

			neverButton.destroy();
			neverButton = null;

			rateOurAppWindow = null;
			removeChildren();

		}

		protected function handleAcceptButton( event : Event ) : void
		{
			dispatchEvent( new UIEvent( UIEvent.ACCEPT, RateOurAppModel.RATE_YES ));
		}

		protected function handleCancelButton( event : Event ) : void
		{
			dispatchEvent( new UIEvent( UIEvent.ACCEPT, RateOurAppModel.RATE_NO ));
		}

		protected function handleNeverButton( event : Event ) : void
		{
			dispatchEvent( new UIEvent( UIEvent.ACCEPT, RateOurAppModel.RATE_NEVER ));
		}

		private function initialize() : void
		{
			rateOurAppWindow = new RateOurAppPopUp();

			acceptButton = new MovieClipButton( rateOurAppWindow.AcceptButton );
			acceptButton.addEventListener( MouseEvent.CLICK, handleAcceptButton );
			acceptButton.setText( localize( "AppGame", "rateit.ACCEPT_BUTTON" ));

			cancelButton = new MovieClipButton( rateOurAppWindow.CancelButton );
			cancelButton.addEventListener( MouseEvent.CLICK, handleCancelButton );
			cancelButton.setText( localize( "AppGame", "rateit.CANCEL_BUTTON" ));

			neverButton = new MovieClipButton( rateOurAppWindow.NeverButton );
			neverButton.addEventListener( MouseEvent.CLICK, handleNeverButton );
			neverButton.setText( localize( "AppGame", "rateit.NEVER_BUTTON" ));

			rateOurAppWindow.Body.htmlText = localize( "AppGame", "rateit.BODY_TEXT" );
			addChild( rateOurAppWindow );
		}
	}
}
