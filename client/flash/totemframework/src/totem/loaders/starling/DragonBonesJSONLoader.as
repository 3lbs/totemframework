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

	import flash.filesystem.File;
	
	import dragonBones.factories.BaseFactory;
	import dragonBones.objects.DataParser;
	import dragonBones.objects.DragonBonesData;
	
	import totem.loaders.JSONNativeFileLoader;
	import totem.monitors.RequiredProxy;

	public class DragonBonesJSONLoader extends RequiredProxy
	{
		private var _createNative : Boolean;

		private var _factory : BaseFactory;

		private var atlasID : String;

		private var url : String;

		public function DragonBonesJSONLoader( url : String, skeletonID : String, atlasID : String, createNative : Boolean = false )
		{
			this.id = skeletonID || url;
			this.url = url;

			_createNative = createNative;

			this.atlasID = atlasID;

			super( id );
		}

		override public function destroy() : void
		{
			super.destroy();

			_factory = null

		}

		public function getFactory() : BaseFactory
		{
			return _factory;
		}

		override public function start() : void
		{

			super.start();

			_factory = DragonBonesFactoryCache.getInstance().getFactory( atlasID );

			if ( _factory && _factory.getSkeletonData( id ))
			{
				finished();
				return;
			}

			if ( !_factory )
			{
				throw new Error( "sorry but must preload atlas" );
				return;
			}

			var file : File = new File( url );
			var _JSONData : Object = JSONNativeFileLoader.getObject( file );

			var skeletonData : DragonBonesData = DataParser.parseData( _JSONData );

			_factory.addSkeletonData( skeletonData );

			if ( _createNative )
			{

				_factory = DragonBonesFactoryCache.getInstance().getFactory( atlasID + DragonBonesFactoryCache.NATIVE_EXT );
				_factory.addSkeletonData( skeletonData, id );
			}

			super.finished();
		}
	}
}
