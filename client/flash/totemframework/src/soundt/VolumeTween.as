package soundt 
{
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.media.SoundChannel;
	import flash.utils.Dictionary;

	
	/**
	 * ...
	 * @author Jean Mas
	 */
	/**
	 * @private
	 */
	internal class VolumeTween extends EventDispatcher 
	{
		static public var DELAY:uint = 25;
		static private var timers:Dictionary;
		static private var channels:Dictionary;
		static private var timerpool:Vector.<XTimer>;
		
		static public function to(channel:SoundChannel, duration:Number, volume:Number, autostop:Boolean, group:SoundGroup):void
		{
			if (!channel) { return; }
			if (!timers)
			{
				timers = new Dictionary();
			}
			if (!channels)
			{
				channels = new Dictionary();
			}			
			var property:VolumeProperty = new VolumeProperty();
			property.channel = channel;			
			property.transform = channel.soundTransform;
			property.initial = channel.soundTransform.volume;
			property.finalvolume = volume;
			property.duration = duration * 1000;
			property.steps = property.duration / DELAY;	
			property.delay = DELAY;
			property.autostop = autostop;
			property.group = group;			
			var timer:XTimer = getXTimer(DELAY, property.steps);
			timer.addEventListener(TimerEvent.TIMER, handleSteps);
			timer.start();
			timers[timer] = property;
			channels[channel] = timer;
		}
		
		static public function getProperty(channel:SoundChannel, stoptimer:Boolean = true, group:SoundGroup = null):VolumeProperty 
		{
			if (!channels[channel]) 
			{ 
				var newproperty:VolumeProperty = new VolumeProperty();
				for (var currenttimer:* in timers)
				{
					var property:VolumeProperty = timers[currenttimer];
					if (property && property.group.groupname == group.groupname)
					{
						newproperty.channel = channel;								
						newproperty.transform = channel.soundTransform;
						newproperty.initial = channel.soundTransform.volume;
						newproperty.finalvolume = property.finalvolume;
						newproperty.duration = property.duration * 1000;
						newproperty.steps = property.duration / DELAY;	
						newproperty.delay = DELAY;
						newproperty.autostop = property.autostop;
						newproperty.group = group;			
						var timer:XTimer = getXTimer(DELAY, property.steps);
						timer.addEventListener(TimerEvent.TIMER, handleSteps);
						timer.start();
						timers[timer] = newproperty;
						channels[channel] = timer;
						return newproperty;			
					}
				}
			}
			property = timers[channels[channel]];
			if (stoptimer)
			{
				channels[channel].stop();
				addToPool(channels[channel]);				
				delete timers[channels[channel]];
				delete channels[channel];				
			}
			return property;
		}
		
		static public function isFading(channel:SoundChannel):Boolean
		{
			if (!channels) { return false; }
			for (var soundc:* in channels)
			{
				if (soundc == channel)
				{
					return true;
				}				
			}
			return false;
		}
		
		static internal function stop(group:SoundGroup):void
		{			
			for (var timer:* in timers)
			{
				var property:VolumeProperty = timers[timer];				
				if (property.group == group)
				{					
					timer.stop();				
					addToPool(timer);
					property.autostop = true;
					delete timers[channels[property.channel]];
					delete channels[property.channel];
				}
			}
		}
		
		static private function getXTimer(delay:uint, steps:uint):XTimer 
		{
			if (timerpool && timerpool.length)
			{
				var timer:XTimer = timerpool.shift();
				timer.removeListeners();
				timer.reset();
				timer.delay = delay;
				timer.repeatCount = steps;
			}
			return new XTimer(delay, steps);
		}
		
		static private function handleSteps(e:TimerEvent):void 
		{			
			var property:VolumeProperty = timers[e.currentTarget];
			var additionalvalue:Number = (property.finalvolume - property.initial) / property.steps;
			property.transform.volume += additionalvalue;
			property.currentStep = XTimer(e.currentTarget).currentCount;
			if (property.transform.volume > 1)
			{
				property.transform.volume = 1;
			}
			if (property.transform.volume < 0)
			{
				property.transform.volume = 0;
			}
			property.channel.soundTransform = property.transform;
			if (property.currentStep == property.steps)
			{
				XTimer(e.currentTarget).stop();				
				addToPool(XTimer(e.currentTarget));				
			}			
		}
		
		static private function addToPool(xTimer:XTimer):void 
		{
			if (!timerpool)
			{
				timerpool = new Vector.<XTimer>();
			}
			timerpool.push(xTimer);
		}
		
	}

}