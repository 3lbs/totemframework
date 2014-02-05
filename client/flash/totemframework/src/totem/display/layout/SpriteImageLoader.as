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
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;

	public class SpriteImageLoader extends TSprite
	{
		private var _content : DisplayObject;

		private var imageLoader : Loader;

		public function SpriteImageLoader()
		{
			super();
		}

		public function get content():DisplayObject
		{
			return _content;
		}

		override public function destroy() : void
		{
			dispose();

			super.destroy();
		}

		public function dispose() : void
		{
			if ( _content is Bitmap )
			{
				Bitmap( _content ).bitmapData.dispose();
			}
			else if ( _content is BitmapData )
			{
				BitmapData( _content ).dispose();
			}

			if ( imageLoader )
			{
				imageLoader.unload();
				imageLoader.unloadAndStop();

				imageLoader = null;
			}

			_content = null;

			removeChildren();
		}

		public function load( value : * ) : void
		{
			dispose();

			if ( value is String )
			{
				imageLoader = new Loader();
				imageLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, handleImageLoaded );
				imageLoader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, onLoaderProgress );
				imageLoader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, onFailedLoading );
				var request : URLRequest = new URLRequest( value );
				imageLoader.load( request );

				_content = imageLoader;

				addChild( imageLoader );
				return;
			}

			if ( value is BitmapData )
			{
				_content = new Bitmap( value );
			}
			else if ( value is Bitmap )
			{
				_content = value;
			}

			addChild( _content );

			dispatchEvent( new Event( Event.COMPLETE ));
		}
		
		protected function onFailedLoading(event:IOErrorEvent):void
		{
			removeEvents();
			throw new Error( "i forgot how to do this but failed loading iamges" );
		}
		
		protected function handleImageLoaded( event : Event ) : void
		{
			removeEvents();
			dispatchEvent( new Event( Event.COMPLETE ));
		}
		
		private function removeEvents () : void
		{
			imageLoader.contentLoaderInfo.removeEventListener( Event.COMPLETE, handleImageLoaded );
			imageLoader.contentLoaderInfo.removeEventListener( ProgressEvent.PROGRESS, onLoaderProgress );
			imageLoader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, onFailedLoading );
			
		}

		protected function onLoaderProgress( event : ProgressEvent ) : void
		{

		}
	}
}
