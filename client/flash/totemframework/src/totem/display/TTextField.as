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

package totem.display
{

	import flash.events.Event;
	import flash.text.TextField;
	
	import totem.core.IDestroyable;
	import totem.events.IRemovableEventDispatcher;
	import totem.events.ListenerManager;

	public class TTextField extends TextField implements IRemovableEventDispatcher, IDestroyable
	{
		
		protected var _listenerManager : ListenerManager;
		
		protected var _isDestroyed : Boolean;
		private var _enabled:Boolean;
		
		public function TTextField()
		{
			super();
			
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
		
		
		public function get destroyed() : Boolean
		{
			return this._isDestroyed;
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
			
			
			if ( this.parent != null )
				this.parent.removeChild ( this );
			
		}
	}
}
