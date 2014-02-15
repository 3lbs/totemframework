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
//   3lbs Copyright 2014 
//   For more information see http://www.3lbs.com 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package totem.observer
{

	import flash.utils.Dictionary;

	import totem.core.Destroyable;

	/**
	 * experimental event dispatcher (wip)
	 * TODO:
	 * - check consistency of bubbling/capturing
	 * - propagation stop ?
	 */
	public class NotifBroadcaster extends Destroyable
	{

		protected var listeners : Dictionary;

		private var index : int;

		public function NotifBroadcaster()
		{
			listeners = new Dictionary();
		}

		/**
		 * Warning: all references to the listener will be strong and you need to remove them explicitly.
		 */
		public function addNotifListener( type : String, listener : Function, addOnce : Boolean = false ) : void
		{
			if ( !listeners[ type ])
				listeners[ type ] = new Vector.<Object>();

			listeners[ type ].push({ func: listener, once: addOnce });
		}

		override public function destroy() : void
		{
			super.destroy();
			removeNotifListeners();
		}

		public function dispatchNotif( notif : Notification ) : void
		{

			var obj : Object;

			if ( notif.type in listeners )
			{
				var list : Vector.<Object> = listeners[ notif.type ];

				for each ( obj in list )
				{
					if ( obj.func.length == 0 )
						obj.func.call();
					else
						obj.func.apply( null, [ notif ]);

					if ( obj.once )
						removeNotifListener( notif.type, obj.func );
				}
			}
		}

		public function dispatchNotifWith( type : String, data : Object = null ) : void
		{
			if ( hasNotifListener( type ))
			{
				var event : Notification = Notification.create( type, data );
				dispatchNotif( event );
				event.dispose();
			}
		}

		public function hasNotifListener( type : String ) : Boolean
		{
			return type in listeners;
		}

		/**
		 * remove listener from all events
		 */
		public function removeListener( listener : Function ) : void
		{
			var i : String;
			var j : String;
			var list : Vector.<Object>;

			for ( i in listeners )
			{
				list = listeners[ i ];

				for ( j in list )
					if ( listener == list[ j ].func )
						list.splice( int( j ), 1 );
			}
		}

		/**
		 * remove all listeners of event
		 */
		public function removeListenersOf( type : String ) : void
		{
			if ( type in listeners )
				delete listeners[ type ];
		}

		public function removeNotifListener( type : String, listener : Function ) : void
		{
			if ( type in listeners )
			{
				var index : String;
				var list : Vector.<Object> = listeners[ type ];

				for ( index in list )
					if ( list[ index ].func == listener )
						list.splice( int( index ), 1 )
			}
		}

		/**
		 * remove all event listeners (clears lists)
		 */
		public function removeNotifListeners() : void
		{
			listeners = new Dictionary();
		}
	}

}
