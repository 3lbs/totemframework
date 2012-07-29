package totem.core.command
{

	import flash.utils.Dictionary;
	
	import org.osflash.signals.ISignal;
	
	import totem.core.TotemObject;
	import totem.data.InList;
	import totem.data.InListIterator;


	public final class CommandMap extends TotemObject
	{
		private var commands_ : InList = new InList();

		protected var signalMap : Dictionary;

		protected var signalClassMap : Dictionary;

		protected var detainedCommands : Dictionary;

		public function CommandMap( name : String = null )
		{
			super( name );

			signalMap = new Dictionary( false );
			signalClassMap = new Dictionary( false );
			detainedCommands = new Dictionary( false );
		}

		public function mapEvent( signal : ISignal, command : Command, oneShot : Boolean = false ) : void
		{

			if ( hasSignalCommand( signal, command ))
				return;
			const signalCommandMap : Dictionary = signalMap[ signal ] ||= new Dictionary( false );
			const callback : Function = function() : void
			{
				routeSignalToCommand( signal, arguments, command, oneShot );
			};

			signalCommandMap[ command ] = callback;
			signal.add( command.execute );

		}

		protected function routeSignalToCommand( signal : ISignal, valueObjects : Array, command : Command, oneshot : Boolean ) : void
		{
			
			//if ( oneshot )
				//unmapSignal( signal, commandClass );
		}

		public function unmapEvent( command : Command ) : void
		{

		}

		internal function executeCommand( command : Command ) : void
		{
			//lower completion flag
			command.isComplete = false;

			//execute command
			command.execute();

			//command not complete after execution
			if ( !command.isComplete )
			{
				command.onComplete.addOnce( onCommandComplete );
			}
		}

		public function hasSignalCommand( signal : ISignal, command : Command ) : Boolean
		{
			var callbacksByCommandClass : Dictionary = signalMap[ signal ];

			if ( callbacksByCommandClass == null )
				return false;

			var callback : Function = callbacksByCommandClass[ command ];
			return callback != null;
		}

		protected function onCommandComplete( command :  Command ) : void
		{
			var iter : InListIterator = commands_.getIterator();
			var command : Command;

			while ( command = iter.data())
			{
				//update command
				//command.update( dt );

				//command complete, remove
				if ( command.isComplete )
					iter.remove();
				//command not complete, next
				else
					iter.next();
			}
		}

		public function detain( command : Object ) : void
		{
			detainedCommands[ command ] = true;
		}

		public function release( command : Object ) : void
		{
			if ( detainedCommands[ command ])
				delete detainedCommands[ command ];
		}
	}
}
