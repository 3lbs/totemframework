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

	import flash.events.ErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import totem.events.RemovableEventDispatcher;

	import totem.totem_internal;

	public class TotemSound extends RemovableEventDispatcher
	{
		use namespace totem_internal;

		/**
		 * When the CitrusSound is constructed, it will load itself.
		 */
		public var autoload : Boolean = false;

		public var hideParamWarnings : Boolean = false;

		/**
		 * times to loop :
		 * if negative, infinite looping will be done and loops won't be tracked in CitrusSoundInstances.
		 * if you want to loop infinitely and still keep track of loops, set loops to int.MAX_VALUE instead, each time a loop completes
		 * the SOUND_LOOP event would be fired and loops will be counted.
		 */
		public var loops : int = 0;

		/**
		 * if permanent is set to true, no new CitrusSoundInstance
		 * will stop a sound instance from this CitrusSound to free up a channel.
		 * it is a good idea to set background music as 'permanent'
		 */
		public var permanent : Boolean = false;

		protected var _group : TotemSoundGroup;

		protected var _ioerror : Boolean = false;

		protected var _isPlaying : Boolean = false;

		protected var _loaded : Boolean = false;

		protected var _loadedRatio : Number = 0;

		protected var _mute : Boolean = false;

		protected var _name : String;

		protected var _panning : Number = 0;

		protected var _paused : Boolean = false;

		protected var _sound : Sound;

		protected var _soundTransform : SoundTransform;

		protected var _urlReq : URLRequest;

		protected var _volume : Number = 1;

		/**
		 * a list of all CitrusSoundInstances that are active (playing or paused)
		 */
		internal var soundInstances : Vector.<TotemSoundInstance>;

		public function TotemSound( name : String, params : SoundParam )
		{

			_name = name;

			if ( params[ "sound" ] == null )
				throw new Error( String( String( this ) + " sound " + name + " has no sound param defined." ));

			soundInstances = new Vector.<TotemSoundInstance>();

			setParams( params );

			if ( autoload )
				load();
		}

		/**
		 * creates a sound instance from this CitrusSound.
		 * you can use this CitrusSoundInstance to play at a specific position and control its volume/panning.
		 * @param	autoplay
		 * @param	autodestroy
		 * @return CitrusSoundInstance
		 */
		public function createInstance( autoplay : Boolean = false, autodestroy : Boolean = true ) : TotemSoundInstance
		{
			return new TotemSoundInstance( this, autoplay, autodestroy );
		}

		public function getInstance( index : int ) : TotemSoundInstance
		{
			if ( soundInstances.length > index + 1 )
				return soundInstances[ index ];
			return null;
		}

		public function get group() : *
		{
			return _group;
		}

		public function set group( val : * ) : void
		{
			_group = SoundManager.getInstance().getGroup( val );

			if ( _group )
			{
				_group.addSound( this );
			}
		}

		public function get instances() : Vector.<TotemSoundInstance>
		{
			return soundInstances.slice();
		}

		public function get ioerror() : Boolean
		{
			return _ioerror;
		}

		public function get isPaused() : Boolean
		{
			var soundInstance : TotemSoundInstance;

			for each ( soundInstance in soundInstances )
				if ( soundInstance.isPaused )
					return true;
			return false;
		}

		public function get isPlaying() : Boolean
		{
			var soundInstance : TotemSoundInstance;

			for each ( soundInstance in soundInstances )
				if ( soundInstance.isPlaying )
					return true;
			return false;
		}

		public function load() : void
		{
			unload();

			if ( _urlReq && _loadedRatio == 0 && !_sound.isBuffering )
			{
				_ioerror = false;
				_loaded = false;
				_sound.addEventListener( IOErrorEvent.IO_ERROR, onIOError );
				_sound.addEventListener( ProgressEvent.PROGRESS, onProgress );
				_sound.load( _urlReq );
			}
		}

		public function get loaded() : Boolean
		{
			return _loaded;
		}

		public function get loadedRatio() : Number
		{
			return _loadedRatio;
		}

		public function get mute() : Boolean
		{
			return _mute;
		}

		public function set mute( val : Boolean ) : void
		{
			if ( _mute != val )
			{
				_mute = val;
				resetSoundTransform( true );
			}
		}

		public function get name() : String
		{
			return _name;
		}

		public function get panning() : Number
		{
			return _panning;
		}

		public function set panning( val : Number ) : void
		{
			if ( _panning != val )
			{
				_panning = val;
				resetSoundTransform( true );
			}
		}

		public function pause() : void
		{
			var soundInstance : TotemSoundInstance;

			for each ( soundInstance in soundInstances )
				if ( soundInstance.isPlaying )
					soundInstance.pause();
		}

		public function play() : TotemSoundInstance
		{
			return new TotemSoundInstance( this, true, true );
		}

		public function get ready() : Boolean
		{
			if ( _sound )
			{
				if ( _sound.isURLInaccessible )
					return false;

				if ( _sound.isBuffering || _loadedRatio > 0 )
					return true;
			}
			return false;
		}

		public function resume() : void
		{
			var soundInstance : TotemSoundInstance;

			for each ( soundInstance in soundInstances )
				if ( soundInstance.isPaused )
					soundInstance.resume();
		}

		public function setGroup( val : TotemSoundGroup ) : void
		{
			_group = val;
		}

		public function get sound() : Object
		{
			return _sound;
		}

		public function set sound( val : Object ) : void
		{
			if ( _sound )
			{
				_sound.removeEventListener( IOErrorEvent.IO_ERROR, onIOError );
				_sound.removeEventListener( ProgressEvent.PROGRESS, onProgress );
			}

			if ( val is String )
			{
				_urlReq = new URLRequest( val as String );
				_sound = new Sound();
			}
			else if ( val is Class )
			{
				_sound = new ( val as Class )();
				_ioerror = false;
				_loadedRatio = 1;
				_loaded = true;
			}
			else if ( val is Sound )
			{
				_sound = val as Sound;
				_loadedRatio = 1;
				_loaded = true;
			}
			else if ( val is URLRequest )
			{
				_urlReq = val as URLRequest;
				_sound = new Sound();
			}
			else
				throw new Error( "CitrusSound, " + val + "is not a valid sound paramater" );
		}

		public function get soundTransform() : SoundTransform
		{
			return _soundTransform;
		}

		public function stop() : void
		{
			var soundInstance : TotemSoundInstance;

			for each ( soundInstance in soundInstances )
				if ( soundInstance.isPlaying || soundInstance.isPaused )
					soundInstance.stop();
		}

		public function unload() : void
		{
			if ( _sound.isBuffering )
				_sound.close();
			_sound.removeEventListener( IOErrorEvent.IO_ERROR, onIOError );
			_sound.removeEventListener( ProgressEvent.PROGRESS, onProgress );
			sound = _urlReq;
		}

		public function get volume() : Number
		{
			return _volume;
		}

		public function set volume( val : Number ) : void
		{
			if ( _volume != val )
			{
				_volume = val;
				resetSoundTransform( true );
			}
		}

		protected function onIOError( event : ErrorEvent ) : void
		{
			unload();
			trace( "CitrusSound Error Loading: ", this.name );
			_ioerror = true;
			dispatchEvent( new TotemSoundEvent( TotemSoundEvent.SOUND_ERROR, this, null ));
		}

		protected function onProgress( event : ProgressEvent ) : void
		{
			_loadedRatio = _sound.bytesLoaded / _sound.bytesTotal;

			if ( _loadedRatio == 1 )
			{
				_loaded = true;
				dispatchEvent( new TotemSoundEvent( TotemSoundEvent.SOUND_LOADED, this, null ));
			}
		}

		protected function setParams( params : SoundParam ) : void
		{
			group = params.group;

			loops = params.loops;

			mute = params.mute;

			panning = params.panning;

			permanent = params.permanent;

			volume = params.volume;

			sound = params.sound;

		}

		internal function destroy() : void
		{
			if ( _sound )
			{
				_sound.removeEventListener( IOErrorEvent.IO_ERROR, onIOError );
				_sound.removeEventListener( ProgressEvent.PROGRESS, onProgress );
			}

			if ( _group )
				_group.removeSound( this );
			_soundTransform = null;
			_sound = null;

			var soundInstance : TotemSoundInstance;

			for each ( soundInstance in soundInstances )
				soundInstance.stop();

			removeEventListeners();
			//_ce.sound.removeDispatchChild( this );
		}

		internal function resetSoundTransform( applyToInstances : Boolean = false ) : SoundTransform
		{
			if ( _soundTransform == null )
				_soundTransform = new SoundTransform();

			if ( _group != null )
			{
				_soundTransform.volume = ( _mute || _group._mute || soundPlayer.masterMute ) ? 0 : _volume * _group._volume * soundPlayer.masterVolume;
				_soundTransform.pan = _panning;

			}
			else
			{
				_soundTransform.volume = ( _mute || soundPlayer.masterMute ) ? 0 : _volume * soundPlayer.masterVolume;
				_soundTransform.pan = _panning;
			}

			if ( applyToInstances )
			{
				var soundInstance : TotemSoundInstance;

				for each ( soundInstance in soundInstances )
					soundInstance.resetSoundTransform( false );
			}

			return _soundTransform;
		}
	}

}
