package soundt
{
	
	/**
	* Copyright © 2010. aswebcreations.com. All Rights Reserved.
	* @playerversion Flash 9.0, Flash 10
	* @langversion 3.0
	* @version A.0.9.0
	*/ 

	import flash.events.Event;
	import flash.media.SoundChannel;


	/**
	* The SoundManagerEvent class provides a set of specific events dispatched by the SoundManager class or SoundSequence class.
	*
	* @playerversion Flash 9
	* @langversion 3.0
	*/
	
	
	public class SoundManagerEvent extends Event 
	{
		/**
		 * Version of this SoundManagerEvent class.
		 */
		public static const VERSION:String = "2.0";	
		/**
		 * Dispatched by a SoundSequence instance when a new sound is played.
		 */
		static public const NEW_CHANNEL:String = "newChannel";
		/**
		 * Dispatched by a SoundSequence instance when the sequence is done playing.
		 */
		static public const END_SEQUENCE:String = "endSequence";
		/**
		 * Dispatched by the SoundManager when and error occurs with DEBUGMODE = false.
		 */
		static public const SOUNDMANAGER_ERROR:String = "soundmanagerError";
		/**
		 * Dispatched by the SoundManager when and error occurs with DEBUGMODE = false.
		 */
		static public const SOUNDMANAGER_END_FADE:String = "soundmanagerEndFade";
		
		/**
		 * The message of the error
		 */
		public var error:String;	
		/**
		 * The SoundChannel instance.
		 */
		public var channel:SoundChannel;
		/**
		 * The name of the sound that is playing or caused an error.
		 */
		public var soundname:String;
		/**
		 * The position of that sound playhead.
		 */
		public var soundGroup:SoundGroup;
		/**
		 * The position of that sound playhead.
		 */
		public var position:uint;
		/**
		 * The volume of that sound.
		 */
		public var volume:uint;

		/**
		 * Create a new SoundManagerEvent instance.
		 * @param	type Event type.
		 * @param	bubbles Is bubbling?
		 * @param	cancelable Is cancelable?
		 */
	 
		public function SoundManagerEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) 
		{			
			super(type, bubbles, cancelable);			
		}
		
		/**
		 * @private
		 * internal. Returns a cloned event.
		 * @return
		 */
		override public function clone():Event
		{
			var event:SoundManagerEvent = new SoundManagerEvent(type, bubbles, cancelable);			
			event.error = this.error;			
			event.channel = channel;
			event.soundname = soundname;
			event.position = position;
			event.volume = volume;
			return event;
		}
		
	}
	
}