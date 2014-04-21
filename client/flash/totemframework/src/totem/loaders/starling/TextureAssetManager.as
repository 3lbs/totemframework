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

	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	import totem.core.Destroyable;
	import totem.core.params.display.TextureParam;

	public class TextureAssetManager extends Destroyable
	{
		public function TextureAssetManager()
		{
			super();
		}

		public function getTexture( data : TextureParam ) : Vector.<Texture>
		{
			
			var atlas : TextureAtlas;
			
			if ( TextureCacheManager.getInstance().hasTextures( data.name ) )
			{
				return TextureCacheManager.getInstance().getTextures( data.name );
			}
			
			else if ( ( atlas = AtlasTextureCache.getInstance().getTextureAtlas( data.atlas ) ) != null )
			{
				
				var textures : Vector.<Texture> = atlas.getTextures( data.name );
				
				TextureCacheManager.getInstance().createIndex( data.name, textures );
				
				return textures;
			}

			return null;
		}
	}
}
