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

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.getTimer;

	import totem.display.layout.TSprite;

	public class MovieClipFPSThrottle extends TSprite
	{

		protected var _loop : int;

		protected var _movieClip : MovieClip;

		private var _fps : Number;

		private var _isReversing : Boolean;

		private var _lastTime : Number = 0;

		private var _playing : Boolean;

		private var _rate : Number = 0;

		private var _reverse : Boolean = false;

		private var _totalFrames : int;

		public function MovieClipFPSThrottle( mc : MovieClip, fps : int = 12, loop : int = 0 )
		{

			_movieClip = mc;
			//_movieClip.gotoAndStop( 1 );

			_totalFrames = _movieClip.totalFrames;

			this.fps = fps;
			_loop = loop;

			_lastTime = getTimer();

			//stop();

			if ( !_movieClip.parent )
				addChild( _movieClip );
		}

		public function get currentFrame() : int
		{
			return movieClip.currentFrame;
		}

		override public function destroy() : void
		{

			stop();

			_movieClip.stop();
			_movieClip = null;

			super.destroy();
		}

		public function get fps() : Number
		{
			return _fps;
		}

		public function set fps( value : Number ) : void
		{
			if ( value == _fps )
				return;

			_fps = value;
			_rate = 1000 / _fps;
		}

		public function gotoAndPlay( frame : Object, scene : String = null ) : void
		{
			_movieClip.gotoAndStop( frame, scene );

			play();
		}

		/**
		 Sends the playhead to the specified frame on and reverses from that frame.

		 @param frame: A number representing the frame number or a string representing the label of the frame to which the playhead is sent.
		 */
		public function gotoAndReverse( frame : Object ) : void
		{
			_movieClip.gotoAndStop( frame );

			this._playInReverse();
		}

		public function gotoAndStop( frame : Object ) : void
		{
			_movieClip.gotoAndStop( frame );
			stop();
		}

		public function isPlaying() : Boolean
		{
			return ( _playing || _isReversing );
		}

		public function set loop( value : int ) : void
		{
			_loop = value;
		}

		public function get movieClip() : MovieClip
		{
			return _movieClip;
		}

		public function play() : void
		{

			this._stopReversing();

			_playing = true;

			_lastTime = getTimer();
			_movieClip.addEventListener( Event.ENTER_FRAME, _updatePlay );
		}

		public function reverse() : void
		{
			this._playInReverse();
		}

		public function stop() : void
		{

			_playing = false;

			this._stopReversing();
			_movieClip.removeEventListener( Event.ENTER_FRAME, _updatePlay );
		}

		public function get totalFrames() : int
		{
			return _totalFrames;
		}

		override public function set visible( value : Boolean ) : void
		{
			super.visible = value;

			_movieClip.visible = value;
		}

		protected function _gotoFrameBefore( e : Event ) : void
		{

			var time = getTimer();
			var dt = time - _lastTime;

			if ( dt <= _rate )
				return;

			_lastTime = time;

			if ( this.currentFrame == 1 )
			{
				if ( _loop == 0  )
				{
					super.gotoAndStop( this.totalFrames );
				}
				else
				{
					stop();
				}

				complete();
			}
			else
			{
				_movieClip.prevFrame();
			}
		}

		protected function _playInReverse() : void
		{
			if ( this._isReversing )
				return;

			this._isReversing = true;

			_movieClip.addEventListener( Event.ENTER_FRAME, _gotoFrameBefore, false, 0, true );
		}

		protected function _stopReversing() : void
		{
			if ( !this._isReversing )
				return;

			this._isReversing = false;

			_movieClip.removeEventListener( Event.ENTER_FRAME, _gotoFrameBefore );
		}

		protected function _updatePlay( eve : Event ) : void
		{
			var time = getTimer();
			var dt = time - _lastTime;

			if ( dt <= _rate )
				return;

			_lastTime = time;

			if ( currentFrame >= ( _totalFrames ))
			{
				if ( _loop == 0 )
				{
					_movieClip.gotoAndStop( 1 );
				}
				else
				{
					stop();
				}

				complete();
			}
			else
			{
				_movieClip.nextFrame();
			}

			onUpdateAnimation();
		}

		protected function complete() : void
		{
			dispatchEvent( new Event( Event.COMPLETE ));
		}

		protected function onUpdateAnimation() : void
		{

		}

		private function _elaspedTime() : Boolean
		{
			var time = getTimer();
			var dt = time - _lastTime;

			if ( dt <= _rate )
				return false;

			_lastTime = time;

			return true;
		}
	}
}
