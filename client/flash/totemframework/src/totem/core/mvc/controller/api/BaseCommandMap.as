package totem.core.mvc.controller.api
{
	import org.swiftsuspenders.Injector;
	
	import totem.totem_internal;
	import totem.core.Destroyable;

	use namespace totem_internal;
	
	public class BaseCommandMap extends Destroyable implements ICommandMap
	{
		
		/**
		 * The <code>IInjector</code> to inject with
		 */
		protected var injector : Injector;
		
		public function BaseCommandMap()
		{
		}

		public function executeCommand( commandClassOrObject : * ) : void
		{
			var command  : Object = commandClassOrObject;
			
			if ( commandClassOrObject is Class )
				
				
			{
				injector.map( commandClassOrObject );
				command = injector.getInstance( commandClassOrObject );
				injector.unmap( commandClassOrObject );
			}
			else
			{			
				injector.injectInto( command );
			}
			
			command.execute();
			
			//command not complete after execution
			// should add asynccommand
			/*if ( command.hasOwnProperty( "isComplete" ) && !command.isComplete )
			{
				command.onComplete.addOnce( onCommandComplete );
			}*/
			
		}
		
		public function mapCommand ( type : *, commandClass : Class, oneShot : Boolean = false ) : CommandMapping
		{
			
			throw Error( "Must override" );	
			return null;
		}
		
		/*protected function onCommandComplete( command :  Command ) : void
		{
			command.destroy();
			
		}*/
		
		
		override public function destroy():void
		{
			super.destroy();
			
			injector = null;
		}
	}
}
