//------------------------------------------------------------------------------
//
//     _______ __ __           
//    |   _   |  |  |--.-----. 
//    |___|   |  |  _  |__ --| 
//     _(__   |__|_____|_____| 
//    |:  1   |                
//    |::.. . |                
//    `-------'      
//                       
//   3lbs Copyright 2013 
//   For more information see http://www.3lbs.com 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package totem.monitors
{

	public class GroupRequiredMonitor extends GroupMonitor implements IRequireMonitor
	{

		private var _requires : Vector.<IMonitor> = new Vector.<IMonitor>();

		public function GroupRequiredMonitor( id : String = "", loadLimit : int = MAX )
		{
			super( id, loadLimit );
		}

		public function canStart() : Boolean
		{
			// you dont want to start a loading or complete proxy again
			if ( status != AbstractMonitorProxy.EMPTY )
			{
				return false;
			}

			// test all the dependent proxy are ready
			for each ( var proxy : IMonitor in _requires )
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
			super.destroy();

			_requires.length = 0;
			_requires = null;
		}

		public function getRequiredItemByID( value : * ) : *
		{
			for each ( var dispatcher : IMonitor in _requires )
			{
				if ( dispatcher.id == value )
					return dispatcher;
			}
			// serach the array for item with id = value;
			return null;
		}

		public function requires( ... args ) : void
		{

			for each ( var obj : IMonitor in args )
			{
				if ( obj == null )
					continue;

				_requires.push( obj );
			}
		}
	}
}
