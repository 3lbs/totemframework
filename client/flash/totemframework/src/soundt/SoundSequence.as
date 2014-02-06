package soundt 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.media.SoundChannel;
	
	/**
	* Copyright © 2013. aswebcreations.com. All Rights Reserved.
	* @playerversion Flash 10, Flash 11
	* @langversion 3.0
	* @version 4.0.0.0
	*/ 
	
	/**
	* The SoundSequence class allows you to play a sequence of sounds with the SOundmanager.
	* You simply create a SoundSequence instance and pass an array of soundnames and time values (for adding time gape between sound) in milliseconds.
	* Typical use:
	* @example
	* <listing>
	* sequence = new SoundSequence([500, "test", 250, "test1", 100, "test2", 600, "test3"]);
	* sequence.addEventListener(SoundManagerEvent.NEW_CHANNEL, handleNewChannel);
	* //each time a new sound play it will dispatch this event which hold a reference to the new SoundChannel.
	* sequence.addEventListener(SoundManagerEvent.END_SEQUENCE, handleEndSequence);
	* sequence.playSequence();
	* </listing>
	*
	* @playerversion Flash 10
	* @langversion 3.0
	*/
		
	public class SoundSequence extends EventDispatcher
	{
		/**
		 * @private
		 */
		internal var _playingvolume:Number;
		private var sequence:Array;		
		private var volume:Number = 1;		
		private var sequencecopy:Array;		
		private var timer:Object;
		private var currentsound:String;
		private var _isPlaying:Boolean;
		private var isStarted:Boolean;
		private var isFinished:Boolean = true;
		
		/**
		 * Create a new SoundSequence instance.
		 * @param	sequence. An Array of valid SoundGroup names and numbers (optional). Number in milliseconds determine the time gap between sounds.
		 */
		public function SoundSequence(sequence:Array) 
		{
			this.sequence = sequence;	
			checkSequence(sequence);
			//timer = new XTimer(200, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, handleSoundComplete);			
		}
		/**
		 * @private
		 * @param	sequence
		 */
		private function checkSequence(sequence:Array):void 
		{
			var valid:Boolean = true;
			for (var i:int = 0; i < sequence.length; i++ )
			{
				if (isNaN(sequence[i]))
				{
					if (!SoundManager.checkSound(sequence[i]))
					{
						valid = false;
					}
				}
			}
			if (!valid)
			{
				SoundManager.throwError("Sequence is not valid: " + sequence.toString());
			}
		}
		/**
		 * Stops this sequence. Sequence won't be able to resume. 
		 */
		public function stop():void
		{
			isPlaying = false;
			isStarted = false;
			sequencecopy = null;
			timer.removeListeners();
			timer.stop();
			if (currentsound)
			{
				SoundManager.getInstance().stop(currentsound);
			}			
		}
		/**
		 * Resume the playing of this sequence if it was paused.
		 */
		public function resume():void 
		{
			if (!sequencecopy) { return; }
			if (currentsound)
			{
				SoundManager.resume(currentsound);
				var channel:SoundChannel = SoundManager.getChannel(currentsound);
				if (channel)
				{
					channel.addEventListener(Event.SOUND_COMPLETE, handleSoundComplete);
					var event:SoundManagerEvent = new SoundManagerEvent(SoundManagerEvent.NEW_CHANNEL);					
					event.channel = channel;					
					dispatchEvent(event);
				}
			}	
			else
			{
				timer.start();
			}
		}
		/**
		 * Play or replay this sequence.
		 */
		public function playSequence():void
		{
			if (isStarted) { return; }
			play();
		}
		/**
		 * @private
		 */
		private function play():void 
		{							
			isStarted = true;		
			if (sequencecopy && !sequencecopy.length) 
			{ 
				isStarted = false;				
				isPlaying = false;
				sequencecopy = null;
				var endevent:SoundManagerEvent = new SoundManagerEvent(SoundManagerEvent.END_SEQUENCE);							
				dispatchEvent(endevent);
				return; 
			}
			if (!sequencecopy)
			{
				sequencecopy = sequence.concat();
			}
			var item:* = sequencecopy.shift();
			if (item is String)
			{
				try
				{			
					var targetvolume:Number = NaN;
					if (!isNaN(playingvolume))
					{
						targetvolume = playingvolume;
					}
					currentsound = item;
					var channel:SoundChannel = SoundManager.getInstance().play(item, targetvolume);
					isPlaying = true;
					channel.addEventListener(Event.SOUND_COMPLETE, handleSoundComplete);
					var event:SoundManagerEvent = new SoundManagerEvent(SoundManagerEvent.NEW_CHANNEL);					
					event.channel = channel;					
					dispatchEvent(event);					
				}
				catch (e:Error)
				{
					play();
				}
			}
			else if (!isNaN(item))
			{
				currentsound = null;
				timer.delay = item;
				timer.addEventListener(TimerEvent.TIMER_COMPLETE, handleSoundComplete);
				timer.start();
			}
			else
			{
				play();
			}
		}
		/**
		 * Pause this sequence.
		 */
		public function pause():void 
		{
			isPlaying = false;
			//sequencecopy = null;
			//timer.removeListeners();
			timer.stop();
			if (currentsound)
			{
				SoundManager.getInstance().pause(currentsound);
			}
		}
		/**
		 * @private
		 * @param	e
		 */
		private function handleSoundComplete(e:Event):void 
		{
			timer.removeListeners();
			play();
		}
		/**
		 * Returns true if this sequence is playing.
		 */
		public function get isPlaying():Boolean 
		{
			return _isPlaying;
		}
		/**
		 * @private
		 */
		public function set isPlaying(value:Boolean):void 
		{
			_isPlaying = value;
		}
		/**
		 * Set a default global volume for this sequence.
		 */
		public function get playingvolume():Number 
		{
			return _playingvolume;
		}
		/**
		 * @private
		 */
		public function set playingvolume(value:Number):void 
		{
			_playingvolume = value;
		}
		
	}

}