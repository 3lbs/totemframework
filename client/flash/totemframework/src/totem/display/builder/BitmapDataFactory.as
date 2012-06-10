package totem.display.builder
{
	import flash.display.BitmapData;
	import flash.events.Event;
	
	import org.casalib.events.RemovableEventDispatcher;
	
	import totem.net.URLManager;
	import totem.monitors.IStartMonitor;
	
	public class BitmapDataFactory extends RemovableEventDispatcher implements IStartMonitor
	{
		
		//[Inject]
		//public var resourceManager : ResourceManager;
		
		private var filename : String;
		
		private var _bitmapData : BitmapData;
		
		private var failed : Boolean = false;
		private var _id:String;
		
		public function BitmapDataFactory( url : String )
		{
			super ();
			
			_id = url;  
			filename = URLManager.getAssetURL( url ); 
		}
		
		public function start() : void
		{
			//resourceManager.load ( filename, ImageResource, onBitmapComplete, onBitmapFailed );
		}
		
		/*private function onBitmapFailed( resource : Resource ) : void
		{
			failed = true;
			
			factoryComplete();
		}*/
		
		/*private function onBitmapComplete( resource : ImageResource ) : void
		{
			
			_bitmapData = resource.bitmapData;
			
			factoryComplete();
		}*/
		
		private function factoryComplete () : void
		{			
			dispatchEvent ( new Event ( Event.COMPLETE ) );
		}
		
		
		public function get isFailed() : Boolean
		{
			return failed;
		}
		
		override public function destroy() : void
		{
			super.destroy ();
			
			_bitmapData = null;
		}
		
		public function get bitmapData():BitmapData
		{
			return _bitmapData;
		}
		
		public function get id():String
		{
			return _id;
		}
	
	
	}
}

