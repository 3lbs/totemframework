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

	import flash.events.Event;
	
	import totem.totem_internal;

	public class GroupMonitor extends AbstractMonitorProxy implements IListID
	{

		public static const MAX : int = 0;

		public var data : Object;

		protected var _resources : Vector.<IMonitor>;

		private var _failedCount : int;

		private var processAllowed : int;

		private var runningProcess : int;

		public function GroupMonitor( id : String = "", loadLimit : int = MAX )
		{
			super( id );

			processAllowed = loadLimit;

			_resources = new Vector.<IMonitor>();
		}

		/**
		 *
		 * @param ev
		 * @param eventType
		 */
		public function addDispatcher( monitor : IMonitor, eventType : String = Event.COMPLETE ) : IMonitor
		{
			if ( !monitor )
				return null;

			monitor.addEventListener( eventType, onComplete );
			_resources.push( monitor );

			return monitor;
		}

		override public function destroy() : void
		{
			super.destroy();

			data = null;

			while ( _resources.length )
				_resources.pop().destroy();

			_resources = null;
		}

		public function getItemByID( value : * ) : *
		{

			for each ( var dispatcher : IMonitor in _resources )
			{
				if ( dispatcher.id == value )
					return dispatcher;
			}
			// serach the array for item with id = value;
			return null;
		}

		override public function get isFailed() : Boolean
		{
			return _failedCount > 0;
		}

		public function get list() : Vector.<IMonitor>
		{
			return _resources;
		}

		override public function start() : void
		{
			super.start();

			_failedCount = 0;

			if ( !doStartResource())
			{
				finished();
			}
		}

		/**
		 *
		 * @return
		 */
		public function get totalDispatchers() : int
		{
			return _resources.length;
		}

		/*private function allResourceComplete() : Boolean
		{
			var isComplete : Boolean = true;

			for each ( var proxy : IStartMonitor in _resources )
			{
				if ( !proxy.isComplete())
				{
					isComplete = false;
				}
			}

			return isComplete;
		}*/

		private function doStartResource() : Boolean
		{
			if ( _resources == null || _resources.length == 0 || status == COMPLETE )
				return false;

			var proxy : IMonitor;
			var l : int = _resources.length;
			var i : int;

			var isBuilding : Boolean;

			for ( i = 0; i < _resources.length; ++i )
			{
				proxy = _resources[ i ];

				if ( proxy.status == AbstractMonitorProxy.COMPLETE || proxy.status == AbstractMonitorProxy.FAILED )
				{
					continue;
				}
				else
				{
					// if something is  AbstractMonitorProxy.EMPTY || AbstractMonitorProxy.LOADING)
					isBuilding = true;

					if ( proxy.status == AbstractMonitorProxy.EMPTY )
					{
						// can we start if empty to start again
						if ( processAllowed == 0 || runningProcess < processAllowed )
						{
							if ( proxy is IRequireMonitor )
							{
								if ( IRequireMonitor( proxy ).canStart())
								{
									runningProcess++;
									AbstractMonitorProxy( proxy ).totem_internal::start();
										//wait( 2, proxy.start );
								}
							}
							else
							{
								runningProcess++;
								AbstractMonitorProxy( proxy ).totem_internal::start();
									//wait( 2, proxy.start );
							}
						}
						else
							// too many process runing dont check anymore
							return true;
					}

				}
			}
			return isBuilding;
		}

		private function onComplete( eve : Event ) : void
		{
			var target : IMonitor = eve.target as IMonitor;
			target.removeEventListener( eve.type, onComplete );

			if ( target.isFailed )
			{
				_failedCount += 1;
			}

			runningProcess--;

			// if no resources to start.. FINISH
			if ( !doStartResource())
			{
				finished();
			}
		}
	}
}

