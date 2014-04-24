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

package minimvc
{

	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;

	import totem.core.Destroyable;

	public class MiniController extends Destroyable
	{
		/** @private */
		private var _commands : Dictionary = new Dictionary();

		private var _lastEvent : Event;

		private var eventDispatcher : IEventDispatcher;

		public function MiniController( eventDispatcher : IEventDispatcher )
		{
			super();

			this.eventDispatcher = eventDispatcher;
		}

		public function addCommand( commandName : String, command : Class ) : void
		{
			if ( hasCommand( commandName ))
			{
				throw new Error( "Error in " + this + " Command \"" + commandName + "\" already registered." );
			}
			_commands[ commandName ] = command;

			if ( eventDispatcher == null )
				return;

			eventDispatcher.addEventListener( commandName, eventHandler, false, int.MIN_VALUE, true );
		}

		override public function destroy() : void
		{
			for ( var nameCommand : String in _commands )
			{
				removeCommand( nameCommand );
			}
			_commands = null;
			_lastEvent = null;
			eventDispatcher = null;

			super.destroy();
		}


		public function hasCommand( commandName : String ) : Boolean
		{
			if ( !_commands )
				return false;
			return !( _commands[ commandName ] == null || _commands[ commandName ] == undefined );
		}

		/**
		 * Removes a command from the framework.
		 * @param commandName Event type that is used as a command name.
		 * @example
		 * <listing version="3.0">removeCommand(MyEvent.DOSOMETHING);</listing>
		 */
		public function removeCommand( commandName : String ) : void
		{
			if ( !_commands )
				return;

			if ( !hasCommand( commandName ))
			{
				throw new Error( "Error in " + this + " Command \"" + commandName + "\" not registered." );
			}

			_commands[ commandName ] = null;
			delete _commands[ commandName ];

			if ( eventDispatcher == null )
				return;
			eventDispatcher.removeEventListener( commandName, eventHandler, false );
		}

		/** @private */
		private function eventHandler( event : Event ) : void
		{
			if ( hasCommand( event.type ))
			{
				// if the event is equal to the lastEvent, this has already been dispatched for execution
				if ( _lastEvent != event )
				{
					if ( !event.isDefaultPrevented())
					{
						var CommandClass : Class = _commands[ event.type ];
						var command : Object;
						
						command = new CommandClass();
						command.execute( event );
					}
				}
			}
			_lastEvent = null;
		}
	}
}
