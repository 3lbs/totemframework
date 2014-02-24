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

package totem.display.starling
{

	import flash.media.Sound;
	import flash.utils.Dictionary;

	import starling.animation.IAnimatable;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;

	/** Dispatched whenever the movie has displayed its last frame. */
	[Event( name = "complete", type = "starling.events.Event" )]
	/** An ExtendedMovieClip functions almost exactly the same way that MovieClip does, but can
	 *	multiple Animations instead of just one single animation.  For each new Animation, call
	 *	addAnimation on the ExtendedMovieClip, which takes the same parameters that MovieClip does.
	 */
	public class AnimationMovieClip extends Sprite implements IAnimatable
	{
		private var _animations : Dictionary; // so we can do lookups by animation name

		private var _autoDiscardAnimations : Boolean; // if true, all Animation instances in mAnimations will be disposed when this instance is disposed

		private var _currentAnimation : Animation;

		private var _currentFrame : int;

		private var _currentTime : Number;

		private var _image : Image;

		private var _playing : Boolean;

		public function AnimationMovieClip( autoDiscardAnimations : Boolean = true )
		{
			_animations = new Dictionary();
			_playing = false;
			_currentTime = 0.0;
			_currentFrame = 0;
			_autoDiscardAnimations = autoDiscardAnimations;
		}

		public function addAnimation( animName : String, textures : Vector.<Texture>, fps : Number = 12, loop : Boolean = true ) : Animation
		{
			if ( textures.length > 0 )
			{
				_animations[ animName ] = new Animation( textures, fps, loop );

				if ( !_image ) // if this is the first animation, we won't have an image created, so do that now
				{
					_image = new Image( textures[ 0 ]);
					addChild( _image );
					_currentAnimation = _animations[ animName ]; // if this is the first animation added, set it as the current
				}
			}
			else
			{
				throw new ArgumentError( "Empty texture array" );
			}

			return _animations[ animName ];
		}

		public function addAnimationReference( animName : String, animation : Animation ) : Animation
		{
			_animations[ animName ] = animation;

			if ( !_image ) // if this is the first animation, we won't have an image created, so do that now
			{
				_image = new Image( animation.textures[ 0 ]);
				addChild( _image );
				_currentAnimation = _animations[ animName ]; // if this is the first animation added, set it as the current
			}

			return animation;
		}

		// IAnimatable

		/** @inheritDoc */
		public function advanceTime( passedTime : Number ) : void
		{
			var finalFrame : int;
			var previousFrame : int = _currentFrame;

			if ( _currentAnimation.loop && _currentTime == _currentAnimation.totalTime )
			{
				_currentTime = 0.0;
				_currentFrame = 0;
			}

			if ( !_playing || passedTime == 0.0 || _currentTime == _currentAnimation.totalTime )
			{
				if( _currentTime == _currentAnimation.totalTime && _playing )
				{
					_playing = false;
					dispatchEventWith( Event.COMPLETE );
				}
				return;
			}

			_currentTime += passedTime;
			finalFrame = _currentAnimation.textures.length - 1;

			while ( _currentTime >= _currentAnimation.startTimes[ _currentFrame ] + _currentAnimation.durations[ _currentFrame ])
			{
				if ( _currentFrame == finalFrame )
				{
					if ( hasEventListener( Event.COMPLETE ))
					{
						var restTime : Number = _currentTime - _currentAnimation.totalTime;
						_currentTime = _currentAnimation.totalTime;
						dispatchEventWith( Event.COMPLETE );

						// user might have changed movie clip settings, so we restart the method
						advanceTime( restTime );
						return;
					}

					if ( _currentAnimation.loop )
					{
						_currentTime -= _currentAnimation.totalTime;
						_currentFrame = 0;
					}
					else
					{
						_currentTime = _currentAnimation.totalTime;
						break;
					}
				}
				else
				{
					_currentFrame++;

					var sound : Sound = _currentAnimation.sounds[ _currentFrame ];

					if ( sound )
						sound.play();
				}
			}

			if ( _currentFrame != previousFrame )
				_image.texture = _currentAnimation.textures[ _currentFrame ];
		}

		public function get color() : uint
		{
			return _image.color;
		}

		public function set color( value : uint ) : void
		{
			_image.color = value;
		}

		/** The index of the frame that is currently displayed. */
		public function get currentFrame() : int
		{
			return _currentFrame;
		}

		public function set currentFrame( value : int ) : void
		{
			_currentFrame = value;
			_currentTime = 0.0;

			if ( !_currentAnimation )
			{
				return;
			}

			for ( var i : int = 0; i < value; ++i )
				_currentTime += _currentAnimation.getFrameDuration( i );

			_image.texture = _currentAnimation.textures[ _currentFrame ];

			if ( _currentAnimation.sounds[ _currentFrame ])
				_currentAnimation.sounds[ _currentFrame ].play();
		}

		override public function dispose() : void
		{
			_currentAnimation = null;

			if ( _autoDiscardAnimations )
			{
				for each ( var animation : Animation in _animations )
				{
					animation.dispose();
				}
			}
			_animations = null;

			if ( _image )
			{
				removeChild( _image );
				_image.dispose();
				_image = null;
			}

			super.dispose();
		}

		/** The default number of frames per second. Individual frames can have different
		 *  durations. If you change the fps, the durations of all frames will be scaled
		 *  relatively to the previous value. */
		public function get fps() : Number
		{
			return _currentAnimation.fps;
		}

		// frame manipulation

		public function getAnimation( animName : String ) : Animation
		{
			if ( _animations[ animName ])
			{
				return _animations[ animName ];
			}
			else
			{
				throw new ArgumentError( "Invalid animation name" );
			}
		}

		/** Indicates if a (non-looping) movie has come to its end. */
		public function get isComplete() : Boolean
		{
			return !_currentAnimation.loop && _currentTime >= _currentAnimation.totalTime;
		}

		/** Indicates if the clip is still playing. Returns <code>false</code> when the end
		 *  is reached. */
		public function get isPlaying() : Boolean
		{
			if ( _playing )
				return _currentAnimation.loop || _currentTime < _currentAnimation.totalTime;
			else
				return false;
		}

		/** The total number of frames. */
		public function get numFrames() : int
		{
			return _currentAnimation.textures.length;
		}

		/** Pauses playback. */
		public function pause() : void
		{
			_playing = false;
		}

		/** Starts playback. Beware that the clip has to be added to a juggler, too! */
		public function play( animName : String = "", loop : int = -1, fps : int = -1 ) : void
		{
			if ( animName == "" && _currentAnimation )
			{
				_playing = true;
			}
			else
			{
				if ( _animations[ animName ])
				{
					_currentFrame = 0; // reset to first frame
					_currentAnimation = _animations[ animName ];

					/*if ( fps > -1 )
						_currentAnimation.fps = fps;

					if ( loop > -1 )
						_currentAnimation.loop = loop;*/

					_image.texture = _currentAnimation.textures[ _currentFrame ];
					_playing = true;
				}
				else
				{
					throw new ArgumentError( "Invalid animation name" );
				}
			}
		}

		// playback methods

		public function setCurrentAnimation( animName : String ) : void
		{
			if ( _animations[ animName ])
			{
				_currentFrame = 0; // reset to first frame
				_currentAnimation = _animations[ animName ];
				_image.texture = _currentAnimation.textures[ _currentFrame ];
			}
			else
			{
				throw new ArgumentError( "Invalid animation name" );
			}
		}

		/** Stops playback, resetting "currentFrame" to zero. */
		public function stop() : void
		{
			_playing = false;
			currentFrame = 0;
		}

		// properties  

		/** The total duration of the clip in seconds. */
		public function get totalTime() : Number
		{
			return _currentAnimation.totalTime;
		}
	}
}
