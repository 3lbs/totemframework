package totem.core.action
{

	import totem.totem_internal;
	import totem.core.TotemComponent;

	use namespace totem_internal;
	
	public class ActionComponent extends TotemComponent
	{
		private var actions_ : ActionList = new ActionList( false );

		private var initActions_ : Array;

		public function ActionComponent( ... actions )
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

		override protected function onAdd():void
		{
			super.onAdd();
			actions_.setInjector( getInjector());

			for ( var i : int = 0, len : int = initActions_.length; i < len; ++i )
			{
				pushBack( initActions_[ i ]);
			}
			initActions_ = null;

			ActionSystem( getInstance( ActionSystem )).register( this );
		}

		override public function destroy():void
		{
			super.destroy();
			
			actions_.cancel();

			ActionSystem( getInstance( ActionSystem )).unregister( this );
		}

		/** @private */
		internal function update() : void
		{
			actions_.update();
		}
	}
}
