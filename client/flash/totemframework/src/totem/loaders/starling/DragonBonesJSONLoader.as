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

package totem.loaders.starling
{

	import flash.display.BitmapData;
	import flash.filesystem.File;
	
	import dragonBones.factorys.StarlingFactory;
	import dragonBones.objects.DataParser;
	import dragonBones.objects.SkeletonData;
	
	import starling.textures.TextureAtlas;
	
	import totem.loaders.JSONNativeFileLoader;
	import totem.monitors.RequiredProxy;

	public class DragonBonesJSONLoader extends RequiredProxy
	{

		private var _bitmapData : BitmapData;

		private var _textureAtlas : TextureAtlas;

		private var atlasID : String;

		private var factory : StarlingFactory;

		private var url : String;

		public function DragonBonesJSONLoader( url : String, skeletonID : String, atlasID : String )
		{
			this.id = skeletonID || url;
			this.url = url;

			this.atlasID = atlasID;

			super( id );
		}

		public function getFactory() : StarlingFactory
		{
			return factory;
		}

		override public function start() : void
		{

			super.start();

			DragonBonesFactoryCache.getInstance().createIndex( id, factory );

			_textureAtlas = AtlasTextureCache.getInstance().getTextureAtlas( atlasID );

			if ( !_textureAtlas )
			{
				throw new Error("sorry but must preload atlas");
				return;
			}
			
			finished();
		}

		override protected function finished() : void
		{

			factory = new StarlingFactory();

			var file : File = new File( url );
			var _JSONData : Object = JSONNativeFileLoader.getObject( file );

			var skeletonData : SkeletonData = DataParser.parseData( _JSONData );
			factory.addSkeletonData( skeletonData, id );
			factory.addTextureAtlas( _textureAtlas, id );

			//addDispatcher( new JSONNativeFileLoader());

			//var dragonResource : DragonBonesResource = ResourceManager.getInstance().load( url, DragonBonesResource ) as DragonBonesResource;
			//dragonResource.completeCallback( handleArmatureLoaded );

			super.finished();
		}
	}
}
