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

package totem.display
{

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import totem.core.Destroyable;
	import totem.utils.DestroyUtil;

	public class BitmapDataAtlas extends Destroyable
	{

		/** helper objects */
		private static var sNames : Vector.<String> = new <String>[];

		private var atlasBitmapData : BitmapData;

		private var textureFrames : Dictionary;

		private var textureRegions : Dictionary;

		/** Create a texture atlas from a texture by parsing the regions from an XML file. */
		public function BitmapDataAtlas( texture : BitmapData, atlasXml : XML = null )
		{
			textureRegions = new Dictionary();
			textureFrames = new Dictionary();
			atlasBitmapData = texture;

			if ( atlasXml )
				parseAtlasXml( atlasXml );
		}

		/** Adds a named region for a subtexture (described by rectangle with coordinates in
		 *  pixels) with an optional frame. */
		public function addRegion( name : String, region : Rectangle, frame : Rectangle = null ) : void
		{
			textureRegions[ name ] = region;
			textureFrames[ name ] = frame;
		}

		override public function destroy() : void
		{
			super.destroy();

			atlasBitmapData.dispose();
			atlasBitmapData = null;

			textureFrames = null;

			textureRegions = null;
			
			sNames.length = 0;
			sNames = null;
		}

		/** Disposes the atlas texture. */
		public function dispose() : void
		{
			atlasBitmapData.dispose();
			atlasBitmapData = null;

			DestroyUtil.destroyDictionary( textureRegions );
			textureRegions = null;

			textureFrames = null;

		}

		/** Retrieves a subtexture by name. Returns <code>null</code> if it is not found. */
		public function getBitmap( name : String ) : Bitmap
		{
			var region : Rectangle = textureRegions[ name ];

			if ( region == null )
				return null;
			else
				return fromTexture( atlasBitmapData, region, textureFrames[ name ]);
		}

		/** Returns the frame rectangle of a specific region, or <code>null</code> if that region
		 *  has no frame. */
		public function getFrame( name : String ) : Rectangle
		{
			return textureFrames[ name ];
		}

		/** Returns all texture names that start with a certain string, sorted alphabetically. */
		public function getNames( prefix : String = "", result : Vector.<String> = null ) : Vector.<String>
		{
			if ( result == null )
				result = new <String>[];

			for ( var name : String in textureRegions )
				if ( name.indexOf( prefix ) == 0 )
					result.push( name );

			result.sort( Array.CASEINSENSITIVE );
			return result;
		}

		/** Returns the region rectangle associated with a specific name. */
		public function getRegion( name : String ) : Rectangle
		{
			return textureRegions[ name ];
		}

		/** Returns all textures that start with a certain string, sorted alphabetically
		 *  (especially useful for "MovieClip"). */
		public function getBitmaps( prefix : String = "", result : Vector.<Bitmap> = null ) : Vector.<Bitmap>
		{
			if ( result == null )
				result = new <Bitmap>[];

			for each ( var name : String in getNames( prefix, sNames ))
				result.push( getBitmap( name ));

			sNames.length = 0;
			return result;
		}

		/** Removes a region with a certain name. */
		public function removeRegion( name : String ) : void
		{
			delete textureRegions[ name ];
			delete textureFrames[ name ];
		}

		/** This function is called by the constructor and will parse an XML in Starling's
		 *  default atlas file format. Override this method to create custom parsing logic
		 *  (e.g. to support a different file format). */
		protected function parseAtlasXml( atlasXml : XML ) : void
		{
			var scale : Number = 1; // atlasBitmapData.scale;

			for each ( var subTexture : XML in atlasXml.SubTexture )
			{
				var name : String = subTexture.attribute( "name" );
				var x : Number = parseFloat( subTexture.attribute( "x" )) / scale;
				var y : Number = parseFloat( subTexture.attribute( "y" )) / scale;
				var width : Number = parseFloat( subTexture.attribute( "width" )) / scale;
				var height : Number = parseFloat( subTexture.attribute( "height" )) / scale;
				var frameX : Number = parseFloat( subTexture.attribute( "frameX" )) / scale;
				var frameY : Number = parseFloat( subTexture.attribute( "frameY" )) / scale;
				var frameWidth : Number = parseFloat( subTexture.attribute( "frameWidth" )) / scale;
				var frameHeight : Number = parseFloat( subTexture.attribute( "frameHeight" )) / scale;

				var region : Rectangle = new Rectangle( x, y, width, height );
				var frame : Rectangle = frameWidth > 0 && frameHeight > 0 ? new Rectangle( frameX, frameY, frameWidth, frameHeight ) : null;

				addRegion( name, region, frame );
			}
		}

		private function fromTexture( atlasBitmapData : BitmapData, region : Rectangle, param2 : String ) : Bitmap
		{

			var bitmap : Bitmap = new Bitmap();

			var bitmapData : BitmapData = new BitmapData( region.width, region.height );

			bitmapData.copyPixels( atlasBitmapData, region, new Point());

			bitmap.bitmapData = bitmapData;

			return bitmap;
		}
	}
}
