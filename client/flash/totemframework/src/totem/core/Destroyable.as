
package totem.core
{

	/**
		Base class for objects that are destroyable.

		@author Aaron Clinger
		@version 10/27/08
	*/
	public class Destroyable implements IDestroyable
	{
		protected var _isDestroyed : Boolean;


		/**
			Creates a new Destroyable object.
		*/
		public function Destroyable()
		{
			super();
		}

		[Transient]
		public function get destroyed() : Boolean
		{
			return this._isDestroyed;
		}

		public function destroy() : void
		{
			if ( _isDestroyed )
				return;
			
			this._isDestroyed = true;
		}
	}
}
