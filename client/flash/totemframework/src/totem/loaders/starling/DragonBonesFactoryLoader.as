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

	import dragonBones.factorys.BaseFactory;
	import dragonBones.factorys.StarlingFactory;
	
	import starling.textures.TextureAtlas;
	
	import totem.monitors.RequiredProxy;

	public class DragonBonesFactoryLoader extends RequiredProxy
	{
		private var _createNative : Boolean;

		private var atlasID : String;

		public function DragonBonesFactoryLoader( atlasID : String )
		{

			this.atlasID = atlasID;

			super( atlasID );
		}

		override public function start() : void
		{

			super.start();

			var factory : BaseFactory;

			var _textureAtlas : TextureAtlas = AtlasTextureCache.getInstance().getTextureAtlas( atlasID );

			if ( !_textureAtlas )
			{
				throw new Error( "sorry but must preload atlas" );
				return;
			}

			factory = new StarlingFactory();

			factory.addTextureAtlas( _textureAtlas, atlasID );
			DragonBonesFactoryCache.getInstance().createIndex( atlasID, factory );

			finished();
		}
	}
}
