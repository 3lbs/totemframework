package totem.display.layout
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import totem.core.IDestroyable;
	import totem.events.IRemovableEventDispatcher;
	import totem.events.ListenerManager;
	
	public class TSprite extends Sprite implements IRemovableEventDispatcher, IDestroyable
	{
		protected var _listenerManager : ListenerManager;
		
		protected var _isDestroyed : Boolean;
		private var _enabled:Boolean;
		
		public function TSprite()
		{
			super ();
			this._listenerManager = ListenerManager.getManager(this);
		}
		
		/**
		 @exclude
		 */
		override public function dispatchEvent( event : Event ) : Boolean
		{
			if ( this.willTrigger ( event.type ) )
				return super.dispatchEvent ( event );
			
			return true;
		}
		
		/**
		 @exclude
		 */
		override public function addEventListener( type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = false ) : void
		{
			super.addEventListener ( type, listener, useCapture, priority, useWeakReference );
			this._listenerManager.addEventListener ( type, listener, useCapture, priority, useWeakReference );
		}
		
		/**
		 @exclude
		 */
		override public function removeEventListener( type : String, listener : Function, useCapture : Boolean = false ) : void
		{
			super.removeEventListener ( type, listener, useCapture );
			this._listenerManager.removeEventListener ( type, listener, useCapture );
		}
		
		public function removeEventsForType( type : String ) : void
		{
			this._listenerManager.removeEventsForType ( type );
		}
		
		public function removeEventsForListener( listener : Function ) : void
		{
			this._listenerManager.removeEventsForListener ( listener );
		}
		
		public function removeEventListeners() : void
		{
			this._listenerManager.removeEventListeners ();
		}
		
		public function getTotalEventListeners( type : String = null ) : uint
		{
			return this._listenerManager.getTotalEventListeners ( type );
		}
		
		/**
		 Removes and optionally destroys children of the <code>CasaSprite</code> then destroys itself.
		
		 @param destroyChildren: If a child implements {@link IDestroyable} call its {@link IDestroyable#destroy destroy} method <code>true</code>, or don't destroy <code>false</code>; defaults to <code>false</code>.
		 @param recursive: Call this method with the same arguments on all of the children's children (all the way down the display list) <code>true</code>, or leave the children's children <code>false</code>; defaults to <code>false</code>.
		 */
		public function removeChildrenAndDestroy( destroyChildren : Boolean = false, recursive : Boolean = false ) : void
		{
			removeChildren();
			this.destroy ();
		}
		
		public function get destroyed() : Boolean
		{
			return this._isDestroyed;
		}
		
		/**
		 * @return	Array of all of the sprite's children
		 */
		public function get children() : Array
		{
			var children : Array = new Array();
			for( var i : int = 0; i < numChildren; i++ )
			{
				children.push( getChildAt( i ) );
			}
			return children;
		}
		
		public function set enabled( a_enabled : Boolean ) : void
		{
			this.mouseEnabled = a_enabled;
			_enabled = a_enabled;
		}
		
		/**
		 * @return	Whether or not this sprite is enabled
		 */
		public function get enabled() : Boolean
		{
			return _enabled;
		}
		
		
		/**
		 {@inheritDoc}
		
		 Calling <code>destroy()</code> on a CASA display object also removes it from its current parent.
		 */
		public function destroy() : void
		{
			this._listenerManager.destroy ();
			
			this._isDestroyed = true;
			
			removeChildren();
			
			if ( this.parent != null )
				this.parent.removeChild ( this );
			
		}
	}
}
