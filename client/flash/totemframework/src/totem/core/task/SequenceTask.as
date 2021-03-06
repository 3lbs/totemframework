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
 * Copyright 2007 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package totem.core.task
{

	import totem.core.task.enum.TaskState;

	/**
	 * A TaskGroup implementation that executes its child Tasks sequentially.
	 * When the last child Task has completed its operation this TaskGroup will fire its
	 * <code>COMPLETE</code> event. If the TaskGroup gets cancelled or suspended the currently active child
	 * task will also be cancelled or suspended in turn.
	 * If a child Task throws an <code>ERROR</code> event and the <code>ignoreChildErrors</code> property
	 * of this TaskGroup is set to false, then the TaskGroup will fire an <code>ERROR</code> event
	 * and will not execute its remaining child tasks.
	 * If the <code>autoStart</code> property of this TaskGroup is set to true, the TaskGroup
	 * will automatically be started if a child task gets added to an empty chain.
	 *
	 * @author Jens Halm
	 */
	public class SequenceTask extends TaskGroup
	{

		private var currentIndex : Number;

		/**
		 * Creates a new TaskGroup.
		 *
		 * @param name an optional name for log output
		 */
		public function SequenceTask( name : String = null, isRestartable : Boolean = true )
		{
			super();

			setName(( name == null ) ? "[SequentialTaskGroup]" : name );
			setRestartable( isRestartable );
		}

		/**
		 * @private
		 */
		override protected function doStart() : void
		{
			currentIndex = 0;
			nextTask();
		}

		/**
		 * @private
		 */
		override protected function handleRemoveAll() : void
		{
			currentIndex = 0;
			
			super.handleRemoveAll();
		}

		/**
		 * @private
		 */
		override protected function handleRemovedTask( t : Task, index : uint ) : void
		{
			if ( index <= currentIndex )
				currentIndex--;
		}

		/**
		 * @private
		 */
		override protected function handleTaskComplete( t : Task ) : void
		{
			currentIndex++;

			if ( state == TaskState.ACTIVE )
			{
				// Chain is already active so we must start the next task immediately
				nextTask();
			}
			else if ( state == TaskState.SUSPENDED && allTasks.getSize() > currentIndex )
			{
				// Add the new task to the activeTasks List so it will be started when resuming the TaskGroup
				activeTasks.append( allTasks.get( currentIndex ));
			}
		}

		private function nextTask() : void
		{

			if ( allTasks.getSize() == currentIndex )
			{
				//logger.info( "Completed all tasks" );
				complete();
			}
			else
			{
				var t : Task = Task( allTasks.get( currentIndex ));
				//logger.info( "Starting next task: " + t );
				startTask( t );
			}
		}
	}

}
