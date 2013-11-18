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
	
	import ladydebug.Logger;
	
	import totem.totem_internal;
	import totem.events.RemovableEventDispatcher;

	public class AbstractMonitorProxy extends RemovableEventDispatcher implements IMonitor
	{

		public static const COMPLETE : int = 2;

		public static const EMPTY : int = 0;

		public static const FAILED : int = 3;

		public static const LOADING : int = 1;

		private var _id : String;

		private var _status : int = EMPTY;

		public function AbstractMonitorProxy( id : String = "" )
		{
			_id = id;
		}

		protected function complete() : void
		{
			_status = COMPLETE;
			dispatchEvent( new Event( Event.COMPLETE ));
		}

		public function get id() : *
		{
			return _id;
		}

		public function set id( value : * ) : void
		{
			_id = value;
		}

		public function isComplete() : Boolean
		{
			return status == COMPLETE;
		}

		public function get isFailed() : Boolean
		{
			return status == FAILED;
		}

		public function start() : void
		{
			_status = LOADING;
		}

		public function get status() : Number
		{
			return _status;
		}

		public function unloadData() : void
		{

		}

		protected function failed() : void
		{

			Logger.error( this, "Complete Monitor Failed", "AbstartMonitorProxy" );
			_status = FAILED;
			dispatchEvent( new Event( Event.COMPLETE ));
		}

		protected function finished() : void
		{
			if ( _status == COMPLETE )
				return;

			complete();
		}

		totem_internal function start() : void
		{
			_status = LOADING;
			start();
		}
	}
}

