package soundt 
{
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	/**
	 * ...
	 * @author Jean Mas
	 */
	/**
	 * @private
	 */
	internal class VolumeProperty 
	{
		public var channel:SoundChannel;
		public var initial:Number;
		public var transform:SoundTransform;
		public var finalvolume:Number;
		public var steps:uint;
		public var duration:uint;
		public var currentStep:uint;
		public var delay:uint;
		public var autostop:Boolean;
		public var group:SoundGroup;
		
		public function VolumeProperty() 
		{
			
		}
		
	}

}