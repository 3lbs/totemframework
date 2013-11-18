package totem.monitors.simple
{
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	public class SignalCompleteMonitor extends Signal
	{
		private var numDispatchers:int;
		
		private var completed:int;
		
		public function SignalCompleteMonitor(...parameters)
		{
			super(parameters);
		}
		
		public function addSignal ( signal : ISignal ) : void
		{
			numDispatchers += 1;
			signal.addOnce( handleSignalComplete );
		}
		
		public function get totalDispatchers () : int
		{
			return numDispatchers;
		}
		
		private function handleSignalComplete( o : * = null ):void
		{
			completed += 1;
			
			if ( completed == numDispatchers )
			{
				dispatch();
			}
			
		}
	}
}