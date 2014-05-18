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

	import org.casalib.util.NumberUtil;
	
	import totem.events.RemovableEventDispatcher;

	/**
	 * CitrusSoundGroup represents a volume group with its groupID and has mute control as well.
	 */
	public class TotemSoundGroup extends RemovableEventDispatcher
	{

		public static const BGM : String = "BGM";

		public static const SFX : String = "SFX";

		public static const UI : String = "UI";

		protected var _groupID : String;

		protected var _sounds : Vector.<TotemSound>;

		internal var _mute : Boolean = false;

		internal var _volume : Number = 1;

		public function TotemSoundGroup()
		{
			_sounds = new Vector.<TotemSound>();
		}

		public function getAllSounds() : Vector.<TotemSound>
		{
			return _sounds.slice();
		}

		public function getRandomSound() : TotemSound
		{
			var index : uint = NumberUtil.randomIntegerWithinRange( 0, _sounds.length - 1 );
			return _sounds[ index ];
		}

		public function getSound( name : String ) : TotemSound
		{
			var s : TotemSound;

			for each ( s in _sounds )
				if ( s.name == name )
					return s;
			return null;
		}

		public function get groupID() : String
		{
			return _groupID;
		}

		public function get mute() : Boolean
		{
			return _mute;
		}

		public function set mute( val : Boolean ) : void
		{
			_mute = val;
			applyChanges();
		}

		public function preloadSounds() : void
		{
			var s : TotemSound;

			for each ( s in _sounds )
				if ( !s.loaded )
					s.load();
		}

		public function get volume() : Number
		{
			return _volume;
		}

		public function set volume( val : Number ) : void
		{
			_volume = val;
			applyChanges();
		}

		protected function applyChanges() : void
		{
			var s : TotemSound;

			for each ( s in _sounds )
			{
				s.resetSoundTransform( true );
			}
		}

		protected function handleSoundLoaded( e : TotemSoundEvent ) : void
		{
			var cs : TotemSound;

			for each ( cs in _sounds )
			{
				if ( !cs.loaded )
					return;
			}
			dispatchEvent( new TotemSoundEvent( TotemSoundEvent.ALL_SOUNDS_LOADED, e.sound, null ));
		}

		internal function addSound( s : TotemSound ) : void
		{
			if ( s.group && s.group.isadded( s ))
				( s.group as TotemSoundGroup ).removeSound( s );
			s.setGroup( this );
			_sounds.push( s );
			s.addEventListener( TotemSoundEvent.SOUND_LOADED, handleSoundLoaded );
		}

		internal function destroy() : void
		{
			var s : TotemSound;

			for each ( s in _sounds )
				removeSound( s );
			_sounds.length = 0;
			removeEventListeners();
		}

		internal function isadded( sound : TotemSound ) : Boolean
		{
			var s : TotemSound;

			for each ( s in _sounds )
				if ( sound == s )
					return true;
			return false;
		}

		internal function removeSound( s : TotemSound ) : void
		{
			var si : String;
			var cs : TotemSound;

			for ( si in _sounds )
			{
				if ( _sounds[ si ] == s )
				{
					cs = _sounds[ si ];
					cs.setGroup( null );
					cs.resetSoundTransform( true );
					cs.removeEventListener( TotemSoundEvent.SOUND_LOADED, handleSoundLoaded );
					_sounds.splice( uint( si ), 1 );
					break;
				}
			}
		}
	}

}
