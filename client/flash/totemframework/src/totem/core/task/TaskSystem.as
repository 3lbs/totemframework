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

package totem.core.task
{

	import totem.core.System;

	public class TaskSystem extends System
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
			_tasks.removeTask( task );
		}
	}
}
