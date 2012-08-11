package totem.core
{

	public class System extends TotemObject implements ITotemSystem
	{
		public function System( name : String = null )
		{
			super( name );
		}

		public function onAdded() : void
		{
		}

		public function onRemoved() : void
		{
		}
		
		override public function initialize() : void
		{
			
		}
		
		// might want to submit for update
		public function update( dt : Number ) : void
		{
		}
	}
}
