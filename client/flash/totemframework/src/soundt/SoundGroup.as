package soundt
{
	import ASWC.utils.Tracer;
	
	/**
	* Copyright © 2013. aswebcreations.com. All Rights Reserved.
	* @playerversion Flash 10, Flash 11
	* @langversion 3.0
	* @version 4.0.0.0
	*/ 
	
	/**
	* A SoundGroup instance let's you modify a sound/sounds behavior.
	* The SoundManager creates those instances for you. Creating an instance of this class will have no effect.
	* 
	* @example
	* <listing>
	* var soundgroup:SoundGroup = SoundManager.getSoundGroup("sound1");//the name of the sound
	* soundgroup.category = new SoundCategory("mymastervolume");
	* trace(soundgroup.groupname)
	* soundgroup.loop = false;
	* soundgroup.overlap = true;
	* soundgroup.overwrite = false;
	* </listing>
	*
	* @playerversion Flash 10
	* @langversion 3.0
	*/
	public class SoundGroup 
	{
		/**
		 * Set to true if you want that sound to loop (will loop until it is stopped or paused).
		 */
		public var loop:Boolean;
		/**
		 * Set true if you want to be able to play that sound as many time as you want (the sound can overlap itself)
		 */
		public var overlap:Boolean;
		/**
		 * Set to true if you want to stop that sound when you try to play it again (takes precedence over overlap).
		 */
		public var overwrite:Boolean;	
		
		private var _groupname:String;
		/**
		 * This SoundGroup category (default to SoundManager). Use category to manage nultiple global masterVolumes.
		 */
		public var category:SoundCategory;
		
		/**
		 * Set the maximum distance at which a sound can be heard
		 */
		public var maxDistance:Number;
		/**
		 * @private
		 */
		public var volume:Number;
		
		/**
		 * @private
		 */
		internal var isFading:Boolean;
		
		private var sounds:Vector.<SoundObject>;
		/**
		 * @private
		 */
		internal var lastPlayed:SoundObject;
		/**
		 * @private
		 * @param	groupname
		 */
		public function SoundGroup(groupname:String) 
		{
			this._groupname = groupname;
			sounds = new Vector.<SoundObject>();
		}
		
		public function getVolume(volume:Number):Number 
		{						
			if (category.base <= 1)
			{
				return volume * category.masterVolume
			}
			return (Math.pow(category.base, volume) - 1) / (category.base-1) * category.masterVolume; 
		}
		/**
		 * Set the current distance so the sound volume can be adjusted.
		 */
		public function set distance(value:Number):void 
		{
			if (isNaN(maxDistance)) { return; }
			var distanceratio:Number = 1;
			if (value > maxDistance)
			{
				distanceratio = 0;
			}
			else
			{
				distanceratio = 1 - (value / maxDistance);
			}			
			SoundManager.setVolume(this.groupname, this.volume * distanceratio);
		}
		/**
		 * @private
		 * @return
		 */
		internal function isSequenceCompatible():Boolean
		{
			if (sounds.length > 1)
			{
				return false;
			}
			if (loop)
			{
				return false;
			}
			return true;
		}
		/**
		 * @private
		 * @param	url
		 * @return
		 */
		internal function hasUrl(url:String):Boolean 
		{
			for (var i:int = 0; i < sounds.length; i++)
			{
				if (sounds[i].url == url)
				{
					return true;
				}
			}
			return false;
		}
		/**
		 * @private
		 * @param	classref
		 * @return
		 */
		internal function hasClass(classref:Class):Boolean 
		{
			for (var i:int = 0; i < sounds.length; i++)
			{
				if (sounds[i].classref == classref)
				{
					return true;
				}
			}
			return false;
		}
		/**
		 * @private
		 * @return
		 */
		internal function getSound():SoundObject 
		{
			var sound:SoundObject = sounds[Math.floor(Math.random() * sounds.length)];			
			lastPlayed = sound;
			return sound;
		}
		/**
		 * @private
		 */
		internal function GC():void 
		{
			sounds = null;
			category = null;
			lastPlayed = null;
			_groupname = null;
		}
		/**
		 * @private
		 */
		internal function stop():void 
		{
			for (var i:int = 0; i < sounds.length; i++)
			{
				sounds[i].stop();				
			}
			VolumeTween.stop(this);
		}
		/**
		 * @private
		 * @param	sound
		 */
		internal function addSound(sound:SoundObject):void 
		{
			sounds.push(sound);
		}
		/**
		 * This SoundGroup name.
		 */
		public function get groupname():String 
		{
			return _groupname;
		}
		
	}

}