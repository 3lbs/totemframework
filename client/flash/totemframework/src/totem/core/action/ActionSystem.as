package totem.core.action
{

	import totem.totem_internal;
	import totem.core.TotemSystem;
	import totem.core.time.ITicked;
	import totem.core.time.TickedComponent;
	import totem.core.time.TimeManager;
	import totem.data.InList;
	import totem.data.InListIterator;

	use namespace totem_internal;
	
	public class ActionSystem extends TotemSystem implements ITicked
	{
		
		[Inject]
		public var tickedManager : TimeManager;
		
		private var actions_ : ActionList = new ActionList( false );

		private var actionComponents_ : InList = new InList();

		private var initActions_ : Array;

		public function ActionSystem( ... actions )
		{
			initActions_ = actions;
		}

		public function pushBack( action : Action, laneID : int = 0 ) : void
		{
			actions_.pushBack( action, laneID );
		}

		public function pushFront( action : Action, laneID : int = 0 ) : void
		{
			actions_.pushFront( action, laneID );
		}

		public function register( actionComponent : ActionComponent ) : void
		{
			actionComponents_.pushBack( actionComponent );
		}

		public function unregister( actionComponent : ActionComponent ) : void
		{
			actionComponents_.remove( actionComponent );
		}

		override public function initialize():void
		{
			super.initialize();
			
			actions_.setInjector( getInjector());

			for ( var i : int = 0, len : int = initActions_.length; i < len; ++i )
			{
				pushBack( initActions_[ i ]);
			}
			initActions_ = null;
			
			tickedManager.addTickedObject( this );
		}

		override public function destroy():void
		{
			super.destroy();
			
			tickedManager.removeTickedObject( this );

			actions_.cancel();
		}

		public function onTick() : void
		{
			actions_.update();

			var comp : ActionComponent;
			var iter : InListIterator = actionComponents_.getIterator();

			while ( comp = iter.data())
			{
				comp.update();
				iter.next();
			}
		}
	}
}
