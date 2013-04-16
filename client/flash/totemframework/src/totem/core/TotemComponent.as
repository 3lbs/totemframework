package totem.core
{

	import totem.totem_internal;
	import totem.monitors.promise.IPromise;

	use namespace totem_internal;

	public class TotemComponent extends TotemObject
	{
		
		private var _safetyFlag : Boolean;

		public var owner : TotemEntity;

		public function TotemComponent( name : String = null )
		{
			super( name );
		}

		// you might want to do get var OWNER instead of going through the mapping
		public function getOwner() : TotemEntity
		{
			return getInstance( TotemEntity );
		}

		public function getSibling( ComponentClass : Class ) : *
		{
			return getInstance( ComponentClass );
		}

		totem_internal function doAdd() : void
		{
			_safetyFlag = false;
			onAdd();

			if ( _safetyFlag == false )
				throw new Error( "You forget to call super.onAdd() in an onAdd override." );
		}

		totem_internal function doRemove() : void
		{
			_safetyFlag = false;
			onRemove();

			if ( _safetyFlag == false )
				throw new Error( "You forget to call super.onRemove() in an onRemove handler." );
		}

		/**
		 * Called when component is added to a SmashGameObject. Do component setup
		 * logic here.
		 */
		protected function onAdd() : void
		{
			_safetyFlag = true;
		}

		/**
		 * Called when component is removed frmo a SmashGameObject. Do component
		 * teardown logic here.
		 */
		protected function onRemove() : void
		{
			_safetyFlag = true;
			
			destroy();
		}

		override public function destroy() : void
		{
			super.destroy();
			owner = null;
		}
		
		public function deconstruct(): IPromise
		{
			return null;
		}
	}
}
