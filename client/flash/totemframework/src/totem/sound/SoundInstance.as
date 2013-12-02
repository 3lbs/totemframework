package totem.sound
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	import totem.totem_internal;
	import totem.events.RemovableEventDispatcher;
	
	/**
	 * CitrusSoundInstance
	 * this class represents an existing sound (playing, paused or stopped)
	 * it holds a reference to the CitrusSound it was created from and
	 * a sound channel. through a CitrusSoundInstance you can tweak volumes and panning
	 * individually instead of CitrusSound wide.
	 * 
	 * a paused sound is still considered active, and keeps a soundChannel alive to be able to resume later.
	 */
	public class SoundInstance extends RemovableEventDispatcher
	{
		use namespace totem_internal;
		
		public var data:Object = { };
		
		protected var _ID:uint = 0;
		protected static var last_id:uint = 0;
		
		protected var _name:String;
		protected var _parentsound:TotemSound;
		protected var _soundTransform:SoundTransform;
		
		protected var _permanent:Boolean = false;
		
		protected var _volume:Number = 1;
		protected var _panning:Number = 0;
		
		protected var _soundChannel:SoundChannel;
		
		protected var _isPlaying:Boolean = false;
		protected var _isPaused:Boolean = false;
		protected var _isActive:Boolean = false;
		protected var _loops:int = 0;
		protected var _loopCount:int = 0;
		protected var _last_position:Number = 0;
		protected var _destroyed:Boolean = false;
		
		//protected var _ce:CitrusEngine;
		
		/**
		 * if autodestroy is true, when the sound ends, destroy will be called instead of just stop().
		 */
		protected var _autodestroy:Boolean;
		
		/**
		 * list of active sound instances
		 */
		protected static var _list:Vector.<SoundInstance> = new Vector.<SoundInstance>();
		
		/**
		 * list of active non permanent sound instances
		 */
		protected static var _nonPermanent:Vector.<SoundInstance> = new Vector.<SoundInstance>();
		
		/**
		 * What to do when no new sound channel is available?
		 * remove the first played instance, the last, or simply don't play the sound.
		 * @see REMOVE_FIRST_PLAYED
		 * @see REMOVE_LAST_PLAYED
		 * @see DONT_PLAY
		 */
		public static var onNewChannelsUnavailable:String = REMOVE_FIRST_PLAYED;
		
		/**
		 * offset to use on all sounds when playing them via Sound.play(startPosition...).
		 * 
		 * If all of your sounds are encoded using the same encoder (that's important otherwise the silence could be variable),
		 * and you are able to identify the amount of silence in ms that there is at the beginning of them,
		 * set startPositionOffset to that value you found.
		 * 
		 * This will get rid of most if not all the gaps in looping and non looping sounds.
		 * 
		 * Warning: it won't get rid of the gaps caused by loading/streaming or event processing.
		 */
		public static var startPositionOffset:Number = 0;
		
		/**
		 * trace all events dispatched from CitrusSoundInstances
		 */
		public static var eventVerbose:Boolean = false;
		
		protected static var _maxChannels:uint = SoundChannelUtil.maxAvailableChannels();
		public static function get maxChannels():uint { return _maxChannels; };
		
		{
			if(maxChannels < 32)
				trace("[CitrusSoundInstance] maximum number of concurrent SoundChannels for this instance of CitrusEngine :", maxChannels);
		}
		
		public function SoundInstance(parentsound:TotemSound, autoplay:Boolean = true, autodestroy:Boolean = true)
		{
			_parentsound = parentsound;
			_permanent = _parentsound.permanent;
			_soundTransform = _parentsound.refreshSoundTransform();
			
			_ID = last_id++;
			
			//_parentsound.addDispatchChild(this);
			
			_name = _parentsound.name;
			_loops = _parentsound.loops;
			_autodestroy = autodestroy;
			
			if (autoplay)
				play();
		}
		
		public function play():void
		{
			if (_destroyed)
				return;
			
			if (!_isPaused || !_isPlaying)
				playAt(startPositionOffset);
		}
		
		public function playAt(position:Number):void
		{
			if (_destroyed)
				return;
				
			var soundInstance:SoundInstance;
			
			//check if the same CitrusSound is already playing and is permanent (if so, no need to play a second one)
			if (_permanent)
				for each(soundInstance in _list)
					if (soundInstance._name == this._name)
					{
						dispatcher(TotemSoundEvent.NO_CHANNEL_AVAILABLE);
						stop(true);
						return;
					}
			
			//check if channels are available, if not, free some up (as long as instances are not permanent)
			if (_list.length >= maxChannels)
			{
				var len:int;
				var i:int;
				switch (onNewChannelsUnavailable)
				{
					case REMOVE_FIRST_PLAYED: 
							for (i = 0; i < _nonPermanent.length - 1; i++)
							{
								soundInstance = _nonPermanent[i];
								if (soundInstance && !soundInstance.isPaused)
									soundInstance.stop(true);
								if (_list.length + 1 > _maxChannels)
										i = 0;
								else
									break;
							}
						break;
					case REMOVE_LAST_PLAYED: 
							for (i = _nonPermanent.length-1; i > -1; i--)
							{
								soundInstance = _nonPermanent[i];
								if (soundInstance && !soundInstance.isPaused)
									soundInstance.stop(true);
								if (_list.length + 1 > _maxChannels)
										i = _nonPermanent.length-1;
								else
									break;
							}
						break;
					case DONT_PLAY: 
							dispatcher(TotemSoundEvent.NO_CHANNEL_AVAILABLE);
							stop(true);
						return;
				}
			}
			
			if (!_parentsound.ready)
			{
				dispatcher(TotemSoundEvent.SOUND_NOT_READY);
				_parentsound.load();
			}
			
			if (_list.length >= _maxChannels)
			{
				dispatcher(TotemSoundEvent.NO_CHANNEL_AVAILABLE);
				stop(true);
				return;
			}
			
			_isActive = true;
			
			soundChannel = (_parentsound.sound as Sound).play(position, (_loops < 0) ? int.MAX_VALUE : 0, null);
				
			resetSoundTransform();
				
			_isPlaying = true;
			_isPaused = false;
			
			_list.unshift(this);
			
			if (!_permanent)
				_nonPermanent.unshift(this);
			
			_parentsound.soundInstances.unshift(this);
			
			if ((position == 0 || position == startPositionOffset) && _loopCount == 0)
				dispatcher(TotemSoundEvent.SOUND_START);
		}
		
		public function pause():void
		{
			if (!_isActive)
				return;
			
			_last_position = _soundChannel.position;
			
			_soundChannel.stop();
			soundChannel = _parentsound.sound.play(0, int.MAX_VALUE, SoundChannelUtil.silentST);
			
			_isPlaying = false;
			_isPaused = true;
			
			dispatcher(TotemSoundEvent.SOUND_PAUSE);
		}
		
		public function resume():void
		{
			if (!_isActive)
				return;
			
			_soundChannel.stop();
			soundChannel = _parentsound.sound.play(_last_position, 0, _soundTransform = resetSoundTransform());
			
			_isPlaying = true;
			_isPaused = false;
			
			dispatcher(TotemSoundEvent.SOUND_RESUME);
		}
		
		public function stop(forced:Boolean = false):void
		{
			if (_destroyed)
				return;
				
			if(_soundChannel)
				_soundChannel.stop();
			soundChannel = null;
			
			_isPlaying = false;
			_isPaused = false;
			_isActive = false;
			
			_loopCount = 0;
			
			removeSelfFromVector(_list);
			removeSelfFromVector(_nonPermanent);
			removeSelfFromVector(_parentsound.soundInstances);
			
			if (forced)
				dispatcher(TotemSoundEvent.FORCE_STOP);
			
			dispatcher(TotemSoundEvent.SOUND_END);
			
			if (_autodestroy)
				destroy();
		}
		
		override public function destroy():void
		{
			
			_parentsound = null;
			_soundTransform = null;
			data = null;
			soundChannel = null;
			
			
			super.destroy();
			
		}
		
		
		protected function onComplete(e:Event):void
		{
			
			if (_isPaused)
			{
				soundChannel = _parentsound.sound.play(0, int.MAX_VALUE, SoundChannelUtil.silentST);
				return;
			}
			
			_loopCount++;
			
			if (_loops < 0)
			{
				_soundChannel.stop();
				soundChannel = (_parentsound.sound as Sound).play(startPositionOffset, int.MAX_VALUE, resetSoundTransform());
			}
			else if (_loopCount > _loops)
				stop();
			else
			{
				_soundChannel.stop();
				soundChannel = (_parentsound.sound as Sound).play(startPositionOffset, 0, resetSoundTransform());
				dispatcher(TotemSoundEvent.SOUND_LOOP);
			}
		}
		
		public function set volume(value:Number):void
		{
			_volume = value;
			if (_soundChannel)
				_soundTransform = resetSoundTransform();
		}
		
		public function get volume():Number
		{
			return _volume;
		}
		
		public function set panning(value:Number):void
		{
			_panning = value;
			if (_soundChannel)
				_soundTransform = resetSoundTransform();
		}
		
		public function get panning():Number
		{
			return _panning;
		}
		
		public function setVolumePanning(volume:Number = 1, panning:Number = 0):SoundInstance
		{
			_volume = volume;
			_panning = panning;
			resetSoundTransform();
			return this;
		}
		
		/**
		 * removes self from given vector.
		 * @param	list Vector.&lt;CitrusSoundInstance&gt;
		 */
		public function removeSelfFromVector(list:Vector.<SoundInstance>):void
		{
			var i:String;
			for (i in list)
				if (list[i] == this)
				{
					list[i] = null;
					list.splice(int(i), 1);
					return;
				}
		}
		
		/**
		 * a vector of all currently playing CitrusSoundIntance objects
		 */
		public static function get activeSoundInstances():Vector.<SoundInstance>
		{
			return _list.slice();
		}
		
		/**
		 * use this setter when creating a new soundChannel
		 * it will automaticaly add/remove event listeners from the protected _soundChannel
		 */
		internal function set soundChannel(channel:SoundChannel):void
		{
			if (_soundChannel)
				_soundChannel.removeEventListener(Event.SOUND_COMPLETE, onComplete,true);
			if (channel)
				channel.addEventListener(Event.SOUND_COMPLETE, onComplete);
			
			_soundChannel = channel;
		}
		
		public function getSoundChannel():SoundChannel
		{
			return _soundChannel;
		}
		
		internal function get soundChannel():SoundChannel
		{
			return _soundChannel;
		}
		
		public function get leftPeak():Number
		{
			if (_soundChannel)
				return _soundChannel.leftPeak;
			return 0;
		}
		
		public function get rightPeak():Number
		{
			if (_soundChannel)
				return _soundChannel.rightPeak;
			return 0;
		}
		
		public function get parentsound():TotemSound
		{
			return _parentsound;
		}
		
		public function get ID():uint
		{
			return _ID;
		}
		
		public function get isPlaying():Boolean
		{
			return _isPlaying;
		}
		
		public function get isPaused():Boolean
		{
			return _isPaused;
		}
		
		internal function get isActive():Boolean
		{
			return _isActive;
		}
		
		public function get loopCount():uint
		{
			return _loopCount;
		}
		
		public function get loops():int
		{
			return _loops;
		}
		
		/**
		 * dispatches CitrusSoundInstance
		 */
		internal function dispatcher(type:String):void
		{
			var event:Event = new TotemSoundEvent(type, _parentsound, this, ID) as Event;
			dispatchEvent(event);
			if (eventVerbose)
				trace(event);
		}
		
		internal function get destroyed():Boolean
		{
			return _destroyed;
		}
		
		internal function resetSoundTransform():SoundTransform
		{
			var st:SoundTransform = _parentsound.refreshSoundTransform();
			st.volume *= _volume;
			st.pan = _panning;
			if (_soundChannel)
				return _soundTransform = _soundChannel.soundTransform = st;
			else
				return _soundTransform = st;
		}
		
		override public function toString():String
		{
			return "CitrusSoundInstance name:" + _name + " id:" + _ID + " playing:" + _isPlaying + " paused:" + _isPaused + "\n";
		}
		
		public static const REMOVE_LAST_PLAYED:String = "REMOVE_LAST_PLAYED";
		public static const REMOVE_FIRST_PLAYED:String = "REMOVE_FIRST_PLAYED";
		public static const DONT_PLAY:String = "DONT_PLAY";
	}

}