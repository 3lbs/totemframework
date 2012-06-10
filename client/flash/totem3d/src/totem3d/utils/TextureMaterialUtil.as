package totem3d.utils
{
	import away3d.materials.MaterialBase;
	import away3d.materials.TextureMaterial;
	import away3d.materials.methods.BasicAmbientMethod;
	import away3d.materials.methods.ShadingMethodBase;
	import away3d.textures.BitmapTexture;
	import away3d.textures.BitmapTextureCache;
	
	import flash.display.BitmapData;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	public class TextureMaterialUtil
	{
		private static var count : int = 100;
		
		public function TextureMaterialUtil()
		{
		}
		
		public static function cloneMaterial( material : MaterialBase, type : Class = null ) : MaterialBase
		{
			var classType : Class = type || getDefinitionByName ( getQualifiedClassName ( material ) ) as Class;
			
			var outMaterial : MaterialBase = new classType ();
			
			if ( outMaterial )
			{
				copyData ( material, outMaterial );
			}
			return outMaterial;
		}
		
		private static function copyData( source : Object, destination : Object ) : void
		{
			
			//copies data from commonly named properties and getter/setter pairs
			if ( ( source ) && ( destination ) )
			{
				
				try
				{
					var sourceInfo : XML = describeType ( source );
					var prop : XML;
					var item : *;
					
					for each ( prop in sourceInfo.variable )
					{
						
						if ( destination.hasOwnProperty ( prop.@name ) )
						{
							item = source[ prop.@name ];
							destination[ prop.@name ] = source[ prop.@name ];
						}
						
					}
					
					trace ( "======================== dup material ===================================" );
					
					for each ( prop in sourceInfo.accessor )
					{
						if ( prop.@access == "readwrite" )
						{
							if ( destination.hasOwnProperty ( prop.@name ) )
							{
								item = source[ prop.@name ];
								
								if ( prop.@name == "name" )
								{
									//destination[ prop.@name ] = source[ prop.@name + "c" + count++ ]; // 
								}
								// im not sure about this one. should be able to share material will test later
								else if ( item && item is BitmapTexture )
								{
									
									destination[ prop.@name ] = new BitmapTexture ( BitmapTexture ( item ).bitmapData.clone () );
									
									continue;
								}
								else if ( item is ShadingMethodBase )
								{
									trace ( "This is error: " + prop.@name + " = " + item );
									ShadingMethodBase( destination[ prop.@name ] ).copyFrom( ShadingMethodBase(item ) );
								}
								else
								{
									destination[ prop.@name ] = item;
								}
							}
						}
					}
				}
				catch ( err : Object )
				{;
				}
			}
		}
		
		public static function disposeMaterial( material : TextureMaterial ) : void
		{
			if ( material.texture )
			{
				BitmapTextureCache.getInstance ().freeTexture ( BitmapTexture ( material.texture ) );
			}
			
			// specular
			if ( material.specularMap )
			{
				BitmapTextureCache.getInstance ().freeTexture ( BitmapTexture ( material.specularMap ) );
			}
			
			// normal
			if ( material.normalMap )
			{
				BitmapTextureCache.getInstance ().freeTexture ( BitmapTexture ( material.normalMap ) );
			}
		}
	}
}

