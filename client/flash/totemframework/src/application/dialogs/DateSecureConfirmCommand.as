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

	import totem.core.mvc.controller.command.AsyncCommand;
	import totem.ui.popup.PopUpManager;

	public class DateSecureConfirmCommand extends AsyncCommand
	{

		private var confirmDialog : DateSecureConfirmDialog;

		public function DateSecureConfirmCommand()
		{
			super();
		}

		override public function execute() : void
		{
			confirmDialog = new DateSecureConfirmDialog();

			confirmDialog.addEventListener( Event.CLOSE, handleCancelDialog, false, 0, true );
			confirmDialog.addEventListener( DateSecureConfirmDialog.SECURE_CONFIRM_EVENT, handleConfirmDelete, false, 0, true );

			PopUpManager.getInstance().createPopUp( confirmDialog, 0 );
		}

		protected function closeDialog() : void
		{
			PopUpManager.getInstance().removePopUp( confirmDialog, dialogClosedCallback );

		}

		protected function handleCancelDialog( event : Event ) : void
		{

			closeDialog();

			complete( false );
		}

		protected function handleConfirmDelete( event : Event ) : void
		{
			closeDialog();

			complete( true );
		}

		private function dialogClosedCallback() : void
		{
			confirmDialog.destroy();
			confirmDialog = null;

			complete( true );

		}
	}
}
