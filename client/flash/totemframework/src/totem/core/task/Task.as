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

	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import totem.core.Destroyable;
	import totem.core.task.enum.TaskState;

	/**
	 * Abstract base class of the Task Framework representing an asynchronous operation.
	 * This may be an animation, a loading operation, a remote call, WebService invocation
	 * or playback of Video/Audio or anything else with asynchronous nature.
	 * The concrete functionality (loading, animating, etc.) would be implemented in a subclass of Task.
	 * That alone does not generate added value. But thanks to the generic set of events fired
	 * by Task implementations (<code>START</code>, <code>SUSPEND</code>, <code>RESUME</code>,
	 * <code>CANCEL</code>, <code>COMPLETE</code> and <code>ERROR</code>), multiple Tasks can be
	 * chained in a <code>SequentialTaskGroup</code> or executed concurrently in a
	 * <code>ConcurrentTaskGroup</code>. Both classes fire their <code>COMPLETE</code> event when all
	 * their child Tasks have completed and both extend the abstract <code>TaskGroup</code> class.
	 * Since <code>TaskGroup</code> is a subclass of Task itself,
	 * it can be nested too.  This type of nesting can be cumbersome to implement without Tasks
	 * if you work with a lot of different types of asynchronous operations which all have
	 * their individual event sets for notifying observers that they have completed or that an
	 * error occured.
	 *
	 * <p>A minimal subclass of Task would
	 * at least overwrite the <code>doStart</code> method, do its work and then call <code>complete</code>
	 * when the operation is done. The Task class comes with several properties to control
	 * the behaviour. A Task can be <code>restartable</code> or <code>cancelable</code>, if
	 * the <code>suspendable</code> property is true, a Task can be suspended and resumed.
	 * If the <code>skippable</code> property is set, a Task can be forced to move to its
	 * final state (which may make sense in asynchronous operations like animations, but
	 * obviously not in Tasks like loading operations). All these properties are true by
	 * default and are protected so they must be set by subclasses.</p> You can also set
	 * a timeout for the operation or assign it a name for log output.
	 *
	 * @author Jens Halm
	 */
	public class Task extends Destroyable
	{

		public var onCancelled : ISignal = new Signal( Task );

		public var onCompleted : ISignal = new Signal( Task );

		public var onError : ISignal = new Signal( Task );

		public var onFinished : ISignal = new Signal( Task );

		public var onResumed : ISignal = new Signal( Task );

		public var onSkip : ISignal = new Signal( Task );

		public var onStart : ISignal = new Signal( Task );

		public var onSuspend : ISignal = new Signal( Task );

		private var _cancelable : Boolean;

		private var _data : *;

		private var _parent : TaskGroup;

		private var _restartable : Boolean;

		private var _skippable : Boolean;

		private var _state : TaskState;

		private var _suspendable : Boolean;

		private var _timeout : uint;

		private var name : String;

		private var timer : Timer;

		/**
		 * @private
		 */
		public function Task()
		{
			// TODO - include abstract check
			name = "[Task]";
			_state = TaskState.INACTIVE;
			_restartable = true;
			_cancelable = true;
			_suspendable = true;
			_skippable = true;
			_timeout = 0;
			_data = null;
			_parent = null;
		}

		/**
		 * Cancels this Task. For this method to succeed the cancelable property of this Task
		 * must be set to true and the current state of the Task must be <code>ACTIVE</code> or
		 * <code>SUSPENDED</code>.
		 * If this method executes successfully the <code>CANCEL</code> event will be fired.
		 *
		 * @return true if the Task successfully switched its internal state, false if otherwise
		 */
		public function cancel() : Boolean
		{
			if ( !cancelable )
			{
				//logger.error( "Task '" + this + "' is not cancelable" );
				return false;
			}

			if ( _state != TaskState.ACTIVE && _state != TaskState.SUSPENDED )
			{
				//logger.error( "Attempt to cancel Task '" + this + "' in illegal state: " + _state );
				return false;
			}
			cancelTimer();
			_state = ( restartable ) ? TaskState.INACTIVE : TaskState.FINISHED;

			if ( _parent != null && !_parent.pendingCancelation )
			{
				_parent.cancelChild( this );
			}
			else
			{
				fireCancelEvent();
			}
			return true;
		}

		/**
		 * Indicates whether this Task can be cancelled.
		 */
		public function get cancelable() : Boolean
		{
			return _cancelable;
		}

		/**
		 * An arbitrary value associated with this Task.
		 * This may be useful if a Task is nested in a <code>TaskGroup</code>
		 * for example and produces or loads data that is needed by subsequent Tasks.
		 * If the value for this Task is null and the Task has a parent, the
		 * parents data value will be used.
		 */
		public function get data() : *
		{
			return ( _data != null ) ? _data : ( _parent != null ) ? _parent.data : null;
		}

		public function set data( data : * ) : void
		{
			if ( state != TaskState.INACTIVE )
			{
				//logger.error( "Attempt to change data in Task '" + this + "' in illegal state: " + state );
				return;
			}
			_data = data;
		}

		override public function destroy() : void
		{

			onStart.removeAll();
			onStart = null;

			onCompleted.removeAll();
			onCompleted = null;

			onCancelled.removeAll();
			onCancelled = null;

			onSuspend.removeAll();
			onSuspend = null;

			onFinished.removeAll();
			onFinished = null;

			onResumed.removeAll();
			onResumed = null;

			onSkip.removeAll();
			onSkip = null;

			onError.removeAll();
			onError = null;

			if ( timer )
			{
				timer.stop();
				timer = null;
			}

			_parent = null;
			_state = null;

			super.destroy();
		}

		public function getName() : String
		{
			return name;
		}

		/**
		 * The parent of this Task. The value is null if this Task is not nested
		 * in a <code>TaskGroup</code>.
		 */
		public function get parent() : TaskGroup
		{
			return _parent;
		}

		/**
		 * Indicates whether this Task can be restarted. If true the <code>start</code>
		 * method can be invoked again after either the <code>COMPLETE</code>, <code>CANCEL</code>
		 * or <code>ERROR</code> events were fired. If it is false calling <code>start</code> after
		 * these event were fired will cause an Error to be thrown.
		 */
		public function get restartable() : Boolean
		{
			return _restartable;
		}

		/**
		 * Resumes this Task if it is suspended. For this method to succeed the suspendable property of this Task
		 * must be set to true and the current state of the Task must be <code>SUSPENDED</code>.
		 * If this Task is member of a <code>TaskGroup</code> it cannot
		 * be resumed if the parent <code>TaskGroup</code> is still suspended.
		 * If this method executes successfully the <code>RESUME</code> event will be fired.
		 *
		 * @return true if the Task successfully switched its internal state, false if otherwise
		 */
		public function resume() : Boolean
		{
			if ( state != TaskState.SUSPENDED )
			{
				//logger.error( "Attempt to resume Task '" + this + "' in illegal state: " + _state );
				return false;
			}

			if ( _parent != null && _parent.state == TaskState.SUSPENDED )
			{
				//logger.warn( "Unable to resume Task '" + this + "': Parent Collection is suspended" );
				return false;
			}
			_state = TaskState.ACTIVE;
			startTimer();
			//if (_parent != null) {
			//Internal.invoke(_parent, "resumeChild", [this]);
			//} else {
			fireResumeEvent();
			//}
			return true;
		}

		/**
		 * Forces this Task to move to its final state.
		 * If this method executes successfully the <code>COMPLETE</code> event will be fired.
		 * The method is somewhat similar to the <code>cancel</code> method but with a few subtle
		 * differences:
		 * <ul>
		 * <li>The semantics of <code>cancel</code> would imply that the asynchronous operation just aborts
		 * and optionally rewinds to its initial state. In constrast the semantics of <code>skip</code>
		 * would rather imply to move the operation to its final state and skip the remaining progress.
		 * This is applicable for operations like animations, but
		 * obviously not feasible in Tasks like loading operations.</li>
		 * <li>To underline the different semantics the <code>cancel</code> method would cause a
		 * <code>CANCEL</code> event to be fired, while the <code>skip</code> method would just cause a
		 * <code>COMPLETE</code> event to be fired as if the Task completed normally.</li>
		 * </ul>
		 *
		 * @return true if the Task successfully switched its internal state, false if otherwise
		 */
		public function skip() : Boolean
		{
			if ( !skippable )
			{
				//logger.error( "Task '" + this + "' is not skippable" );
				return false;
			}

			if ( _state != TaskState.ACTIVE && _state != TaskState.SUSPENDED )
			{
				//logger.error( "Attempt to skip Task '" + this + "' in illegal state: " + _state );
				return false;
			}
			cancelTimer();
			_state = ( restartable ) ? TaskState.INACTIVE : TaskState.FINISHED;

			if ( _parent != null && !_parent.pendingCancelation )
			{
				_parent.completeChild( this, true );
			}
			else
			{
				fireSkipEvent();
			}
			return true;
		}

		/**
		 * Indicates whether this Task can be forced to skip to its final state.
		 * This may be useful in asynchronous operations like animations, but
		 * not in Tasks like loading operations. For the difference between
		 * <code>cancelable</code> and <code>skippable</code> see
		 * <a href="#skip()">skip()</a>.
		 */
		public function get skippable() : Boolean
		{
			return _skippable;
		}

		/**
		 * Starts this Task. If this Task is member of a TaskGroup
		 * this method should not be called by application code.
		 *
		 * @return true if the Task was started successfully, false if it was in an illegal state
		 */
		public function start() : Boolean
		{
			if ( _parent != null )
			{
				//logger.error( "Task '" + this + "' has a parent and cannot be started manually" );
				return false;
			}
			else
			{
				return startInternal();
			}
		}

		/**
		 * The current state of this Task.
		 */
		public function get state() : TaskState
		{
			return _state;
		}

		/**
		 * Suspends this Task. For this method to succeed the suspendable property of this Task
		 * must be set to true and the current state of the Task must be <code>ACTIVE</code>.
		 * If this method executes successfully the <code>SUSPEND</code> event will be fired.
		 *
		 * @return true if the Task successfully switched its internal state, false if otherwise
		 */
		public function suspend() : Boolean
		{
			if ( !suspendable )
			{
				//logger.error( "Task '" + this + "' is not suspendable" );
				return false;
			}

			if ( state != TaskState.ACTIVE )
			{
				//logger.error( "Attempt to suspend Task [" + this + "] in illegal state: " + _state );
				return false;
			}
			cancelTimer();
			_state = TaskState.SUSPENDED;
			//if (_parent != null) {
			//Internal.invoke(_parent, "suspendChild", [this]);
			//} else {
			fireSuspendEvent();
			//}
			return true;
		}

		/**
		 * Indicates whether this Task can be suspended.
		 */
		public function get suspendable() : Boolean
		{
			return _suspendable;
		}

		/**
		 * The timeout for this Task in milliseconds. A value of 0 disables the timeout.
		 */
		public function get timeout() : uint
		{
			return _timeout;
		}

		/**
		 * @private
		 */
		public function toString() : String
		{
			return name;
		}

		/**
		 * Signals that this Task has completed. Subclasses should call this method
		 * when the asynchronous operation has completed. If this method executes successfully
		 * the <code>COMPLETE</code> event will be fired.
		 *
		 * @return true if the Task successfully switched its internal state, false if otherwise
		 */
		protected function complete() : Boolean
		{
			if ( state != TaskState.ACTIVE )
			{
				//logger.error( "Attempt to complete Task '" + this + "' in illegal state: " + _state );
				return false;
			}
			cancelTimer();
			_state = ( restartable ) ? TaskState.INACTIVE : TaskState.FINISHED;

			if ( _parent != null )
			{
				_parent.completeChild( this, false );
			}
			else
			{
				fireCompleteEvent();
			}
			return true;
		}

		/**
		 * Called before the <code>CANCEL</code> event gets fired.
		 * Subclasses for cancelable Tasks should overwrite this method and cancel the actual operation
		 * this Task performs.
		 */
		protected function doCancel() : void
		{
		/* base implementation does nothing */
		}

		/**
		 * Called before the <code>ERROR</code> event gets fired.
		 * Subclasses may optionally overwrite this method to do some cleanup.
		 */
		protected function doError( message : String ) : void
		{
		/* base implementation does nothing */
		}

		/**
		 * Called before the <code>RESUME</code> event gets fired.
		 * Subclasses for suspendable Tasks should overwrite this method and resume the suspended operation
		 * this Task performs.
		 */
		protected function doResume() : void
		{
		/* base implementation does nothing */
		}

		/**
		 * Called after <code>skip</code> has been called but before the <code>COMPLETE</code> event gets fired.
		 * Subclasses for skippable Tasks should overwrite this method and put this Task
		 * into its final state.
		 */
		protected function doSkip() : void
		{
		/* base implementation does nothing */
		}

		/**
		 * Called before the <code>START</code> event gets fired.
		 * Subclasses should overwrite this method to start with the actual operation
		 * this Task should perform.
		 */
		protected function doStart() : void
		{
		/* base implementation does nothing */
		}

		/**
		 * Called before the <code>SUSPEND</code> event gets fired.
		 * Subclasses for suspendable Tasks should overwrite this method and suspend the actual operation
		 * this Task performs.
		 */
		protected function doSuspend() : void
		{
		/* base implementation does nothing */
		}

		/**
		 * Called before the <code>ERROR</code> event gets fired after a timeout occurred.
		 * Subclasses should overwrite this method and cancel the operation this Task performs.
		 * In many cases this method can be handled the same way like the <code>doCancel</code> hook.
		 */
		protected function doTimeout() : void
		{
		/* base implementation does nothing */
		}

		/**
		 * Signals an error condition and cancels the Task. Subclasses should call this method
		 * when the asynchronous operation cannot be successfully completed.
		 * If this method executes successfully the <code>ERROR</code> event will be fired.
		 *
		 * @param message the error description
		 * @return true if the Task successfully switched its internal state, false if otherwise
		 */
		protected function error( message : String ) : Boolean
		{
			if ( _state != TaskState.ACTIVE )
			{
				///logger.error( "Attempt to dispatch error in Task '" + this + "' in illegal state: " + _state + " - message: " + message );
				return false;
			}
			cancelTimer();
			_state = ( restartable ) ? TaskState.INACTIVE : TaskState.FINISHED;

			if ( _parent != null )
			{
				_parent.errorChild( this, message );
			}
			else
			{
				fireErrorEvent( message );
			}
			return true;
		}

		/**
		 * Specifies whether this Task can be cancelled.
		 *
		 * @param value whether this Task can be cancelled
		 */
		protected function setCancelable( value : Boolean ) : void
		{
			_cancelable = value;
		}

		/**
		 * Sets the name of this Task. This name will not be used internally
		 * by the Task Framework except for log output.
		 *
		 * @param name the new name of this Task
		 */
		protected function setName( value : String ) : void
		{
			this.name = value;
		}

		/**
		 * Specifies whether this Task can be restarted. If true the <code>start</code>
		 * method can be invoked again after either the <code>COMPLETE</code>, <code>CANCEL</code>
		 * or <code>ERROR</code> events were fired. If it is false calling <code>start</code> after
		 * these event were fired will cause an Error to be thrown.
		 *
		 * @param value whether this Task can be restarted
		 */
		protected function setRestartable( value : Boolean ) : void
		{
			_restartable = value;

			if ( _restartable && state == TaskState.FINISHED )
			{
				_state = TaskState.INACTIVE;
			}
		}

		/**
		 * Specifies whether this Task can be forced to skip to its final state.
		 * This may be useful in asynchronous operations like animations, but
		 * not in Tasks like loading operations.
		 *
		 * @param value whether this Task can be forced to skip/move to its final state
		 */
		protected function setSkippable( value : Boolean ) : void
		{
			_skippable = value;
		}

		/**
		 * Specifies whether this Task can be suspended.
		 *
		 * @param value whether this Task can be suspended
		 */
		protected function setSuspendable( value : Boolean ) : void
		{
			_suspendable = value;
		}

		/**
		 * Sets the timeout for this Task in milliseconds. A value of 0 disables the timeout.
		 *
		 * @param value the timeout for this Task in milliseconds
		 */
		protected function setTimeout( value : uint ) : void
		{
			if ( value < 0 )
			{
				//logger.error( "Timeout cannot be negative" ); // TODO - check if check is necessary
				return;
			}
			_timeout = value;
		}

		/**
		 * @private
		 */
		internal function fireCancelEvent() : void
		{
			doCancel();
			onCancelled.dispatch( this );
		}

		/**
		 * @private
		 */
		internal function fireCompleteEvent() : void
		{
			onCompleted.dispatch( this );
		}

		/**
		 * @private
		 */
		internal function fireErrorEvent( message : String ) : void
		{
			doError( message );
			onError.dispatch( this );
		}

		/**
		 * @private
		 */
		internal function fireSkipEvent() : void
		{
			doSkip();
			onSkip.dispatch( this );
		}

		/**
		 * @private
		 */
		internal function setParent( p : TaskGroup ) : void
		{
			if ( p != null && _parent != null )
			{
				//logger.error( "Parent is already set in Task '" + this + "'" );
				return;
			}
			_parent = p;
		}

		/**
		 * @private
		 */
		internal function startInternal() : Boolean
		{
			if ( state != TaskState.INACTIVE )
			{
				//logger.error( "Attempt to start Task '" + this + "' in illegal state: " + _state );
				return false;
			}
			_state = TaskState.ACTIVE;
			startTimer();
			fireStartEvent();
			return true;
		}

		private function cancelTimer() : void
		{
			if ( timer != null )
			{
				timer.reset();
				timer = null;
			}
		}

		private function fireResumeEvent() : void
		{
			doResume();

			onResumed.dispatch( this );
		}

		private function fireStartEvent() : void
		{
			doStart();
			onStart.dispatch( this );
		}

		private function fireSuspendEvent() : void
		{
			doSuspend();
			onSuspend.dispatch( this );
		}

		private function onTimeout( evt : TimerEvent ) : void
		{
			if ( state == TaskState.ACTIVE )
			{
				doTimeout();
				error( "Timeout of " + _timeout + " milliseconds elapsed" );
			}
			else
			{
				//logger.error( "Timeout in Task '" + this + "' in illegal state: " + _state );
			}
			timer = null;
		}

		private function startTimer() : void
		{
			cancelTimer();

			if ( timeout > 0 )
			{
				timer = new Timer( _timeout, 1 );
				timer.addEventListener( TimerEvent.TIMER, onTimeout );
				timer.start();
			}
		}
	}

}
