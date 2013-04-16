package totem.core
{

	public class System extends TotemObject implements ITotemSystem
	{
		public function System( name : String = null )
		{
			super( name );
		}

		override public function initialize():void
		{
			
		}
		
		override public function destroy():void
		{
			super.destroy();
			
		}
		
		
	}
}
