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

package totem.core.input
{

	import org.osflash.signals.Signal;
	
	import totem.totem_internal;

	/**
	 * A class managing input of any controllers that is an InputController.
	 * Actions are inspired by Midi signals, but they carry an InputAction object.
	 * "action signals" are either ON, OFF, or CHANGE.
	 * to track action status, and check whether action was just triggered or is still on,
	 * actions have phases (see InputAction).
	 **/
	public class Input
	{
		private static var _instance : Input;

		public static function getInstance() : Input
		{
			return _instance ||= new Input( new InputSingletonEnforcer());
		}

		/**
		 * time interval to clear the InputAction's disposed list automatically.
		 */
		public var clearDisposedActionsInterval : uint = 480;

		/**
		 * Lets InputControllers trigger actions.
		 */
		public var triggersEnabled : Boolean = true;

		protected var _actions : Vector.<InputAction>;

		protected var _controllers : Vector.<InputController>;

		protected var _enabled : Boolean = true;

		protected var _initialized : Boolean;

		protected var _routeActions : Boolean = false;

		protected var _routeChannel : uint;

		protected var _timeActive : int = 0;

		internal var actionCHANGE : Signal;

		internal var actionOFF : Signal;

		internal var actionON : Signal;

		public function Input( enforcer : InputSingletonEnforcer )
		{
			if ( !enforcer )
				throw new Error( "Cannot instantiate a singleton class. Use static getInstance instead." );

			_controllers = new Vector.<InputController>();
			_actions = new Vector.<InputAction>();

			actionON = new Signal( InputAction );
			actionOFF = new Signal( InputAction );
			actionCHANGE = new Signal( InputAction );

			actionON.add( doActionON );
			actionOFF.add( doActionOFF );
			actionCHANGE.add( doActionCHANGE );
		}

		public function addAction( action : InputAction ) : void
		{
			if ( _actions.lastIndexOf( action ) < 0 )
				_actions[ _actions.length ] = action;
		}

		public function addController( controller : InputController ) : void
		{
			if ( _controllers.lastIndexOf( controller ) < 0 )
				_controllers.push( controller );
		}

		/**
		 *  addOrSetAction sets existing parameters of an action to new values or adds action if
		 *  it doesn't exist.
		 */
		public function addOrSetAction( action : InputAction ) : void
		{
			var a : InputAction;

			for each ( a in _actions )
			{
				if ( a.eq( action ))
				{
					a._phase = action.phase;
					a._value = action.value;
					return;
				}
			}
			_actions[ _actions.length ] = action;
		}

		public function controllerExists( name : String ) : Boolean
		{
			for each ( var c : InputController in _controllers )
			{
				if ( name == c.name )
					return true;
			}
			return false;
		}

		public function destroy() : void
		{
			destroyControllers();

			actionON.removeAll();
			actionOFF.removeAll();
			actionCHANGE.removeAll();

			resetActions();
			InputAction.clearDisposed();
		}

		public function get enabled() : Boolean
		{
			return _enabled;
		}

		public function set enabled( value : Boolean ) : void
		{
			if ( _enabled == value )
				return;

			var controller : InputController;

			for each ( controller in _controllers )
				controller.enabled = value;

			_enabled = value;
		}

		/**
		 * get an action by name from the current 'active' actions , optionnally filtered by channel, controller or phase.
		 * returns null if no actions are found.
		 *
		 * example :
		 * <code>
		 * var action:InputAction = _ce.input.getAction("jump",-1,null,InputPhase.ON);
		 * if(action && action.time > 120)
		 *    trace("the jump action lasted for more than 120 frames. its value is",action.value);
		 * </code>
		 *
		 * keep doing the jump action for about 2 seconds (if running at 60 fps) and you'll see the trace.
		 * @param	name
		 * @param	channel -1 to include all channels.
		 * @param	controller null to include all controllers.
		 * @param	phase -1 to include all phases.
		 * @return	InputAction
		 */
		public function getAction( name : String, channel : int = -1, controller : InputController = null, phase : int = -1 ) : InputAction
		{
			var a : InputAction;

			for each ( a in _actions )
				if ( name == a.name && ( channel == -1 ? true : ( _routeActions ? ( _routeChannel == channel ) : a.channel == channel )) && ( controller != null ? a.controller == controller : true ) && ( phase == -1 ? true : a.phase == phase ))
					return a;
			return null;
		}

		/**
		 * Returns a list of active actions, optionnally filtered by channel, controller or phase.
		 * return an empty Vector.<InputAction> if no actions are found.
		 *
		 * @param	channel -1 to include all channels.
		 * @param	controller null to include all controllers.
		 * @param	phase -1 to include all phases.
		 * @return
		 */
		public function getActions( channel : int = -1, controller : InputController = null, phase : int = -1 ) : Vector.<InputAction>
		{
			var actions : Vector.<InputAction> = new Vector.<InputAction>;
			var a : InputAction;

			for each ( a in _actions )
				if (( channel == -1 ? true : ( _routeActions ? ( _routeChannel == channel ) : a.channel == channel )) && ( controller != null ? a.controller == controller : true ) && ( phase == -1 ? true : a.phase == phase ))
					actions.push( a )
			return actions;
		}

		/**
		 * returns a Vector of all actions in current frame.
		 * actions are cloned (no longer active inside the input system)
		 * as opposed to using getActions().
		 */
		public function getActionsSnapshot() : Vector.<InputAction>
		{
			var snapshot : Vector.<InputAction> = new Vector.<InputAction>;
			var a : InputAction;

			for each ( a in _actions )
				snapshot.push( a.clone());
			return snapshot;
		}

		public function getControllerByName( name : String ) : InputController
		{
			var c : InputController;

			for each ( c in _controllers )
				if ( name == c.name )
					return c;
			return null;
		}

		/**
		 * Returns the corresponding InputAction object if it has been triggered OFF in this frame or in the previous frame,
		 * or null.
		 */
		public function hasDone( actionName : String, channel : int = -1 ) : InputAction
		{
			var a : InputAction;

			for each ( a in _actions )
				if ( a.name == actionName && ( channel > -1 ? ( _routeActions ? ( _routeChannel == channel ) : a.channel == channel ) : true ) && a.phase == InputPhase.END )
					return a;
			return null;
		}

		public function initialize() : void
		{
			if ( _initialized )
				return;

			_initialized = true;
		}

		/**
		 * Returns the corresponding InputAction object if it has been triggered on the previous frame or is still going,
		 * or null.
		 */
		public function isDoing( actionName : String, channel : int = -1 ) : InputAction
		{
			var a : InputAction;

			for each ( a in _actions )
				if ( a.name == actionName && ( channel > -1 ? ( _routeActions ? ( _routeChannel == channel ) : a.channel == channel ) : true ) && a.time > 1 && a.phase < InputPhase.END )
					return a;
			return null;
		}

		/**
		 * Helps knowing if Input is routing actions or not.
		 */
		public function isRouting() : Boolean
		{
			return _routeActions;
		}

		/**
		 * Returns the corresponding InputAction object if it has been triggered on the previous frame.
		 */
		public function justDid( actionName : String, channel : int = -1 ) : InputAction
		{
			var a : InputAction;

			for each ( a in _actions )
				if ( a.name == actionName && ( channel > -1 ? ( _routeActions ? ( _routeChannel == channel ) : a.channel == channel ) : true ) && a.time == 1 )
					return a;
			return null;
		}

		public function removeController( controller : InputController ) : void
		{
			var i : int = _controllers.lastIndexOf( controller );
			stopActionsOf( controller );
			_controllers.splice( i, 1 );
		}

		public function resetActions() : void
		{
			_actions.length = 0;
		}

		/**
		 * Start routing all actions to a single channel - used for pause menus or generally overriding the Input system.
		 */
		public function startRouting( channel : uint ) : void
		{
			_routeActions = true;
			_routeChannel = channel;
		}

		public function stopActionsOf( controller : InputController, channel : int = -1 ) : void
		{
			var action : InputAction;

			for each ( action in _actions )
			{
				if ( channel > -1 )
					if ( action.channel == channel )
						action._phase = InputPhase.ENDED;
					else
						action._phase = InputPhase.ENDED;
			}
		}

		/**
		 * Stop routing actions.
		 */
		public function stopRouting() : void
		{
			_routeActions = false;
			_routeChannel = 0;
		}

		/**
		 * Changes the value property of an action, or adds action to list if it doesn't exist.
		 * a continuous controller, can simply trigger ActionCHANGE and never have to trigger ActionON.
		 * this will take care adding the new action to the list, setting its phase to 0 so it will respond
		 * to justDid, and then only the value will be changed. - however your continous controller DOES have
		 * to end the action by triggering ActionOFF.
		 */
		internal function doActionCHANGE( action : InputAction ) : void
		{
			if ( !triggersEnabled )
			{
				action.dispose();
				return;
			}
			var a : InputAction;

			for each ( a in _actions )
			{
				if ( a.eq( action ))
				{
					a._phase = InputPhase.ON;
					a._value = action._value;
					a._message = action._message;
					action.dispose();
					return;
				}
			}
			action._phase = InputPhase.BEGIN;
			_actions[ _actions.length ] = action;
		}

		/**
		 * Sets action to phase 3. will be advanced to phase 4 in next update, and finally will be removed
		 * on the update after that.
		 */
		internal function doActionOFF( action : InputAction ) : void
		{
			if ( !triggersEnabled )
			{
				action.dispose();
				return;
			}
			var a : InputAction;

			for each ( a in _actions )
				if ( a.eq( action ))
				{
					a._phase = InputPhase.END;
					a._value = action._value;
					a._message = action._message;
					action.dispose();
					return;
				}
		}

		/**
		 * Adds a new action of phase 0 if it does not exist.
		 */
		internal function doActionON( action : InputAction ) : void
		{
			if ( !triggersEnabled )
			{
				action.dispose();
				return;
			}
			var a : InputAction;

			for each ( a in _actions )
				if ( a.eq( action ))
				{
					a._phase = InputPhase.BEGIN;
					action.dispose();
					return;
				}
			action._phase = InputPhase.BEGIN;
			_actions[ _actions.length ] = action;
		}

		/**
		 * Input.update is called in the end of your state update.
		 * keep this in mind while you create new controllers - it acts only after everything else.
		 * update first updates all registered controllers then finally
		 * advances actions phases by one if not phase 2 (phase two can only be voluntarily advanced by
		 * doActionOFF.) and removes actions of phase 4 (this happens one frame after doActionOFF was called.)
		 */
		totem_internal function update() : void
		{
			if ( InputAction.disposed.length > 0 && _timeActive % clearDisposedActionsInterval == 0 )
				InputAction.clearDisposed();
			_timeActive++;

			if ( !_enabled )
				return;

			var c : InputController;

			for each ( c in _controllers )
			{
				if ( c.updateEnabled && c.enabled )
					c.update();
			}

			var i : String;

			for ( i in _actions )
			{
				InputAction( _actions[ i ]).itime++;

				if ( _actions[ i ].phase > InputPhase.END )
				{
					_actions[ i ].dispose();
					_actions.splice( uint( i ), 1 );
				}
				else if ( _actions[ i ].phase !== InputPhase.ON )
					_actions[ i ]._phase++;
			}

		}

		private function destroyControllers() : void
		{
			for each ( var c : InputController in _controllers )
			{
				c.destroy();
			}
			_controllers.length = 0;
			_actions.length = 0;
		}
	}
}

class InputSingletonEnforcer
{
}
