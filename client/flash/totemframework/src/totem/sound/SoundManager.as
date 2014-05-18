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

	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.utils.Dictionary;
	
	import aze.motion.eaze;
	
	import totem.events.RemovableEventDispatcher;
	import totem.sound.groups.BGMGroup;
	import totem.sound.groups.SFXGroup;
	import totem.sound.groups.UIGroup;

	public class SoundManager extends RemovableEventDispatcher
	{

		internal static var _instance : SoundManager;

		public static function getInstance() : SoundManager
		{
			if ( !_instance )
				_instance = new SoundManager();

			return _instance;
		}

		protected var _masterMute : Boolean = false;

		protected var _masterVolume : Number = 1;

		protected var soundGroups : Vector.<TotemSoundGroup>;

		protected var soundsDic : Dictionary;

		public function SoundManager()
		{

			soundsDic = new Dictionary();
			soundGroups = new Vector.<TotemSoundGroup>();

			//default groups
			soundGroups.push( new BGMGroup());
			soundGroups.push( new SFXGroup());
			soundGroups.push( new UIGroup());

			addEventListener( TotemSoundEvent.SOUND_LOADED, handleSoundLoaded );

		}

		/**
		 * add your own custom CitrusSoundGroup here.
		 */
		public function addGroup( group : TotemSoundGroup ) : void
		{
			soundGroups.push( group );
		}

		/**
		 * Register a new sound an initialize its values with the params objects. Accepted parameters are:
		 * <ul><li>sound : a url, a class or a Sound object.</li>
		 * <li>volume : the initial volume. the real final volume is calculated like so : volume x group volume x master volume.</li>
		 * <li>panning : value between -1 and 1 - unaffected by group or master.</li>
		 * <li>mute : default false, whether to start of muted or not.</li>
		 * <li>loops : default 0 (plays once) . -1 will loop infinitely using Sound.play(0,int.MAX_VALUE) and a positive value will use an event based looping system and events will be triggered from CitrusSoundInstance when sound complete and loops back</li>
		 * <li>permanent : by default set to false. if set to true, this sound cannot be forced to be stopped to leave room for other sounds (if for example flash soundChannels are not available) and cannot be played more than once . By default sounds can be forced to stop, that's good for sound effects. You would want your background music to be set as permanent.</li>
		 * <li>group : the groupID of a group, no groups are set by default. default groups ID's are CitrusSoundGroup.SFX (sound effects) and CitrusSoundGroup.BGM (background music)</li>
		 * </ul>
		 */
		public function addSound( id : String, params : SoundParam ) : void
		{
			if ( !params.hasOwnProperty( "sound" ))
				throw new Error( "SoundManager addSound() sound:" + id + "can't be added with no sound definition in the params." );

			if ( id in soundsDic )
			{
				trace( this, id, "already exists." );
			}
			else
			{
				soundsDic[ id ] = new TotemSound( id, params );
			}
		}

		public function crossFade( fadeOutId : String, fadeInId : String, tweenDuration : Number = 2 ) : void
		{

			tweenVolume( fadeOutId, 0, tweenDuration );
			tweenVolume( fadeInId, 1, tweenDuration );
		}

		override public function destroy() : void
		{
			var csg : TotemSoundGroup;

			for each ( csg in soundGroups )
				csg.destroy();

			var s : TotemSound;

			for each ( s in soundsDic )
				s.destroy();

			soundsDic = null;
			_instance = null;

			removeEventListeners();

			super.destroy();
		}

		/**
		 * return group of id 'name' , defaults would be SFX or BGM
		 * @param	name
		 * @return CitrusSoundGroup
		 */
		public function getGroup( name : String ) : TotemSoundGroup
		{
			var sg : TotemSoundGroup;

			for each ( sg in soundGroups )
			{
				if ( sg.groupID == name )
					return sg;
			}
			trace( this, "getGroup() : group", name, "doesn't exist." );
			return null;
		}

		/**
		 * returns a CitrusSound object. you can use this reference to change volume/panning/mute or play/pause/resume/stop sounds without going through SoundManager's methods.
		 */
		public function getSound( name : String ) : TotemSound
		{
			if ( name in soundsDic )
				return soundsDic[ name ];
			else
				trace( this, "getSound() : sound", name, "doesn't exist." );
			return null;
		}

		public function get masterMute() : Boolean
		{
			return _masterMute;
		}

		/**
		 * sets the master mute : resets all sound transforms to volume 0 if true, or
		 * returns to normal volue if false : normal volume is masterVolume*groupVolume*soundVolume
		 */
		public function set masterMute( val : Boolean ) : void
		{
			if ( val != _masterMute )
			{
				_masterMute = val;
				var s : String;

				for ( s in soundsDic )
					soundsDic[ s ].refreshSoundTransform();
			}
		}

		public function get masterVolume() : Number
		{
			return _masterVolume;
		}

		/**
		 * sets the master volume : resets all sound transforms to masterVolume*groupVolume*soundVolume
		 */
		public function set masterVolume( val : Number ) : void
		{
			var tm : Number = _masterVolume;

			if ( val >= 0 && val <= 1 )
				_masterVolume = val;
			else
				_masterVolume = 1;

			if ( tm != _masterVolume )
			{
				var s : String;

				for ( s in soundsDic )
					soundsDic[ s ].refreshSoundTransform();
			}
		}

		/**
		 * moves a sound to a group - if groupID is null, sound is simply removed from any groups
		 * @param	soundName
		 * @param	groupID ("BGM", "SFX" or custom group id's)
		 */
		public function moveSoundToGroup( soundName : String, groupID : String = null ) : void
		{
			var s : TotemSound;
			var g : TotemSoundGroup;

			if ( soundName in soundsDic )
			{
				s = soundsDic[ soundName ];

				if ( s.group != null )
					s.group.removeSound( s );

				if ( groupID != null )
					g = getGroup( groupID )

				if ( g )
					g.addSound( s );
			}
			else
				trace( this, "moveSoundToGroup() : sound", soundName, "doesn't exist." );
		}

		/**
		 * Cut the SoundMixer. No sound will be heard.
		 */
		public function muteFlashSound( mute : Boolean = true ) : void
		{

			var s : SoundTransform = SoundMixer.soundTransform;
			s.volume = mute ? 0 : 1;
			SoundMixer.soundTransform = s;
		}

		/**
		 * pauses all playing sounds
		 */
		public function pauseAll() : void
		{
			var s : TotemSound;

			for each ( s in soundsDic )
				s.pause();
		}

		public function pauseSound( id : String ) : void
		{
			if ( id in soundsDic )
				TotemSound( soundsDic[ id ]).pause();
			else
				trace( this, "pauseSound() : sound", id, "doesn't exist." );
		}

		public function playSound( id : String ) : TotemSoundInstance
		{
			if ( id in soundsDic )
				return TotemSound( soundsDic[ id ]).play();
			else
				trace( this, "playSound() : sound", id, "doesn't exist." );
			return null;
		}

		public function preloadAllSounds() : void
		{
			var cs : TotemSound;

			for each ( cs in soundsDic )
				cs.load();
		}

		public function removeAllSounds( ... except ) : void
		{

			var killSound : Boolean;

			for each ( var cs : TotemSound in soundsDic )
			{

				killSound = true;

				for each ( var soundToPreserve : String in except )
				{

					if ( soundToPreserve == cs.name )
					{
						killSound = false;
						break;
					}
				}

				if ( killSound )
					removeSound( cs.name );
			}
		}

		/**
		 * removes a group and detaches all its sounds - they will now have their default volume modulated only by masterVolume
		 */
		public function removeGroup( groupID : String ) : void
		{
			var g : TotemSoundGroup = getGroup( groupID );
			var i : int = soundGroups.lastIndexOf( g );

			if ( i > -1 )
			{
				soundGroups.splice( i, 1 );
				g.destroy();
			}
			else
				trace( "Sound Manager : group", groupID, "not found for removal." );
		}

		public function removeSound( id : String ) : void
		{
			stopSound( id );

			if ( id in soundsDic )
			{
				TotemSound( soundsDic[ id ]).destroy();
				soundsDic[ id ] = null;
				delete soundsDic[ id ];
			}
			else
				trace( this, "removeSound() : sound", id, "doesn't exist." );
		}

		/**
		 * resumes all paused sounds
		 */
		public function resumeAll() : void
		{
			var s : TotemSound;

			for each ( s in soundsDic )
				s.resume();
		}

		public function resumeSound( id : String ) : void
		{
			if ( id in soundsDic )
				TotemSound( soundsDic[ id ]).resume();
			else
				trace( this, "resumeSound() : sound", id, "doesn't exist." );
		}

		/**
		 * set mute of a sound : if set to mute, neither the group nor the master volume will affect this sound of course.
		 */
		public function setMute( id : String, mute : Boolean ) : void
		{
			if ( id in soundsDic )
				soundsDic[ id ].mute = mute;
			else
				trace( this, "setMute() : sound", id, "doesn't exist." );
		}

		/**
		 * set pan of an individual sound (not affected by group or master
		 */
		public function setPanning( id : String, panning : Number ) : void
		{
			if ( id in soundsDic )
				soundsDic[ id ].panning = panning;
			else
				trace( this, "setPanning() : sound", id, "doesn't exist." );
		}

		/**
		 * set volume of an individual sound (its group volume and the master volume will be multiplied to it to get the final volume)
		 */
		public function setVolume( id : String, volume : Number ) : void
		{
			if ( id in soundsDic )
				soundsDic[ id ].volume = volume;
			else
				trace( this, "setVolume() : sound", id, "doesn't exist." );
		}

		/**
		 * tells if the sound is added in the list.
		 * @param	id
		 * @return
		 */
		public function soundIsAdded( id : String ) : Boolean
		{
			return ( id in soundsDic );
		}

		public function soundIsPaused( sound : String ) : Boolean
		{
			if ( sound in soundsDic )
				return TotemSound( soundsDic[ sound ]).isPaused;
			else
				trace( this, "soundIsPaused() : sound", sound, "doesn't exist." );
			return false;
		}

		public function soundIsPlaying( sound : String ) : Boolean
		{
			if ( sound in soundsDic )
				return TotemSound( soundsDic[ sound ]).isPlaying;
			else
				trace( this, "soundIsPlaying() : sound", sound, "doesn't exist." );
			return false;
		}

		/**
		 * Stop playing all the current sounds.
		 * @param except an array of soundIDs you want to preserve.
		 */
		public function stopAllPlayingSounds( ... except ) : void
		{

			var killSound : Boolean;
			var cs : TotemSound;

			loop1: for each ( cs in soundsDic )
			{

				for each ( var soundToPreserve : String in except )
					if ( soundToPreserve == cs.name )
						break loop1;

				stopSound( cs.name );
			}
		}

		public function stopSound( id : String ) : void
		{
			if ( id in soundsDic )
				TotemSound( soundsDic[ id ]).stop();
			else
				trace( this, "stopSound() : sound", id, "doesn't exist." );
		}

		/**
		 * tween the volume of a CitrusSound. If callback is defined, its optional argument will be the CitrusSound.
		 * @param	id
		 * @param	volume
		 * @param	tweenDuration
		 * @param	callback
		 */
		public function tweenVolume( id : String, volume : Number = 0, tweenDuration : Number = 2, callback : Function = null ) : void
		{
			if ( soundIsPlaying( id ))
			{

				var totemSound : TotemSound = TotemSound( soundsDic[ id ]);
				var tweenvolObject : Object = { volume: totemSound.volume };

				eaze( tweenvolObject ).to( tweenDuration, { volume: volume }).onUpdate( function() : void
				{
					totemSound.volume = tweenvolObject.volume;
				}).onComplete( function() : void
				{

					if ( callback != null )
						if ( callback.length == 0 )
							callback();
						else
							callback( totemSound );
				});
			}
			else
				trace( "the sound " + id + " is not playing" );
		}

		protected function handleSoundLoaded( e : TotemSoundEvent ) : void
		{
			var cs : TotemSound;

			for each ( cs in soundsDic )
				if ( !cs.loaded )
					return;
			dispatchEvent( new TotemSoundEvent( TotemSoundEvent.ALL_SOUNDS_LOADED, e.sound, null ));
		}
	}
}
