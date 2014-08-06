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

	import flash.utils.Dictionary;

	import org.swiftsuspenders.Injector;
	import totem.monitors.promise.IPromise;
	import totem.monitors.promise.SerialDeferred;
	import totem.observer.NotifBroadcaster;

	import totem.totem_internal;

	use namespace totem_internal;

	public class TotemEntity extends TotemObject
	{
		public var notifBroadcaster : NotifBroadcaster = new NotifBroadcaster();

		private var alternativeMapping : Dictionary = new Dictionary();

		private var components_ : Dictionary = new Dictionary();

		public function TotemEntity( name : String )
		{
			super( name );
		}

		public function addComponent( component : TotemComponent, ComponentClass : Class ) : TotemComponent
		{
			var injector : Injector = getInjector();

			//check component existence
			if ( injector.satisfiesDirectly( ComponentClass ))
				throw new Error( "Component " + ComponentClass + " already added." );

			//map to entity's and engine's injectors
			injector.map( ComponentClass ).toValue( component );

			component.setInjector( injector );
			component.owner = this;
			// you may not want to do this with components!!!!!!!!!!!!!!!!!!!!
			//injector.parentInjector.map( ComponentClass, getName()).toValue( component );

			components_[ ComponentClass ] = component;

			return component;
		}

		public function deconstruct( func : Function = null ) : IPromise
		{
			var monitor : SerialDeferred = new SerialDeferred();

			for each ( var component : TotemComponent in components_ )
			{
				monitor.add( component.deconstruct());
			}

			monitor.resolveOn( doDeconstruct );

			return monitor.promise();
		}

		override public function destroy() : void
		{
			
			for ( var componentClass : * in components_ )
			{
				removeComponent( componentClass );
			}
			
			super.destroy();
			// deleyed destroy?????
			//deconstruct();
		}

		public function getComponent( ComponentClass : Class ) : *
		{
			var component : * = null;

			if ( components_[ ComponentClass ])
				return components_[ ComponentClass ];

			if ( alternativeMapping[ ComponentClass ])
				return alternativeMapping[ ComponentClass ]

			component = getInstance( ComponentClass );

			return component;
		}

		public function hasComponent( ComponentClass : Class ) : Boolean
		{
			return components_[ ComponentClass ] != null || alternativeMapping[ ComponentClass ] != null;
		}

		override public function initialize() : void
		{
			super.initialize();

			injector.map( NotifBroadcaster ).toValue( notifBroadcaster );

			for each ( var component : TotemComponent in components_ )
			{
				getInjector().injectInto( component );
				component.doAdd();
			}

			notifBroadcaster.dispatchNotifWith( TotemNotification.ENTITY_INITIALIZED );
		}

		public function mapInterface( component : TotemComponent, ComponentClass : Class ) : void
		{
			alternativeMapping[ ComponentClass ] = component;
		}

		public function onActivate() : void
		{
			for each ( var component : TotemComponent in components_ )
			{
				component.doActivate();
			}
		}

		public function onRetire() : void
		{
			for each ( var component : TotemComponent in components_ )
			{
				component.doRetire();
			}
		}

		public function removeComponent( ComponentClass : Class ) : void
		{
			var injector : Injector = getInjector();

			//check component existence
			if ( !injector.satisfiesDirectly( ComponentClass ))
				throw new Error( "Component " + ComponentClass + " not found." );

			var component : TotemComponent = getComponent( ComponentClass );

			//remove component from entity
			component.doRemove();

			injector.unmap( ComponentClass );
			//injector.parentInjector.unmap( ComponentClass, getName());

			components_[ ComponentClass ] = null;
			delete components_[ ComponentClass ];

			if ( alternativeMapping[ ComponentClass ])
			{
				alternativeMapping[ ComponentClass ] = null;
				delete alternativeMapping[ ComponentClass ];
			}
		}

		protected function doDeconstruct() : void
		{
			for ( var componentClass : * in components_ )
			{
				removeComponent( componentClass );
			}
			
			if ( injector )
			{
				injector.teardown();
				injector = null;
			}
		}
	}
}
