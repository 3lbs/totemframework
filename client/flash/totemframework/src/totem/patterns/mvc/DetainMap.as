package totem.patterns.mvc
{
	import flash.utils.Dictionary;

	public class DetainMap implements IDetainMap
	{
		
		protected var detainedCommands : Dictionary;
		
		public function DetainMap()
		{
			detainedCommands = new Dictionary( false );
		}
		
		public function detain( command : Object ) : void
		{
			detainedCommands[ command ] = true;
		}
		
		public function release( command : Object ) : void
		{
			if ( detainedCommands[ command ])
				delete detainedCommands[ command ];
		}
	}
}