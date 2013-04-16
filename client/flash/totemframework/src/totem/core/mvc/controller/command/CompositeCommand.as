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

package totem.core.mvc.controller.command
{

	import org.swiftsuspenders.Injector;

	internal class CompositeCommand extends AsyncCommand
	{
		internal var childrenCommands : Array = [];

		public function CompositeCommand( commands : Array )
		{
			for ( var i : int = 0, len : int = commands.length; i < len; ++i )
			{
				append( commands[ i ]);
			}
		}

		//internal var commandManager :  ICommandMap;

		/*[Inject]
		public function injectManager( commandManager : ICommandMap ) : void
		{
			this.commandManager = commandManager;
		}*/

		public function append( command : Command ) : void
		{
			childrenCommands.push( command );
		}

		[Inject]
		override public function injectChildren( injector : Injector ) : void
		{
			for ( var i : int = 0, len : int = childrenCommands.length; i < len; ++i )
			{
				var command : Command = childrenCommands[ i ];
				injector.injectInto( command );

				if ( command is AsyncCommand )
					AsyncCommand( command ).injectChildren( injector );
			}
		}
	}
}
