package totem3d.builder
{
	import away3d.materials.TextureMaterial;
	import away3d.textures.BitmapTexture;
	import away3d.textures.BitmapTextureCache;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	
	import mx.resources.ResourceManager;
	
	import org.casalib.events.RemovableEventDispatcher;
	import org.robotlegs.core.IInjector;
	
	import totem.display.builder.BitmapDataFactory;
	import totem.monitors.CompleteListMonitor;
	import totem.monitors.IStartMonitor;
	import totem.resource.Resource;
	
	import totem3d.core.datatypeobject.MaterialParam;
	
	public class MaterialFactory extends RemovableEventDispatcher implements IStartMonitor
	{
		
		private var material : TextureMaterial;
		
		private var params : MaterialParam;
		
		[Inject]
		public var resourceManager : ResourceManager;
		
		[Inject]
		public var injector : IInjector;
		
		private var failed : Boolean = false;
		
		private var _id : String;
		
		public function MaterialFactory( data : MaterialParam )
		{
			super ();
			
			params = data;
		}
		
		public function start() : void
		{
			var url : String = params.url;
			
			// next problem
			// diffuse, specualr and normals
			
			var bitmapDataMonitor : CompleteListMonitor = new CompleteListMonitor ();
			bitmapDataMonitor.addEventListener ( Event.COMPLETE, onBitmapDataComplete );
			
			
			var bitmapFactory : BitmapDataFactory;
			
			// diffuse texture
			if ( params.diffuseTexture )
			{
				bitmapFactory = new BitmapDataFactory ( params.diffuseTexture );
				injector.injectInto( bitmapFactory );
				bitmapDataMonitor.addDispatcher ( bitmapFactory );
			}
			
			if ( params.specularTexture )
			{
				bitmapFactory = new BitmapDataFactory ( params.specularTexture );
				injector.injectInto( bitmapFactory );
				bitmapDataMonitor.addDispatcher ( bitmapFactory );
			}
			
			if ( params.normalTexture )
			{
				bitmapFactory = new BitmapDataFactory ( params.normalTexture );
				injector.injectInto( bitmapFactory );
				bitmapDataMonitor.addDispatcher ( bitmapFactory );
			}
			
			
			bitmapDataMonitor.start ();
		}
		
		protected function onBitmapDataComplete( event : Event ) : void
		{
			var bitmapDataMonitor : CompleteListMonitor = event.target as CompleteListMonitor;
			bitmapDataMonitor.removeEventListener ( Event.COMPLETE, onBitmapDataComplete );
			
			var bitmapData : BitmapData;
			var bitmapTexture : BitmapTexture;
			var factory : BitmapDataFactory;
			
			if ( params.diffuseTexture )
			{
				factory = bitmapDataMonitor.getItemByID ( params.diffuseTexture ) as BitmapDataFactory;
				
				if ( !factory.isFailed )
				{
					bitmapData = factory.bitmapData;
					bitmapTexture = BitmapTextureCache.getInstance ().getTexture ( bitmapData );
				}
			}
			
			material = new TextureMaterial ( bitmapTexture );
			
			// name here
			material.name = params.id;
			
			// add params here	
			for ( var key : String in params )
			{
				if ( material.hasOwnProperty ( key ) )
					material[ key ] = params[ key ];
			}
			
			if ( params.specularTexture )
			{
			}
			
			if ( params.normalTexture )
			{
				
			}
			
			
			bitmapDataMonitor.destroy ();
			
			dispatchEvent ( new Event ( Event.COMPLETE ) );
		}
		
		private function onBitmapFailed( resource : Resource ) : void
		{
			dispatchEvent ( new Event ( Event.COMPLETE ) );
		}
		
		public function getResult() : TextureMaterial
		{
			return material;
		}
		
		public function get isFailed() : Boolean
		{
			return failed;
		}
		
		override public function destroy() : void
		{
			
			super.destroy ();
			
			params = null;
			
			// dont destroy the material.  its the product of factory
			material = null;
			
			resourceManager = null;
		}
		
		public function get id():String
		{
			return _id;
		}
		
		public function set id(value:String):void
		{
			_id = value;
		}
	
	}
}

