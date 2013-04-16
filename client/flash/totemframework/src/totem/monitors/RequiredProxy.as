package totem.monitors
{
	
	public class RequiredProxy extends AbstractMonitorProxy implements IRequireMonitor
	{
		private var _requires : Vector.<IStartMonitor>;

		public function RequiredProxy( id : String = "" )
		{
			super( id );

			_requires = new Vector.<IStartMonitor>();

		}

		public function requires( ... args ) : void
		{
			for each ( var obj : IStartMonitor in args )
			{
				_requires.push( obj );
			}
		}

		public function canStart() : Boolean
		{
			// you dont want to start a loading or complete proxy again
			if ( status != AbstractMonitorProxy.EMPTY )
			{
				return false;
			}

			// test all the dependent proxy are ready
			for each ( var proxy : IStartMonitor in _requires )
			{
				if ( proxy.isComplete() == false )
				{
					return false;
				}
			}

			return true;
		}

		public function getItemByID( value : * ) : *
		{

			for each ( var dispatcher : IStartMonitor in _requires )
			{
				if ( dispatcher.id == value )
					return dispatcher;
			}
			// serach the array for item with id = value;
			return null;
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
