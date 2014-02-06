package soundt
{
	import flash.events.EventDispatcher;
	
	/**
	* Copyright © 2013. aswebcreations.com. All Rights Reserved.
	* @playerversion Flash 10, Flash 11
	* @langversion 3.0
	* @version 4.0.0.0
	*/ 
	
	/**
	* A SoundCategory instance lets you assign a new masterVolume control to a sound or group of sounds.
	* Create a SoundCategory instance and assign it to as many SoundGroup instances as you want.
	* 
	* @example
	* <listing>
	* var soundcategory:SoundCategory = new SoundCategory("SoundEffects");
	* var soundgroup:SoundGroup = SoundManager.getSoundGroup("sound1");
	* soundgroup.category = soundcategory;
	* 
	* //Change this sound group master volume
	* SoundManager.setCategoryVolume("SoundEffects", 0.8);
	* 
	* //reassign the SoundManager masterVolume to this SoundGroup:
	* soundgroup.category = null;
	* 
	* 
	* </listing>
	*
	* @playerversion Flash 10
	* @langversion 3.0
	*/
	public class SoundCategory extends EventDispatcher 
	{		
		public var base:Number = 1;
		/**
		 * @private
		 * The volume of this SoundCategory. (from 0 to 1).
		 */
		
		private var _volume:Number = 1;
		
		/**
		 * The name of this SoundCategory.
		 */
		public var name:String;
		
		public function SoundCategory(name:String) 
		{
			this.name = name;
		}
		
		public function get masterVolume():Number
		{	
			return _volume;			
		}
		
		public function get volume():Number 
		{			
			if (base == 1)
			{
				return _volume;
			}			
			return 	(Math.pow(base, _volume) - 1) / (base-1);			
		}
		
		public function set volume(value:Number):void 
		{
			_volume = value;
		}
		
	}

}