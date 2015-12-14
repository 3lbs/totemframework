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

package totem.display.starling
{

	import flash.media.Sound;

	import starling.textures.Texture;

	public class Animation
	{

		public var defaultFrameDuration : Number;

		public var durations : Vector.<Number>;

		public var loop : int;

		public var sounds : Vector.<Sound>;

		public var startTimes : Vector.<Number>;

		public var textures : Vector.<Texture>;

		public var totalTime : Number;

		/** An Animation is a single instance of one Animation for an ExtendedMovieClip.
		 */
		public function Animation( list : Vector.<Texture>, fps : Number = 12, loop : int = 0 )
		{
			if ( list.length > 0 )
			{
				this.loop = loop;
				defaultFrameDuration = 1.0 / fps;
				totalTime = 0.0;
				textures = new <Texture>[];
				sounds = new <Sound>[];
				durations = new <Number>[];
				startTimes = new <Number>[];

				for ( var i : int = 0; i < list.length; i++ )
				{
					addFrameAt( i, list[ i ]);
				}
			}
			else	
			{
				throw new ArgumentError( "Empty texture array" );
			}
		}

		/** Adds a frame at a certain index, optionally with a sound and a custom duration. */
		public function addFrameAt( frameID : int, texture : Texture, sound : Sound = null, duration : Number = -1 ) : void
		{
			if ( frameID < 0 || frameID > textures.length )
				throw new ArgumentError( "Invalid frame id" );

			if ( duration < 0 )
				duration = defaultFrameDuration;

			textures.splice( frameID, 0, texture );
			sounds.splice( frameID, 0, sound );
			durations.splice( frameID, 0, duration );
			totalTime += duration;

			if ( frameID > 0 && frameID == textures.length )
				startTimes[ frameID ] = startTimes[ frameID - 1 ] + durations[ frameID - 1 ];
			else
				updateStartTimes();
		}

		public function dispose() : void
		{
			textures = null;
			sounds = null;
			durations = null;
			startTimes = null;
		}

		/** The default number of frames per second. Individual frames can have different
		 *  durations. If you change the fps, the durations of all frames will be scaled
		 *  relatively to the previous value. */
		public function get fps() : Number
		{
			return 1.0 / defaultFrameDuration;
		}

		public function set fps( value : Number ) : void
		{
			var newFrameDuration : Number = value == 0.0 ? Number.MAX_VALUE : 1.0 / value;
			var acceleration : Number = newFrameDuration / defaultFrameDuration;
			defaultFrameDuration = newFrameDuration;

			for ( var i : int = 0; i < textures.length; ++i )
				setFrameDuration( i, getFrameDuration( i ) * acceleration );
		}

		/** Returns the duration of a certain frame (in seconds). */
		public function getFrameDuration( frameID : int ) : Number
		{
			if ( frameID < 0 || frameID >= textures.length )
				throw new ArgumentError( "Invalid frame id" );
			return durations[ frameID ];
		}

		/** Returns the sound of a certain frame. */
		public function getFrameSound( frameID : int ) : Sound
		{
			if ( frameID < 0 || frameID >= textures.length )
				throw new ArgumentError( "Invalid frame id" );
			return sounds[ frameID ];
		}

		/** Returns the texture of a certain frame. */
		public function getFrameTexture( frameID : int ) : Texture
		{
			if ( frameID < 0 || frameID >= textures.length )
				throw new ArgumentError( "Invalid frame id" );
			return textures[ frameID ];
		}

		/** Sets the duration of a certain frame (in seconds). */
		public function setFrameDuration( frameID : int, duration : Number ) : void
		{
			if ( frameID < 0 || frameID >= textures.length )
				throw new ArgumentError( "Invalid frame id" );
			totalTime -= getFrameDuration( frameID );
			totalTime += duration;
			durations[ frameID ] = duration;
			updateStartTimes();
		}

		/** Sets the sound of a certain frame. The sound will be played whenever the frame
		 *  is displayed. */
		public function setFrameSound( frameID : int, sound : Sound ) : void
		{
			if ( frameID < 0 || frameID >= textures.length )
				throw new ArgumentError( "Invalid frame id" );
			sounds[ frameID ] = sound;
		}

		/** Sets the texture of a certain frame. */
		public function setFrameTexture( frameID : int, texture : Texture ) : void
		{
			if ( frameID < 0 || frameID >= textures.length )
				throw new ArgumentError( "Invalid frame id" );
			textures[ frameID ] = texture;
		}

		private function updateStartTimes() : void
		{
			var numFrames : int = textures.length;

			startTimes.length = 0;
			startTimes[ 0 ] = 0;

			for ( var i : int = 1; i < numFrames; ++i )
				startTimes[ i ] = startTimes[ i - 1 ] + durations[ i - 1 ];
		}
	}
}
