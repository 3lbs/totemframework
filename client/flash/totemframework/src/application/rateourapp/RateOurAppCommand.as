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

	import totem.core.mvc.controller.command.AsyncCommand;
	import totem.events.UIEvent;
	import totem.ui.popup.PopUpManager;
	import totem.ui.popup.ScalePopupTransition;

	public class RateOurAppCommand extends AsyncCommand
	{

		[Inject]
		public var rateAppModel : RateOurAppModel;

		private var rateOurAppDialog : RateOurAppDialog;

		public function RateOurAppCommand()
		{
			super();
		}

		override public function execute() : void
		{

			if ( rateAppModel.canRateOurApp())
			{
				// open dialog
				rateOurAppDialog = new RateOurAppDialog();
				rateOurAppDialog.addEventListener( UIEvent.ACCEPT, handleRateApp );
				rateOurAppDialog.addEventListener( UIEvent.CANCEL, handleRateApp );

				PopUpManager.getInstance().createPopUp( rateOurAppDialog, 0, new ScalePopupTransition( rateOurAppDialog ));
			}
			else
			{
				complete();
			}
		}

		private function handleRateApp( event : UIEvent ) : void
		{
			var choice : int = event.data as int;

			PopUpManager.getInstance().removePopUp( rateOurAppDialog );
			rateOurAppDialog = null;

			if ( rateAppModel.userRateChoice( choice ))
			{
				rateAppModel.openRatePage( "123456789" );
			}

			complete();
		}
	}
}
