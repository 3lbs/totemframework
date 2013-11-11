package totem.components.input
{
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	import totem.core.Destroyable;

	public class InputController extends Destroyable
	{
		
		public var actionEvent : ISignal = new Signal();
		
		public function InputController()
		{
		}
	}
}