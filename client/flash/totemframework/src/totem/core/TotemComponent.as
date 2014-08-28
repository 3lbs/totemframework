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

package totem.core
{

	import totem.monitors.promise.IPromise;

	import totem.totem_internal;

	use namespace totem_internal;

	public class TotemComponent extends TotemObject
	{

		public var owner : TotemEntity;

		protected var _activated : Boolean;

		private var _safetyFlag : Boolean;

		public function TotemComponent( name : String = null )
		{
			super( name );
		}

		public function get activated() : Boolean
		{
			return _activated;
		}

		public function deconstruct() : IPromise
		{
			return null;
		}

		override public function destroy() : void
		{
			// DO NOT SUPER THIS
			
			_isDestroyed = true;
			owner = null;
		}

		// you might want to do get var OWNER instead of going through the mapping
		public function getOwner() : TotemEntity
		{
			return owner;
		}

		public function getSibling( ComponentClass : Class ) : *
		{
			if ( owner.hasComponent( ComponentClass ))
				return owner.getComponent( ComponentClass );

			return getInstance( ComponentClass );
		}

		protected function onActivate() : void
		{
			_safetyFlag = true;
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
		}

		protected function onRetire() : void
		{
			_safetyFlag = true;
		}

		totem_internal function doActivate() : void
		{
			_safetyFlag = false;

			_activated = true;
			onActivate();

			if ( _safetyFlag == false )
				throw new Error( "You forget to call super.onActivate() in an onRemove handler." );

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

		totem_internal function doRetire() : void
		{
			_safetyFlag = false;
			_activated = false;
			onRetire();

			if ( _safetyFlag == false )
				throw new Error( "You forget to call super.onRetire() in an onRemove handler." );
		}
	}
}
