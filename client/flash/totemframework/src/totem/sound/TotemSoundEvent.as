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

package totem.sound
{

	import flash.events.Event;

	public class TotemSoundEvent extends Event
	{
		public static const ALL_SOUNDS_LOADED : String = "ALL_SOUNDS_LOADED";

		/**
		 * dispatched on any CitrusSoundEvent
		 */
		public static const EVENT : String = "EVENT";

		/**
		 * dispatched when a non permanent sound instance is forced to stop
		 * to leave room for a new one.
		 */
		public static const FORCE_STOP : String = "FORCE_STOP";

		/**
		 * dispatched when no sound channels are available for a sound instance to start
		 */
		public static const NO_CHANNEL_AVAILABLE : String = "NO_CHANNEL_AVAILABLE";

		/**
		 * dispatched when a sound instance ends
		 */
		public static const SOUND_END : String = "SOUND_END";

		/**
		 * CitrusSound related events
		 */
		public static const SOUND_ERROR : String = "SOUND_ERROR";

		public static const SOUND_LOADED : String = "SOUND_LOADED";

		/**
		 * dispatched when a sound instance loops (not when it loops indifinately)
		 */
		public static const SOUND_LOOP : String = "SOUND_LOOP";

		/**
		 * dispatched when a sound instance tries to play but CitrusSound is not ready
		 */
		public static const SOUND_NOT_READY : String = "SOUND_NOT_READY";

		/**
		 * dispatched when a sound instance pauses
		 */
		public static const SOUND_PAUSE : String = "SOUND_PAUSE";

		/**
		 * dispatched when a sound instance resumes
		 */
		public static const SOUND_RESUME : String = "SOUND_RESUME";

		/**
		 * CitrusSoundInstance related events
		 */

		/**
		 * dispatched when a sound instance starts playing
		 */
		public static const SOUND_START : String = "SOUND_START";

		public var error : Boolean;

		public var loaded : Boolean;

		public var loadedRatio : Number;

		public var loopCount : int = 0;

		public var loops : int = 0;

		public var sound : TotemSound;

		public var soundID : int;

		public var soundInstance : TotemSoundInstance;

		public var soundName : String;

		public function TotemSoundEvent( type : String, sound : TotemSound, soundinstance : TotemSoundInstance, soundID : int = -1, bubbles : Boolean = true, cancelable : Boolean = false )
		{
			super( type, bubbles, cancelable );

			if ( sound )
			{
				this.sound = sound;
				soundName = sound.name;
				loadedRatio = sound.loadedRatio;
				loaded = sound.loaded;
				error = sound.ioerror;
			}

			if ( soundinstance )
			{
				this.soundInstance = soundinstance;
				loops = soundinstance.loops;
				loopCount = soundinstance.loopCount;
			}

			this.soundID = soundID;

		/*if(type == SOUND_ERROR || type == SOUND_LOADED || type == ALL_SOUNDS_LOADED)
			setTarget(sound);
		else
			setTarget(soundinstance);*/
		}

		override public function clone() : Event
		{
			return new TotemSoundEvent( type, sound, soundInstance, soundID, bubbles, cancelable ) as Event;
		}

		override public function toString() : String
		{
			return "[TotemSoundEvent type: " + type + " sound: \"" + soundName + "\" ID: " + soundID + " loopCount: " + loopCount + " loops: " + loops + " ]";
		}
	}

}
