package totem.core.mvc.controller.api
{
	import totem.totem_internal;
	import totem.core.Destroyable;

	use namespace totem_internal;
	
	public class CommandMapping extends Destroyable
	{
		totem_internal var guardsList : Array = new Array();

		totem_internal var playOnce : Boolean = false;
		
		public var callback : Function;
		
		public function CommandMapping()
		{
		}

		public function guards( ... args ) : CommandMapping
		{
			guardsList = guardsList.concat( args );
			return this;
		}
		
		override public function destroy():void
		{
			super.destroy();
			
			if ( guardsList )
			{
				guardsList.length = 0;
				guardsList = null;
			}
			
			callback = null;
		}
		
		public function playOnce ( value : Boolean ) : CommandMapping
		{
			
			totem_internal::playOnce = value;
		
			return this;
		}
	}
}
