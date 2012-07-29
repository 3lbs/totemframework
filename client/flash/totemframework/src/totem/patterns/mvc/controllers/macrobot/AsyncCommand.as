/*
* Copyright (c) 2010 the original author or authors
*
* Permission is hereby granted to use, modify, and distribute this file
* in accordance with the terms of the license agreement accompanying it.
*/
package totem.patterns.mvc.controllers.macrobot
{
	import org.swiftsuspenders.Injector;
	
	import robotlegs.bender.bundles.mvcs.Command;
	import robotlegs.bender.extensions.commandMap.api.ICommandMap;
	
	import totem.patterns.mvc.IDetainMap;
	import totem.patterns.mvc.controllers.macrobot.core.IAsyncCommand;

	/**
	 * Provides functionality for holding an asynchronous command in memory and dispatching
	 * when the command is complete.
	 */
	public class AsyncCommand extends Command implements IAsyncCommand
	{

		[Inject]
		public var detainMap : IDetainMap;
		
		[Inject]
		public var commandMap : ICommandMap;
		
		[Inject]
		public var injector : Injector;
		
		/**
		 * Registered listeners.
		 */
		protected var listeners : Array;

		/**
		 * Whether the command has finished executing.
		 */
		protected var complete : Boolean = false;

		/**
		 * @inheritDoc
		 */
		public function addCompletionListener( listener : Function ) : void
		{
			listeners ||= [];
			listeners.push( listener );
		}

		/**
		 * @inheritDoc
		 */
		override public function execute() : void
		{
			complete = false; // undo/redo compatibility
			super.execute();

			// Maintain a reference to this command while it executes so it doesn't get
			// garbage collected.
			if ( !complete )
			{
				detainMap.detain( this );
			}
		}

		/**
		 * Notifies any registered listeners of the completion of this command along with
		 * whether or not it was successful.
		 */
		protected function dispatchComplete( success : Boolean ) : void
		{
			complete = true;
			detainMap.release( this );

			for each ( var listener : Function in listeners )
			{
				listener( success );
			}
		}
	}
}
