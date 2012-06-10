package totem.startup.startupmanager.events
{
	import flash.events.Event;
	
	public class StartupEvent extends Event
	{
		
		/**
		 *  StartupManager core: Notifications to Client App
		 */
		public static const LOADING_PROGRESS :String = "smLoadingProgress";
		public static const LOADING_COMPLETE :String = "smLoadingComplete";
		public static const LOADING_FINISHED_INCOMPLETE :String = "smLoadingFinishedIncomplete";
		public static const RETRYING_LOAD_RESOURCE :String = "smRetryingLoadResource";
		public static const LOAD_RESOURCE_TIMED_OUT :String = "smLoadResourceTimedOut";
		public static const CALL_OUT_OF_SYNC_IGNORED :String = "smCallOutOfSyncIgnored";
		public static const WAITING_FOR_MORE_RESOURCES :String = "smWaitingForMoreResources";
		
		/**
		 *  StartupManager asset loader: Notifications to SM Core and available to Client App
		 */
		public static const ASSET_LOADED :String = "smAssetLoaded";
		public static const ASSET_LOAD_FAILED :String = "smAssetLoadFailed";
		
		/**
		 *  StartupManager asset loader: Notifications to Client App
		 */
		public static const ASSET_GROUP_LOAD_PROGRESS :String = "smAssetGroupLoadProgress";
		public static const ASSET_LOAD_FAILED_IOERROR :String = "smAsetLoadFailedIOError";
		public static const ASSET_LOAD_FAILED_SECURITY :String = "smAsetLoadFailedSecurity";
		public static const NEW_ASSET_AVAILABLE :String = "smNewAssetAvailable";
		public static const URL_REFUSED_PROXY_NAME_ALREADY_EXISTS :String =
			"smUrlRefusedProxyNameAlreadyExists";
		
		public function StartupEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}

