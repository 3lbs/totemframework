package totem.time
{

	public class CountDownTimer extends TimeClock
	{
		public function CountDownTimer( totalTime : Number, delay : Number = 1000, repeatCount : int = 0 )
		{
			super( delay, totalTime );
			
			//repeatCount = totalTime;
		}
	}
}
