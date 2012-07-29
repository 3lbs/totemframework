package totem3d.builder
{
	import away3d.materials.TextureMaterial;
	import away3d.textures.BitmapTexture;
	import away3d.textures.BitmapTextureCache;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	
	import totem.display.builder.AbstractFactory;
	import totem.display.builder.BitmapDataFactory;
	import totem.monitors.CompleteListMonitor;
	import gorilla.resource.IResource;
	import gorilla.resource.IResourceManager;
	
	import totem3d.core.dto.MaterialParam;

	public class MaterialFactory extends AbstractFactory
	{

		private var material : TextureMaterial;

		private var params : MaterialParam;

		private var resourceManager : IResourceManager;

		public function MaterialFactory( resourceManager : IResourceManager, data : MaterialParam )
		{
			super( data.id );

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

		protected function onBitmapDataComplete( event : Event ) : void
		{
			var bitmapDataMonitor : CompleteListMonitor = event.target as CompleteListMonitor;
			bitmapDataMonitor.removeEventListener( Event.COMPLETE, onBitmapDataComplete );

			var bitmapData : BitmapData;
			var bitmapTexture : BitmapTexture;
			var factory : BitmapDataFactory;

			if ( params.diffuseTexture )
			{
				factory = bitmapDataMonitor.getItemByID( params.diffuseTexture ) as BitmapDataFactory;

				if ( !factory.isFailed )
				{
					bitmapData = factory.bitmapData;
					bitmapTexture = BitmapTextureCache.getInstance().getTexture( bitmapData );
				}
			}

			material = new TextureMaterial( bitmapTexture );

			// name here
			material.name = params.id;

			// add params here	
			for ( var key : String in params )
			{
				if ( material.hasOwnProperty( key ))
					material[ key ] = params[ key ];
			}

			if ( params.specularTexture )
			{
				factory = bitmapDataMonitor.getItemByID( params.specularTexture ) as BitmapDataFactory;

				if ( !factory.isFailed )
				{
					bitmapData = factory.bitmapData;
					bitmapTexture = BitmapTextureCache.getInstance().getTexture( bitmapData );
					material.specularMap = bitmapTexture;
				}
			}

			if ( params.normalTexture )
			{
				factory = bitmapDataMonitor.getItemByID( params.normalTexture ) as BitmapDataFactory;

				if ( !factory.isFailed )
				{
					bitmapData = factory.bitmapData;
					bitmapTexture = BitmapTextureCache.getInstance().getTexture( bitmapData );
					material.normalMap = bitmapTexture;
				}
			}


			bitmapDataMonitor.destroy();
			
			material.name = params.id;
			
			dispatchEvent( new Event( Event.COMPLETE ));
		}

		private function onBitmapFailed( resource : IResource ) : void
		{
			dispatchEvent( new Event( Event.COMPLETE ));
		}

		public function getResult() : TextureMaterial
		{
			return material;
		}

		override public function destroy() : void
		{

			super.destroy();

			params = null;

			// dont destroy the material.  its the product of factory
			material = null;

		}

	}
}

