package totem.monitors
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import org.casalib.core.IDestroyable;
	import org.casalib.events.RemovableEventDispatcher;
	
	public class CompleteListMonitor extends RemovableEventDispatcher
	{
		
		private var monitorList : Array;
		
		private var completed : int;
		
		public function CompleteListMonitor( target : IEventDispatcher = null )
		{
			super ( target );
			
			monitorList = new Array ();
			completed = 0;
		}
		
		/**
		 *
		 * @param ev
		 * @param eventType
		 */
		public function addDispatcher( ev : IStartMonitor, eventType : String = Event.COMPLETE ) : void
		{
			ev.addEventListener ( eventType, onComplete );
			monitorList.push ( ev );
		}
		
		public function start() : void
		{
			if ( monitorList.length == 0 )
			{
				onMontitorComplete ();
				return;	
			}
			
			for each ( var dispatcher : IStartMonitor in monitorList )
			{
				dispatcher.start ();
			}
		
		}
		
		private function onMontitorComplete():void
		{
			// TODO Auto Generated method stub
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		/**
		 *
		 * @return
		 */
		public function get totalDispatchers() : int
		{
			return monitorList.length;
		}
		
		
		private function onComplete( eve : Event ) : void
		{
			var target : IStartMonitor = eve.target as IStartMonitor;
			target.removeEventListener ( eve.type, onComplete );
			
			completed += 1;
			
			if ( completed >= monitorList.length )
			{
				onMontitorComplete();
			}
		}
		
		public function get list() : Array
		{
			return monitorList;
		}
		
		public function getItemByID ( value : String ) : *
		{
			
			for each ( var dispatcher : IStartMonitor in monitorList )
			{
				if ( dispatcher.id == value )
					return dispatcher;
			}
			// serach the array for item with id = value;
			return null;
		}
		
		override public function destroy() : void
		{
			super.destroy ();
			
			while ( monitorList.length )
				IDestroyable ( monitorList.pop () ).destroy ();
			
			monitorList = null;
		}
	
	}
}

