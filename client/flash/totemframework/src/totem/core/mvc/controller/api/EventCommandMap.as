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

/*
 * Copyright (c) 2009 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package totem.core.mvc.controller.api
{

	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	
	import org.swiftsuspenders.Injector;
	
	import totem.totem_internal;
	import totem.utils.DestroyUtil;
	import totem.utils.TypeUtility;

	use namespace totem_internal;

	/**
	 * An abstract <code>ICommandMap</code> implementation
	 */
	public class EventCommandMap extends BaseCommandMap
	{
		/**
		 * The <code>IEventDispatcher</code> to listen to
		 */
		protected var eventDispatcher : IEventDispatcher;

		/**
		 * Internal
		 *
		 * TODO: This needs to be documented
		 */
		protected var eventTypeMap : Dictionary;

		/**
		 * Internal
		 *
		 * Collection of command classes that have been verified to implement an <code>execute</code> method
		 */
		protected var verifiedCommandClasses : Dictionary;

		/**
		 * Creates a new <code>CommandMap</code> object
		 *
		 * @param eventDispatcher The <code>IEventDispatcher</code> to listen to
		 * @param injector An <code>IInjector</code> to use for this context
		 * @param reflector An <code>IReflector</code> to use for this context
		 */
		public function EventCommandMap( eventDispatcher : IEventDispatcher, injector : Injector )
		{
			this.eventDispatcher = eventDispatcher;
			this.injector = injector;
			this.eventTypeMap = new Dictionary( false );
			this.verifiedCommandClasses = new Dictionary( false );
		}

		override public function destroy() : void
		{
			super.destroy();

			unmapEvents();

			eventDispatcher = null;

			DestroyUtil.destroyDictionary( eventTypeMap );
			eventTypeMap = null;

			DestroyUtil.destroyDictionary( verifiedCommandClasses );
			verifiedCommandClasses = null;
		}

		/**
		 * @inheritDoc
		 */
		public function execute( commandClass : Class, payload : Object = null, payloadClass : Class = null, named : String = '' ) : void
		{
			verifyCommandClass( commandClass );

			var command : Object;

			// hack for now was double injecting dont know what else to do
			if ( payload != null || payloadClass != null )
			{
				payloadClass ||= TypeUtility.getClass( payload );
				injector.map( payloadClass, named ).toValue( payload );

				command = injector.getOrCreateNewInstance( commandClass );

				injector.unmap( payloadClass, named );

				command.execute();

					//command not complete after execution
					// should add asynccommand
				/*if ( command is AsyncCommand && !command.isComplete )
				{
					command.onComplete.addOnce( onCommandComplete );
				}*/
			}
			else
			{
				executeCommand( command );
			}

		}

		/**
		 * @inheritDoc
		 */
		public function hasEventCommand( eventType : String, commandClass : Class, eventClass : Class = null ) : Boolean
		{
			var eventClassMap : Dictionary = eventTypeMap[ eventType ];

			if ( eventClassMap == null )
				return false;

			var callbacksByCommandClass : Dictionary = eventClassMap[ eventClass || Event ];

			if ( callbacksByCommandClass == null )
				return false;

			return callbacksByCommandClass[ commandClass ] != null;
		}

		//---------------------------------------------------------------------
		//  API
		//---------------------------------------------------------------------

		override public function mapCommand( type : *, commandClass : Class, oneShot : Boolean = false ) : CommandMapping
		{
			return mapEvent( type, commandClass, null, oneShot );
		}

		/**
		 * @inheritDoc
		 */
		public function unmapEvent( eventType : String, commandClass : Class, eventClass : Class = null ) : void
		{
			var eventClassMap : Dictionary = eventTypeMap[ eventType ];

			if ( eventClassMap == null )
				return;

			var callbacksByCommandClass : Dictionary = eventClassMap[ eventClass || Event ];

			if ( callbacksByCommandClass == null )
				return;

			var commandMapping : CommandMapping = callbacksByCommandClass[ commandClass ];

			if ( commandMapping == null )
				return;

			eventDispatcher.removeEventListener( eventType, commandMapping.callback, false );

			commandMapping.destroy();

			delete callbacksByCommandClass[ commandClass ];
		}

		/**
		 * @inheritDoc
		 */
		public function unmapEvents() : void
		{
			for ( var eventType : String in eventTypeMap )
			{
				var eventClassMap : Dictionary = eventTypeMap[ eventType ];

				for each ( var callbacksByCommandClass : Dictionary in eventClassMap )
				{
					for each ( var commandMapping : CommandMapping in callbacksByCommandClass )
					{
						eventDispatcher.removeEventListener( eventType, commandMapping.callback, false );
						commandMapping.destroy();
					}
				}
			}
			eventTypeMap = new Dictionary( false );
		}

		/**
		 * @inheritDoc
		 */
		protected function mapEvent( eventType : String, commandClass : Class, eventClass : Class = null, oneshot : Boolean = false ) : CommandMapping
		{
			verifyCommandClass( commandClass );
			eventClass = eventClass || Event;

			var commandMapping : CommandMapping = new CommandMapping();

			var eventClassMap : Dictionary = eventTypeMap[ eventType ] || ( eventTypeMap[ eventType ] = new Dictionary( false ));

			var callbacksByCommandClass : Dictionary = eventClassMap[ eventClass ] || ( eventClassMap[ eventClass ] = new Dictionary( false ));

			if ( callbacksByCommandClass[ commandClass ] != null )
			{
				//throw new Error( ContextError.E_COMMANDMAP_OVR + ' - eventType (' + eventType + ') and Command (' + commandClass + ')' );
			}
			var callback : Function = function( event : Event ) : void
			{
				routeEventToCommand( event, commandClass, commandMapping, oneshot, eventClass );
			};

			commandMapping.callback = callback;

			eventDispatcher.addEventListener( eventType, callback, false, 0, true );
			callbacksByCommandClass[ commandClass ] = commandMapping;

			return commandMapping;
		}

		/**
		 * Event Handler
		 *
		 * @param event The <code>Event</code>
		 * @param commandClass The Class to construct and execute
		 * @param oneshot Should this command mapping be removed after execution?
		 * @return <code>true</code> if the event was routed to a Command and the Command was executed,
		 *         <code>false</code> otherwise
		 */
		protected function routeEventToCommand( event : Event, commandClass : Class, mapper : CommandMapping, oneshot : Boolean, originalEventClass : Class ) : Boolean
		{
			if ( !( event is originalEventClass ))
				return false;

			if ( mapper && mapper.guardsList.length > 0 )
			{
				var guards : Array = mapper.guardsList;
				var l : int = guards.length;
				var guard : IGuard;
				var i : int;

				for ( i = 0; i < l; ++i )
				{
					guard = new guards[ i ]();

					injector.injectInto( guard );

					if ( !guard.allow())
						return false;
				}
			}
			execute( commandClass, event );

			if ( oneshot )
				unmapEvent( event.type, commandClass, originalEventClass );

			return true;
		}

		//---------------------------------------------------------------------
		//  Internal
		//---------------------------------------------------------------------

		/**
		 * @throws org.robotlegs.base::ContextError
		 */
		protected function verifyCommandClass( commandClass : Class ) : void
		{
			if ( !verifiedCommandClasses[ commandClass ])
			{
				verifiedCommandClasses[ commandClass ] = describeType( commandClass ).factory.method.( @name == "execute" ).length();

				/*if ( !verifiedCommandClasses[ commandClass ])
					throw new ContextError( ContextError.E_COMMANDMAP_NOIMPL + ' - ' + commandClass );*/
			}
		}
	}
}
