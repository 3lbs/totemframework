package totem.core.action
{

	import flash.utils.Dictionary;
	
	import totem.totem_internal;
	import totem.data.InList;
	import totem.data.InListIterator;
	import totem.utils.objectpool.ObjectPool;

	use namespace totem_internal;
	
	public final class ActionList extends Action
	{
		private var size_ : int = 0;

		//(key, value) = (id, lane)
		private var laneDictionary_ : Dictionary = new Dictionary();

		private var laneOrderDirty_ : Boolean = false;

		private var lanes_ : Vector.<ActionLane> = new Vector.<ActionLane>();

		private var lanePool_ : ObjectPool = new ObjectPool();

		public function ActionList( autoComplete : Boolean = true, instantUpdate : Boolean = false )
		{
			super( instantUpdate );
			autoComplete_ = autoComplete;
			
			lanePool_.allocate( 10, ActionLane );
			
			onCancelled.addOnce( cancelSubactions );
		}
		
		public function size() : int
		{
			return size_;
		}

		private var autoComplete_ : Boolean;


		public function pushBack( action : Action, laneID : int = 0 ) : void
		{
			getLane( laneID ).actions.pushBack( action );
			action.laneID_ = laneID;
			++size_;
		}

		public function pushFront( action : Action, laneID : int = 0 ) : void
		{
			getLane( laneID ).actions.pushFront( action );
			action.laneID_ = laneID;
			++size_;
		}

		private function injectDependency( action : Action ) : void
		{
			action.parent_ = this;
		
			action.setInjector( getInjector());
			getInjector().injectInto( action );
		}

		override public function update() : void
		{
			if ( isPaused() || isFinished())
				return;

			//lane order dirty, sort
			if ( laneOrderDirty_ )
				lanes_.sort( laneSorter );

			//iterate through all lanes
			var i : int, len : int;
			var lane : ActionLane;
			var laneActions : InList;

			for ( i = 0, len = lanes_.length; i < len; ++i )
			{
				lane = lanes_[ i ];
				laneActions = lane.actions;

				//iterate through actions in the current lane
				var action : Action;
				var iter : InListIterator = laneActions.getIterator();

				while ( action = iter.data())
				{
					//action completed before update, remove and continue
					if ( action.isFinished())
					{
						iter.remove();
						--size_;
						continue;
					}

					//action not paused, update
					if ( !action.isPaused())
					{
						//first update, call onStarted()
						if ( !action.isStarted_ )
						{
							//set injector & lane ID (key)
							injectDependency( action );

							action.onStarted.dispatch();
							action.isStarted_ = true;

							//action cancelled or completed after init, remove and continue
							if ( action.isFinished())
							{
								iter.remove();
								--size_;
								continue;
							}

							//action does not update instantly after init if it's not completed, continue
							if ( !action.instantUpdate_ )
							{
								//action is blocking, break
								if ( action.isBlocking())
									break;

								iter.next();
								continue;
							}
						}

						//update action
						action.update();

						//action cancelled or completed after update, remove and continue
						if ( action.isFinished())
						{
							iter.remove();
							--size_;
							continue;
						}
					}

					//action is blocking, break
					if ( action.isBlocking())
						break;

					iter.next();
				}
			}

			//loop backwards, recycling empty lanes
			for ( i = lanes_.length - 1; i >= 0; --i )
			{
				lane = lanes_[ i ];

				//empty lane, remove from dictionary and put into pool
				if ( lane.actions.size() == 0 )
				{
					delete laneDictionary_[ lane.id ];
					lanes_.splice( i, 1 );
					lanePool_.checkIn( lane );
				}
			}

			if ( size_ == 0 && autoComplete_ )
			{
				complete();
			}
		}

		//utility functions
		//-------------------------------------------------------------------------

		public static function serial( ... actions ) : ActionList
		{
			var actionList : ActionList = new ActionList( true );

			for ( var i : int = 0, len : int = actions.length; i < len; ++i )
			{
				var action : Action = actions[ i ];
				action.block();
				actionList.pushBack( action );
			}
			return actionList;
		}

		public static function parallel( ... actions ) : ActionList
		{
			var actionList : ActionList = new ActionList( true );

			for ( var i : int = 0, len : int = actions.length; i < len; ++i )
			{
				var action : Action = actions[ i ];
				action.unblock();
				actionList.pushBack( action );
			}
			return actionList;
		}

		//-------------------------------------------------------------------------
		//end of utility functions

		private function cancelSubactions() : void
		{
			//cancel all underlying actions
			for ( var key : * in laneDictionary_ )
			{
				var lane : ActionLane = laneDictionary_[ key ];
				var action : Action;
				var iter : InListIterator = lane.actions.getIterator();

				while ( action = iter.data())
				{
					if ( !action.isFinished())
						action.cancel();
					iter.next();
				}

				delete laneDictionary_[ key ];
			}
		}

		private function getLane( laneID : int ) : ActionLane
		{
			var lane : ActionLane;

			//create lane if non-existent
			if ( !( lane = laneDictionary_[ laneID ]))
			{
				//get lane from pool if pool is not empty
				lane = lanePool_.checkOut(); //( lanePool_.isEmpty()) ? ( new ActionLane()) : ( lanePool_.get());
				lane.id = laneID;

				laneDictionary_[ laneID ] = lane;
				lanes_.push( lane );
				laneOrderDirty_ = true;
			}

			return lane;
		}
		
		override public function destroy():void
		{
			super.destroy();
			
			lanePool_.deconstruct();
			
		}
	}
}

import totem.data.InList;

class ActionLane
{
	public var id : int;

	public var actions : InList = new InList();
}

function laneSorter( lhs : ActionLane, rhs : ActionLane ) : Number
{
	return lhs.id - rhs.id;
}
