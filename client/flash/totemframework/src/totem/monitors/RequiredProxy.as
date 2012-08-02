package totem.monitors
{
	import flash.events.IEventDispatcher;
	
	public class RequiredProxy extends AbstractProxy implements IRequireMonitor
	{
		private var _requires : Vector.<IRequireMonitor>;

		public function RequiredProxy(target:IEventDispatcher=null)
		{
			super(target);
			
			_requires = new Vector.<IRequireMonitor>();

		}
		
		public function requires( ... args ) : void
		{
			for each ( var obj : IRequireMonitor in args )
			{
				_requires.push( obj );
			}
		}
		
		public function canStart() : Boolean
		{
			// you dont want to start a loading or complete proxy again
			if ( status != EMPTY )
			{
				return false;
			}
			
			// test all the dependent proxy are ready
			for each ( var proxy : IRequireMonitor in _requires )
			{
				if ( proxy.isComplete() == false )
				{
					return false;
				}
			}
			
			return true;
		}
		
		override public function destroy() : void
		{
			if ( !destroyed )
			{				
				super.destroy();
			
				_requires.length = 0;
				_requires = null;
			}
		}
	}
}