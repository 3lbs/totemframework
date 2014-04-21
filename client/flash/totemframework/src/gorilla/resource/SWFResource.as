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

package gorilla.resource
{

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;

	import org.casalib.util.StageReference;

	import totem.loaders.safeloaders.SafeLoader;

	[EditorData( extensions = "swf" )]
	/**
	 * This is a Resource subclass for SWF files. It makes it simpler
	 * to load the files, and to get assets out from inside them.
	 */
	public class SWFResource extends Resource
	{
		private var _appDomain : ApplicationDomain;

		private var _clip : MovieClip;

		private var safeloader : SafeLoader;

		public function advanceChildClips( parent : MovieClip, frame : int ) : void
		{
			for ( var j : int = 0; j < parent.numChildren; j++ )
			{
				var mc : MovieClip = parent.getChildAt( j ) as MovieClip;

				if ( !mc )
					continue;

				if ( mc.totalFrames >= frame )
					mc.gotoAndStop( frame );
				else
					mc.gotoAndStop( mc.totalFrames );

				advanceChildClips( mc, frame );
			}
		}

		public function get appDomain() : ApplicationDomain
		{
			return _appDomain;
		}

		public function get clip() : MovieClip
		{
			return _clip;
		}

		/**
		 * Recursively advances all child clips to the specified frame.
		 * If the child does not have a frame at the position, it is skipped.
		 */

		override public function destroy() : void
		{
			_clip.stopAllMovieClips();
			_clip = null;

			_appDomain = null;

			safeloader.destroy();
			safeloader = null;

			super.destroy();
		}

		/**
		 * Recursively searches all child clips for the maximum frame count.
		 */
		public function findMaxFrames( parent : MovieClip, currentMax : int ) : int
		{
			for ( var i : int = 0; i < parent.numChildren; i++ )
			{
				var mc : MovieClip = parent.getChildAt( i ) as MovieClip;

				if ( !mc )
					continue;

				currentMax = Math.max( currentMax, mc.totalFrames );

				findMaxFrames( mc, currentMax );
			}

			return currentMax;
		}

		/**
		 * Gets a Class instance for the specified exported class name in the SWF.
		 * Returns a null reference if the exported name is not found in the loaded ApplicationDomain.
		 *
		 * @param name The fully qualified name of the exported class.
		 */
		public function getAssetClass( name : String ) : Class
		{
			if ( null == _appDomain )
				throw new Error( "not initialized" );

			if ( _appDomain.hasDefinition( name ))
				return _appDomain.getDefinition( name ) as Class;
			else
				return null;
		}

		/**
		 * Gets a new instance of the specified exported class contained in the SWF.
		 * Returns a null reference if the exported name is not found in the loaded ApplicationDomain.
		 *
		 * @param name The fully qualified name of the exported class.
		 */
		public function getExportedAsset( name : String ) : Object
		{
			if ( null == _appDomain )
				throw new Error( "not initialized" );

			var assetClass : Class = getAssetClass( name );

			if ( assetClass != null )
				return new assetClass();
			else
				return null;
		}

		override public function initialize( data : * ) : void
		{
			// Directly load embedded resources if they gave us a MovieClip.
			if ( data is MovieClip )
			{
				onContentReady( data );
				onLoadComplete();
				return;
			}

			// Otherwise it must be a ByteArray, pass it over to the normal path.
			//super.initialize( data );

			if ( !( data is ByteArray ))
				throw new Error( "Default Resource can only process ByteArrays!" );

			// we have to use safe loaders for swf cause it may be a Flex SWF and or contain TLF
			safeloader = new SafeLoader();
			safeloader.contentLoaderInfo.addEventListener( Event.COMPLETE, onLoadComplete );
			safeloader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, onDownloadError );
			safeloader.contentLoaderInfo.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onDownloadSecurityError );

			var _lc : LoaderContext = new LoaderContext( false, ApplicationDomain.currentDomain, null );
			_lc.allowCodeImport = true;

			// have to put on stage because of flex movie
			//StageReference.getStage().addChild( safeloader );

			safeloader.loadBytes( data, _lc );

			// Keep reference so the Loader isn't GC'ed.
			_loader = safeloader.realLoader;

			// this is encase its a Flex swf!
			_loader.addEventListener( "mx.managers.SystemManager.isBootstrapRoot", systemManagerHandler );
			_loader.addEventListener( "mx.managers.SystemManager.isStageRoot", systemManagerHandler );
		}

		/**
		 * @inheritDoc
		 */
		override protected function onContentReady( content : * ) : Boolean
		{
			if ( content )
				_clip = content as MovieClip;

			// Get the app domain...
			if ( resourceLoader && resourceLoader.contentLoaderInfo )
				_appDomain = resourceLoader.contentLoaderInfo.applicationDomain;
			else if ( content && content.loaderInfo )
				_appDomain = content.loaderInfo.applicationDomain;

			return _clip != null;
		}

		override protected function onLoadComplete( event : Event = null ) : void
		{
			//if ( safeloader && safeloader.stage )
				//StageReference.getStage().removeChild( safeloader );

			super.onLoadComplete( event );
		}

		private function systemManagerHandler( event : Event ) : void
		{
			event.preventDefault();
		}
	}
}

