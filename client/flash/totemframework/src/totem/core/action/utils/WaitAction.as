package totem.core.action.utils
{

	import totem.core.action.Action;
	import totem.monitors.promise.wait;

	public class WaitAction extends Action
	{
		private var duration_ : Number;

		private var timer_ : Number = -1;

		public function WaitAction( duration : Number )
		{
			if ( duration <= 0 )
				duration = 0;
			duration_ = duration;
			
			//wait( duration, complete );
		}

		override public function update() : void
		{
			if ( timer_ < 0 )
				timer_ = duration_;

			// timer_ -= dt;
			if ( timer_ <= 0 )
				complete();
		}
	}
}
