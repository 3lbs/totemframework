package totem.sound 
{
	import org.casalib.util.NumberUtil;
	
	import totem.events.RemovableEventDispatcher;
	import totem.math.MathUtils;

	/**
	 * CitrusSoundGroup represents a volume group with its groupID and has mute control as well.
	 */
	public class TotemSoundGroup extends RemovableEventDispatcher
	{
		
		public static const BGM:String = "BGM";
		public static const SFX:String = "SFX";
		public static const UI:String = "UI";
		
		protected var _groupID:String;
		
		internal var _volume:Number = 1;
		internal var _mute:Boolean = false;
		
		protected var _sounds:Vector.<TotemSound>;
		
		public function TotemSoundGroup() 
		{
			_sounds = new Vector.<TotemSound>();
		}
		
		protected function applyChanges():void
		{
			var s:TotemSound;
			for each(s in _sounds)
				s.refreshSoundTransform();
		}
		
		internal function addSound(s:TotemSound):void
		{
			if (s.group && s.group.isadded(s))
				(s.group as TotemSoundGroup).removeSound(s);
			s.setGroup(this);
			_sounds.push(s);
			s.addEventListener(TotemSoundEvent.SOUND_LOADED, handleSoundLoaded);
		}
		
		internal function isadded(sound:TotemSound):Boolean
		{
			var s:TotemSound;
			for each(s in _sounds)
				if (sound == s)
					return true;
			return false;
		}
		
		public function getAllSounds():Vector.<TotemSound>
		{
			return _sounds.slice();
		}
		
		public function preloadSounds():void
		{
			var s:TotemSound;
			for each(s in _sounds)
				if(!s.loaded)	
					s.load();
		}
		
		internal function removeSound(s:TotemSound):void
		{
			var si:String;
			var cs:TotemSound;
			for (si in _sounds)
			{
				if (_sounds[si] == s)
				{
					cs = _sounds[si];
					cs.setGroup(null);
					cs.refreshSoundTransform();
					cs.removeEventListener(TotemSoundEvent.SOUND_LOADED, handleSoundLoaded);
					_sounds.splice(uint(si), 1);
					break;
				}
			}
		}
		
		public function getSound(name:String):TotemSound
		{
			var s:TotemSound;
			for each(s in _sounds)
				if (s.name == name)
					return s;
			return null;
		}
		
		public function getRandomSound():TotemSound
		{
			var index:uint = NumberUtil.randomIntegerWithinRange(0, _sounds.length - 1);
			return _sounds[index];
		}
		
		protected function handleSoundLoaded(e:TotemSoundEvent):void
		{
			var cs:TotemSound;
			for each(cs in _sounds)
			{
				if (!cs.loaded)
					return;
			}
			dispatchEvent(new TotemSoundEvent(TotemSoundEvent.ALL_SOUNDS_LOADED, e.sound, null));
		}
		
		public function set mute(val:Boolean):void
		{
			_mute = val;
			applyChanges();
		}
		
		public function get mute():Boolean
		{
			return _mute;
		}
		
		public function set volume(val:Number):void
		{
			_volume = val;
			applyChanges();
		}
		
		public function get volume():Number
		{
			return _volume;
		}
		
		public function get groupID():String
		{
			return _groupID;
		}
		
		internal function destroy():void
		{
			var s:TotemSound;
			for each(s in _sounds)
				removeSound(s);
			_sounds.length = 0;
			removeEventListeners();
		}
		
	}

}