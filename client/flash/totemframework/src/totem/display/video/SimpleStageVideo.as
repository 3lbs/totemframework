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

/*
53 49 4D 50 4C 45 53 54 41 47 45 56 49 44 45 4F
*/

package totem.display.video
{

	import flash.events.Event;
	import flash.events.StageVideoAvailabilityEvent;
	import flash.events.StageVideoEvent;
	import flash.events.VideoEvent;
	import flash.geom.Rectangle;
	import flash.media.StageVideo;
	import flash.media.StageVideoAvailability;
	import flash.media.Video;
	import flash.media.VideoStatus;
	import flash.net.NetStream;

	import totem.display.layout.TSprite;
	import totem.display.video.events.SimpleStageVideoEvent;
	import totem.display.video.events.SimpleStageVideoToggleEvent;

	/**
	 * The SimpleStageVideo class allows you to leverage StageVideo trough a few lines of ActionScript.
	 * SimpleStageVideo automatically handles any kind of fallback, from StageVideo to video and vice versa.
	 *
	 * @example
	 * To use SimpleStageVideo, use the following lines :
	 * <div class="listing">
	 * <pre>
	 *
	 * // specifies the size to conform (will always preserve ratio)
	 * sv = new SimpleStageVideo(500, 500);
	 * // dispatched when the NetStream object can be played
	 * sv.addEventListener(Event.INIT, onInit);
	 * // informs the developer about the compositing, decoding and if full GPU states
	 * sv.addEventListener(SimpleStageVideoEvent.STATUS, onStatus);
	 * // initializes it
	 * addChild(sv);
	 * </pre>
	 * </div>
	 *
	 * @author Thibault Imbert (bytearray.org)
	 * @version 1.1
	 */
	public class SimpleStageVideo extends TSprite
	{
		private var _available : Boolean;

		private var _classicVideoInUse : Boolean;

		private var _force : Boolean;

		private var _height : uint;

		private var _initEvent : Event = new Event( Event.INIT );

		private var _inited : Boolean;

		private var _ns : NetStream;

		private var _played : Boolean;

		private var _rc : Rectangle;

		private var _reset : Rectangle = new Rectangle( 0, 0, 0, 0 );

		private var _stageVideoInUse : Boolean;

		private var _sv : StageVideo;

		private var _video : Video;

		private var _videoRect : Rectangle = new Rectangle( 0, 0, 0, 0 );

		private var _width : uint;

		/**
		 *
		 * @param width The width of the screen, the video will fit this maximum width (while preserving ratio)
		 * @param height The height of the screen, the video will fit this maximum height (while preserving ratio)
		 *
		 */
		public function SimpleStageVideo( width : uint = 640, height : uint = 480, force : Boolean = false )
		{
			_force = force;

			_width = width, _height = height;
			init();
		}

		/**
		 *
		 * @param stream The NetStream to use for the video.
		 *
		 */
		public function attachNetStream( stream : NetStream ) : void
		{
			_ns = stream;
		}

		/**
		 *
		 * @return Returns the Stage Video availability.
		 *
		 */
		public function get available() : Boolean
		{
			return _available;
		}

		override public function destroy() : void
		{

			removeEventListener( Event.ADDED_TO_STAGE, onAddedToStageView );
			removeEventListener( Event.REMOVED_FROM_STAGE, onRemovedFromStage );

			stage.removeEventListener( StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY, onStageVideoAvailable );

			_ns.dispose();
			_ns = null;

			_video.removeEventListener( VideoEvent.RENDER_STATE, onRenderState );

			if ( _video && _video.parent )
				_video.parent.removeChild( _video );

			_video.attachNetStream( null );
			_video.clear();
			_video = null;

			if ( _sv )
			{
				_sv.viewPort = new Rectangle( this.x, this.y, 0, 0 );
				_sv.attachNetStream( null );
				_sv = null;
			}

			super.destroy();

		}

		/**
		 * Resizes the video surfaces while always preserving the image ratio.
		 */
		public function resize( width : uint = 0, height : uint = 0 ) : void
		{
			_width = width, _height = height;

			if ( _stageVideoInUse )
				_sv.viewPort = getVideoRect( _sv.videoWidth, _sv.videoHeight );
			else
			{
				_rc = getVideoRect( _video.videoWidth, _video.videoHeight );
				_video.width = _rc.width;
				_video.height = _rc.height;
				_video.x = _rc.x, _video.y = _rc.y;
			}
		}

		/**
		 *
		 * @return Returns the internal StageVideo object used if available.
		 *
		 */
		public function get stageVideo() : StageVideo
		{
			return _sv;
		}

		/**
		 * Forces the switch from Video to StageVideo and vice versa.
		 * You should not have to use this API but can be useful for debugging purposes.
		 * @param on
		 *
		 */

		public function toggle( on : Boolean ) : void
		{
			if ( on && _available )
			{
				_stageVideoInUse = true;

				if ( _sv == null && stage.stageVideos.length > 0 )
				{
					_sv = stage.stageVideos[ 0 ];
					_sv.addEventListener( StageVideoEvent.RENDER_STATE, onRenderState );
				}
				_sv.attachNetStream( _ns );
				dispatchEvent( new SimpleStageVideoToggleEvent( SimpleStageVideoToggleEvent.TOGGLE, SimpleStageVideoToggleEvent.STAGEVIDEO ));

				if ( _classicVideoInUse )
				{
					stage.removeChild( _video );
					_classicVideoInUse = false;
				}
			}
			else
			{
				if ( _stageVideoInUse )
					_stageVideoInUse = false;
				_classicVideoInUse = true;
				_video.attachNetStream( _ns );
				dispatchEvent( new SimpleStageVideoToggleEvent( SimpleStageVideoToggleEvent.TOGGLE, SimpleStageVideoToggleEvent.VIDEO ));
				_video.width = _video.height = 0;
				stage.addChildAt( _video, 0 );
			}

			if ( !_played )
			{
				_played = true;
				dispatchEvent( _initEvent );
			}
		}

		/**
		 *
		 * @return Returns the internal Video object used as a fallback.
		 *
		 */
		public function get video() : Video
		{
			return _video;
		}

		/**
		 *
		 * @param width
		 * @param height
		 * @return
		 *
		 */
		private function getVideoRect( width : uint, height : uint ) : Rectangle
		{
			var videoWidth : uint = width;
			var videoHeight : uint = height;
			var scaling : Number = Math.min( _width / videoWidth, _height / videoHeight );

			videoWidth *= scaling, videoHeight *= scaling;

			var posX : Number = stage.stageWidth - videoWidth >> 1;
			var posY : Number = stage.stageHeight - videoHeight >> 1;

			_videoRect.x = posX;
			_videoRect.y = posY;
			_videoRect.width = videoWidth;
			_videoRect.height = videoHeight;

			return _videoRect;
		}

		/**
		 *
		 *
		 */
		private function init() : void
		{
			addChild( _video = new Video());
			addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
			addEventListener( Event.ADDED_TO_STAGE, onAddedToStageView );
			addEventListener( Event.REMOVED_FROM_STAGE, onRemovedFromStage );
		}

		/**
		 *
		 * @param event
		 *
		 */
		private function onAddedToStage( event : Event ) : void
		{
			removeEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
			stage.addEventListener( StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY, onStageVideoAvailable );
			_video.addEventListener( VideoEvent.RENDER_STATE, onRenderState );
		}

		/**
		 *
		 * @param event
		 *
		 */
		private function onAddedToStageView( event : Event ) : void
		{
			if ( _classicVideoInUse )
			{
				stage.addChildAt( _video, 0 );
			}
			else if ( _stageVideoInUse )
				_sv.viewPort = _videoRect;
		}

		/**
		 *
		 * @param event
		 *
		 */
		private function onRemovedFromStage( event : Event ) : void
		{
			if ( !contains( _video ))
				addChild( _video );

			if ( _sv != null )
				_sv.viewPort = _reset;
		}

		/**
		 *
		 * @param event
		 *
		 */
		private function onRenderState( event : Event ) : void
		{
			var hwDecoding : Boolean;

			if ( event is VideoEvent )
			{
				hwDecoding = ( event as VideoEvent ).status == VideoStatus.ACCELERATED;
				dispatchEvent( new SimpleStageVideoEvent( SimpleStageVideoEvent.STATUS, hwDecoding, false, false ));
			}
			else
			{
				hwDecoding = ( event as StageVideoEvent ).status == VideoStatus.ACCELERATED;
				dispatchEvent( new SimpleStageVideoEvent( SimpleStageVideoEvent.STATUS, hwDecoding, true, hwDecoding && true ));
			}

			resize( _width, _height );
		}

		/**
		 *
		 * @param event
		 *
		 */
		private function onStageVideoAvailable( event : StageVideoAvailabilityEvent ) : void
		{
			toggle( _available = ( event.availability == StageVideoAvailability.AVAILABLE ));
		}
	}
}
