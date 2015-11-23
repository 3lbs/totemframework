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

package totem.core.task
{

	import totem.core.TotemSystem;

	public class TaskSystem extends TotemSystem
	{
		private var _tasks : TaskGroup;

		public function TaskSystem( name : String = null )
		{
			super( name );
		}

		public function addTask( task : Task ) : Task
		{

			if ( !task.restartable )
			{
				task.onCompleted.addOnce( handleTaskComplete );
			}

			_tasks.addTask( task );

			return task;
		}

		override public function destroy() : void
		{

			super.destroy();

			_tasks.destroy();
			_tasks = null;
		}

		public function hasTask( value : Task ) : Boolean
		{
			var l : int = _tasks.size;

			while ( l-- )
			{
				if ( _tasks.getTask( l ) == value )
				{
					return true;
				}
			}

			return false;
		}

		public function hasTaskByName( value : String ) : Boolean
		{
			var l : int = _tasks.size;

			while ( l-- )
			{
				if ( _tasks.getTask( l ).getName() == value )
				{
					return true;
				}
			}

			return false;
		}

		override public function initialize() : void
		{
			_tasks = new SequenceTask( "main" );
			_tasks.autoStart = true;
		}

		public function removeTask( task : Task ) : Task
		{
			_tasks.removeTask( task );
			return task
		}

		private function handleTaskComplete( task : Task ) : void
		{
			if ( _tasks.removeTask( task ))
			{
				task.destroy();
			}
		}
	}
}
