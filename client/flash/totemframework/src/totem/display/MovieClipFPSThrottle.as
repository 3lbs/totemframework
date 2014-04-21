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

		private var _fps : Number;

		private var _lastTime : Number = 0;

		private var _loop : Boolean;

		private var _movieClip : MovieClip;

		private var _rate : Number = 0;

		private var _totalFrames : int;

		public function MovieClipFPSThrottle( mc : MovieClip, fps : int = 12, loop : Boolean = false )
		{

			_movieClip = mc;
			_movieClip.gotoAndStop( 1 );

			_totalFrames = _movieClip.totalFrames;

			this.fps = fps;
			_loop = loop;

			_lastTime = getTimer();

			stop();

			addChild( _movieClip );
		}

		public function get currentFrame() : int
		{
			return movieClip.currentFrame;
		}

		override public function destroy() : void
		{
			removeEventListener( Event.ENTER_FRAME, update );

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

		public function set loop( value : Boolean ) : void
		{
			_loop = value;
		}

		public function get movieClip() : MovieClip
		{
			return _movieClip;
		}

		public function play() : void
		{
			_lastTime = getTimer();
			addEventListener( Event.ENTER_FRAME, update, false, 0, true );
		}

		public function stop() : void
		{
			removeEventListener( Event.ENTER_FRAME, update );
		}

		public function get totalFrames() : int
		{
			return _totalFrames;
		}

		private function update( eve : Event ) : void
		{
			var time = getTimer();
			var dt = time - _lastTime;

			if ( dt <= _rate )
				return;

			_lastTime = time;

			if ( dt > _rate )
			{
				if ( currentFrame >= ( _totalFrames - 1 ))
				{
					if ( _loop )
					{
						_movieClip.gotoAndStop( 1 );
					}
					else
					{
						stop();
					}

					dispatchEvent( new Event( Event.COMPLETE ));
				}
				else
				{
					_movieClip.nextFrame();
				}
			}
		}
	}
}
