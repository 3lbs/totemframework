package totem.patterns.mvc.totembundle
{
	import air.update.ApplicationUpdaterUI;
	import air.update.events.StatusUpdateErrorEvent;
	import air.update.events.StatusUpdateEvent;
	import air.update.events.UpdateEvent;
	
	import flash.events.ErrorEvent;
	
	import mx.controls.Alert;
	
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IExtension;
	
	import totem.patterns.mvc.DetainMapExtension;
	
	public class TotemBundle implements IExtension
	{
		protected var appUpdater : ApplicationUpdaterUI = new ApplicationUpdaterUI(); // Used for auto-updat

		
		public function TotemBundle()
		{
		}
		
		public function extend(context:IContext):void
		{
			context.extend(
				DetainMapExtension );
			
			
	/*		appUpdater.updateURL = "http://3lbs.s3.amazonaws.com/cms/model3dviewer/update.xml";
			appUpdater.addEventListener( UpdateEvent.INITIALIZED, onUpdate );
			appUpdater.addEventListener( ErrorEvent.ERROR, onUpdaterError );
			appUpdater.addEventListener( StatusUpdateErrorEvent.UPDATE_ERROR, onUpdateStatusError );
			appUpdater.addEventListener( StatusUpdateEvent.UPDATE_STATUS, handleUpdateStatusComplete );
			// Hide the dialog asking for permission for checking for a new update.
			// If you want to see it just leave the default value (or set true).
			//appUpdater.isCheckForUpdateVisible = false;
			appUpdater.initialize();*/
				
		}
		
		private function onUpdateStatusError( event : StatusUpdateErrorEvent ) : void
		{
			Alert.show( 'Error Checking For Update: ' + event.toString());
		}
		
		
		protected function onUpdate( event : UpdateEvent ) : void
		{
			appUpdater.checkNow();
		}
		
		protected function onUpdaterError( event : ErrorEvent ) : void
		{
			Alert.show( 'Error Checking For Update: ' + event.toString());
			//initApplication();
		}
		
		protected function handleUpdateStatusComplete( event : UpdateEvent ) : void
		{
			//initApplication();
			
		}
	}
}