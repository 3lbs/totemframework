package soundt 
{
	
	/**
	* Copyright © 2010. aswebcreations.com. All Rights Reserved.
	* @playerversion Flash 9.0, Flash 10
	* @langversion 3.0
	* @version A.1.0.0
	*/ 
	
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.media.SoundLoaderContext;
    import flash.media.SoundTransform;
    import flash.net.URLRequest;
	
	
/**
 * @private
 */

	/**
	* The SoundObject class is used internally by the Soundmanager class for creating Sound objects.
	* 
	* <p>Create an instance of the SoundObject class that way:</p>
	* <listing>
	* 
	* 
	* </listing>
	*
	* @playerversion Flash 9
	* @langversion 3.0
	*/
	
	
	internal class SoundObject extends EventDispatcher 
	{
		
		public var loadcontext:SoundLoaderContext;   					
		public var name:String;		
		public var volume:Number = 1;	
		public var classref:Class;	
		public var group:SoundGroup;	
		private var _isPaused:Boolean;
		private var _isMuted:Boolean;
		
		private var _url:String;
		private var _autoload:Boolean;	
		private var sound:Sound;
		internal var channel:SoundChannel;
		private var _isPlaying:Boolean;
		private var channels:Vector.<SoundChannel>

	 
		public function SoundObject(name:String) 
		{
			this.name = name;  
        	channels = new Vector.<SoundChannel>();
		}
		
		public function stop():void 
		{
			for (var i:int = 0; i < channels.length; i++ )
			{
				channels[i].stop();
				channels[i].removeEventListener(Event.SOUND_COMPLETE, handleComplete);
			}
			isPlaying = false;
			channels = new Vector.<SoundChannel>();
		}
		
		public function get autoload():Boolean 
		{
			return _autoload;
		}
		
		public function set autoload(value:Boolean):void 
		{
			_autoload = value;
			if (autoload)
			{
				if (url && !sound)
				{
					sound = new Sound();
					sound.addEventListener(IOErrorEvent.IO_ERROR, handleError);
					sound.load(new URLRequest(url), loadcontext);
				}
			}
		}
		
		public function get url():String 
		{
			return _url;
		}
		
		public function set url(value:String):void 
		{
			_url = value;		
			if (autoload && !sound)
			{				
				sound = new Sound();
				sound.addEventListener(IOErrorEvent.IO_ERROR, handleError);
				sound.load(new URLRequest(url), loadcontext);				
			}
		}
		
		public function get isPlaying():Boolean 
		{
			return _isPlaying;
		}
		
		public function set isPlaying(value:Boolean):void 
		{
			_isPlaying = value;
			if (value)
			{
				if (channel)
				{
					channel.addEventListener(Event.SOUND_COMPLETE, handleComplete);
				}
			}
			else
			{
				if (channel)
				{
					channel.removeEventListener(Event.SOUND_COMPLETE, handleComplete);
				}
			}
		}
		
		public function get isMuted():Boolean 
		{
			return _isMuted;
		}
		
		public function set isMuted(value:Boolean):void 
		{
			_isMuted = value;
		}
		
		public function get isPaused():Boolean 
		{
			return _isPaused;
		}
		
		public function set isPaused(value:Boolean):void 
		{
			_isPaused = value;
		}
		
		private function handleComplete(e:Event):void 
		{
			isPlaying = false;
		}

	 /**
     * @private
     */   
        internal function play(startTime:Number  = 0, loops:int = 0, sndTransform:SoundTransform  = null):SoundChannel 
        {
			if (url && !sound)
			{
				sound = new Sound();
				sound.addEventListener(IOErrorEvent.IO_ERROR, handleError);
				sound.load(new URLRequest(url), loadcontext);
				autoload = true;
			}
			else if (classref && !sound)
			{
				sound = new classref();
			}
            channel = sound.play(startTime, loops, sndTransform);   
			if (channel)
			{
				isPlaying = true;
				channels.push(channel);
				sound.removeEventListener(IOErrorEvent.IO_ERROR, handleError);
			}
            return channel; 
        }
        
        private function handleError(e:IOErrorEvent):void 
		{
			SoundManager.throwError("SoundManager Loading Error. Unable to load: " + e.text, name);
            sound.removeEventListener(IOErrorEvent.IO_ERROR, handleError);
        }		
	}
	
}