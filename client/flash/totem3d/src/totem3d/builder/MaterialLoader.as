package totem3d.builder
{
	import flash.events.Event;
	
	import gorilla.resource.IResourceManager;
	
	import totem.display.builder.BitmapDataFactory;
	import totem.monitors.CompleteListMonitor;
	import totem.monitors.AbstractProxy;
	
	import totem3d.core.dto.MaterialParam;
	
	public class MaterialLoader extends AbstractProxy
	{
		
		private var params : MaterialParam;
		
		private var resourceManager : IResourceManager;
		
		public function MaterialLoader( resourceManager : IResourceManager, data : MaterialParam)
		{
			this.id = data.id;
			
			//super( data.id );
			
			this.resourceManager = resourceManager;
			
			params = data;
		}
		
		
		override public function start() : void
		{
			
			// next problem
			// diffuse, specualr and normals
			
			var bitmapDataMonitor : CompleteListMonitor = new CompleteListMonitor();
			bitmapDataMonitor.addEventListener( Event.COMPLETE, onBitmapDataComplete );
			
			
			var bitmapFactory : BitmapDataFactory;
			
			// diffuse texture
			if ( params.diffuseTexture )
			{
				bitmapFactory = new BitmapDataFactory( resourceManager, params.diffuseTexture );
				bitmapDataMonitor.addDispatcher( bitmapFactory );
			}
			
			if ( params.specularTexture )
			{
				bitmapFactory = new BitmapDataFactory( resourceManager, params.specularTexture );
				bitmapDataMonitor.addDispatcher( bitmapFactory );
			}
			
			if ( params.normalTexture )
			{
				bitmapFactory = new BitmapDataFactory( resourceManager, params.normalTexture );
				bitmapDataMonitor.addDispatcher( bitmapFactory );
			}
			
			bitmapDataMonitor.start();
		}
		
		
		protected function onBitmapDataComplete ( eve : Event ) : void
		{
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
	}
}