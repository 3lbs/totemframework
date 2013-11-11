package totem.components.input
{
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	import totem.core.TotemComponent;

	public class TouchInputComponent extends TotemComponent
	{
		
		private var _controllers : Vector.<InputController> = new Vector.<InputController>();
		
		public var actionChange : ISignal = new Signal();
		
		public function TouchInputComponent(name:String=null)
		{
			super(name);
		}
		
		
		public function addAction () : void{
			
		}
		
		
		public function addController ( controller : InputController ) : void
		{
			if ( _controllers.lastIndexOf( controller ) < 0 )
				_controllers.push( controller );
		}
	}
}
