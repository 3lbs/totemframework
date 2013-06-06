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
//   3lbs Copyright 2013 
//   For more information see http://www.3lbs.com 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package totem.display.layout
{

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import gorilla.resource.ImageResource;
	import gorilla.resource.Resource;
	import gorilla.resource.ResourceManager;
	

	public class ImageSprite extends TSprite
	{
		private var _content : Bitmap;

		private var data : *;

		public function ImageSprite()
		{
			super();
		}

		public function get content() : Bitmap
		{
			return _content;
		}

		override public function destroy() : void
		{
			super.destroy();
			dispose();
		}

		public function dispose() : void
		{
			if ( data is String )
			{
				ResourceManager.getInstance().unload( data, ImageResource );
			}
			else if ( data is BitmapData )
			{
				BitmapData( data ).dispose();
			}

			data = null;

			removeChildren();
		}

		public function load( data : * ) : void
		{
			dispose();

			this.data = data;

			if ( data is BitmapData )
			{
				image = new Bitmap( data );
			}
			else if ( data is String )
			{
				var resource : Resource = ResourceManager.getInstance().load( data, ImageResource );
				resource.completeCallback( handleBitmapLoaded );
			}
			else if ( data is Bitmap )
			{
				image = data;
			}
		}

		protected function set image( value : Bitmap ) : void
		{
			_content = value;

			addChild( _content );
		}

		private function handleBitmapLoaded( resource : ImageResource ) : void
		{
			image = resource.image;

			//dispatchEvent( new Event( Event.
		}
	}
}
