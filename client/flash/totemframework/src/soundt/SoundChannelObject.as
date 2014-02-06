package  soundt
{
	
	/**
	* Copyright © 2010. aswebcreations.com. All Rights Reserved.
	* @playerversion Flash 9.0, Flash 10
	* @langversion 3.0
	* 
	*/ 
	


	/**
	* The SoundChannelObject class provides ... 
	* 
	* <p>Create an instance of the SoundChannelObject class that way:</p>
	* <listing>
	* 
	* 
	* </listing>
	*
	* @playerversion Flash 9
	* @langversion 3.0
	*/
	
	
	internal class SoundChannelObject 
	{
		
		public var sound:SoundObject;
		public var position:Number;
		public var volume:Number;
		public var isAutoLooping:Boolean;
		internal var isPaused:Boolean;
		internal var isMuted:Boolean;
	/**
     * Creates a new instance of the SoundChannelObject Class.
     *
     * 
     *
     * @playerversion Flash 9
     * @langversion 3.0
     */
	 
		public function SoundChannelObject(sound:SoundObject, position:Number, volume:Number) 
		{
			this.sound = sound;
			this.position = position;	
			this.volume = volume;
		}
		
	}
	
}