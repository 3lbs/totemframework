package totem.time
{

	import flash.utils.clearTimeout;
	import flash.utils.setInterval;

	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import totem.core.Destroyable;

	public class UpdateTimer extends Destroyable
	{
		private var _timer : uint;

		private var isRunning : Boolean;

		public var updateSignal : ISignal = new Signal();

		private var _interval : Number;

		public function UpdateTimer( time : Number )
		{
			super();
			_interval = time;
		}

		public function get interval() : Number
		{
			return _interval;
		}

		public function set interval( value : Number ) : void
		{
			_interval = value;
		}

		public function start() : void
		{
			if ( isRunning )
				return;

			isRunning = true;
			_timer = setInterval( onTick, _interval );
		}

		public function stop() : void
		{
			isRunning = false;
			clearTimeout( _timer );
		}

		private function onTick() : void
		{
			updateSignal.dispatch();
		}

		override public function destroy() : void
		{
			super.destroy();

			if ( isRunning )
				stop();

			updateSignal.removeAll();
			updateSignal = null;
		}
	}
}
