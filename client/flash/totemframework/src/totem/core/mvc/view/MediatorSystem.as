package totem.core.mvc.view
{

	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import totem.totem_internal;
	import totem.core.IDestroyable;
	import totem.core.System;
	import totem.core.mvc.TotemContext;
	import totem.utils.TypeUtility;

	use namespace totem_internal;

	/**
	 * <p><b>Author:</b> Romuald Quantin - <a href="http://www.soundstep.com/" target="_blank">www.soundstep.com</a></p>
	 * <p><b>Resources:</b> <a href="http://www.soundstep.com/downloads/somacore" target="_blank">http://www.soundstep.com/downloads/somacore</a></p>
	 * <p><b>Actionscript version:</b> 3.0</p>
	 * <p><b>Copyright:</b>
	 * Mozilla Public License 1.1 (MPL 1.1)<br />
	 * <a href="http://www.opensource.org/licenses/mozilla1.1.php" target="_blank">http://www.opensource.org/licenses/mozilla1.1.php</a></p>
	 * The SomaMediators class handles the mediators of the application. See the Mediator class documentation for implementation.
	 * @see com.soma.core.mediator.Mediator
	 */

	public class MediatorSystem extends System
	{

		/** @private */
		private var _instance : TotemContext;

		/** @private */
		private var _classes : Dictionary;

		/** @private */
		private var _mediators : Dictionary;

		private var _dispatchers : Dictionary;

		private var count : int;

		/**
		 * Create an instance of the SomaWires class. Should not be directly instantiated, the framework will instantiate the class.
		 * @param instance Framework instance.
		 */
		public function MediatorSystem( instance : TotemContext )
		{
			super();
			_instance = instance;
		}

		/** @private */
		override public function initialize() : void
		{
			if ( _instance.getInjector())
				injector = _instance.getInjector().createChildInjector();

			_classes = new Dictionary();
			_mediators = new Dictionary( true );
			_instance.stage.addEventListener( Event.ADDED_TO_STAGE, addedhandler, true, 0, true );
			_instance.stage.addEventListener( Event.ADDED, addedhandler, true, 0, true );
			_instance.stage.addEventListener( Event.REMOVED_FROM_STAGE, removedhandler, true, 0, true );
		}

		public function addEventDispatchers( dispatcher : * ) : void
		{
			_dispatchers ||= new Dictionary();

			dispatcher.addEventListener( Event.ADDED_TO_STAGE, addedhandler );
			dispatcher.addEventListener( Event.ADDED, addedhandler );
			dispatcher.addEventListener( Event.REMOVED_FROM_STAGE, removedhandler );

			_dispatchers[ dispatcher ] = ++count;
		}

		/** @private */
		private function getClassFromInstance( value : Object ) : Class
		{
			return TypeUtility.getClass( value );
		}

		/** @private */
		private function getClassName( value : Object ) : String
		{
			return TypeUtility.getObjectClassName( value );
		}

		/** @private */
		private function addedhandler( e : * ) : void
		{
			var target : * = e.target;

			var viewClassName : String = getClassName( target );

			if ( _classes[ viewClassName ])
			{
				createMediator( target, getClassFromInstance( target ), _classes[ viewClassName ]);
			}
		}

		/** @private */
		private function removedhandler( event : Event ) : void
		{
			disposeMediator( event.target );
		}

		/** @private */
		private function createMediator( view : Object, viewClass : Class, mediatorClass : Class ) : void
		{
			if ( _classes[ getClassName( view )] && !_mediators[ view ])
			{
				var mediator : Mediator = new mediatorClass();

				if ( injector )
				{
					injector.map( viewClass ).toValue( view );
					injector.injectInto( mediator );
					injector.unmap( viewClass );
				}
				else
				{
					mediator.instance = _instance;
					mediator.viewComponent = view;
				}

				_mediators[ view ] = mediator;
				view.addEventListener( "creationComplete", creationComplete );
				mediator.initialize();
			}
		}

		public function mediateView( view : Object, viewClass : Class, mediator : Mediator ) : void
		{
			
			if ( injector )
			{
				injector.map( viewClass ).toValue( view );
				injector.injectInto( mediator );
				injector.unmap( viewClass );
			}
			
			_mediators[ view ] = mediator;
			mediator.viewComponent = view;
			mediator.initialize();
		}

		/** @private */
		private function disposeMediator( view : Object ) : void
		{
			view.removeEventListener( "creationComplete", creationComplete, false );

			if ( _mediators[ view ])
			{
				Mediator( _mediators[ view ]).destroy();
				Mediator( _mediators[ view ]).viewComponent = null;
				Mediator( _mediators[ view ]).instance = null;
				_mediators[ view ] = null;
				delete _mediators[ view ];
			}
		}

		/** @private */
		private function creationComplete( event : Event ) : void
		{
			event.target.removeEventListener( "creationComplete", creationComplete );
			var mediator : Mediator = getMediatorByView( event.target );

			if ( mediator && Object( mediator ).hasOwnProperty( "creationComplete" ))
			{
				Object( mediator ).creationComplete();
			}
		}

		/**
		 * Destroys all the mediators and properties. The class will call the dispose method of each mediator instance.
		 */
		override public function destroy() : void
		{
			super.destroy();

			_instance.stage.removeEventListener( Event.ADDED_TO_STAGE, addedhandler, true );
			_instance.stage.removeEventListener( Event.REMOVED_FROM_STAGE, removedhandler, true );
			_instance.stage.removeEventListener( Event.ADDED, addedhandler, true );
			
			for each ( var mediator : Mediator in _mediators )
			{
				mediator.destroy();
			}
			
			_classes = null;
			_mediators = null;
			_instance = null;

			if ( _dispatchers )
			{
				for ( var dispatcher : * in _dispatchers )
				{
					IEventDispatcher( dispatcher ).removeEventListener( Event.ADDED_TO_STAGE, addedhandler, true );
					IEventDispatcher( dispatcher ).removeEventListener( Event.REMOVED_FROM_STAGE, addedhandler, true );
					IEventDispatcher( dispatcher ).removeEventListener( Event.ADDED, addedhandler, true );

					IDestroyable( dispatcher ).destroy();

					_dispatchers[ dispatcher ] = null;
					delete _dispatchers[ dispatcher ];
				}
			}
			
			_dispatchers = null;

			injector.teardown();
			injector = null;
		}

		/**
		 * Indicates whether a mediator has been created by the framework for a specific view.
		 * @param view View that the mediator represents.
		 * @return A Boolean.
		 * @example
		 * <listing version="3.0">mediators.hasMediator(myView);</listing>
		 */
		public function hasMediator( view : Object ) : Boolean
		{
			return ( _mediators[ view ] != null || _mediators[ view ] != undefined );
		}

		/**
		 * Retrieves a mediator instance using its view.
		 * @param view View that the mediator represents.
		 * @return A mediator instance.
		 * @example
		 * <listing version="3.0">var mediator:MyViewMediator = mediators.getMediatorByView(myView) as MyViewMediator;</listing>
		 */
		public function getMediatorByView( view : Object ) : Mediator
		{
			return _mediators[ view ];
		}

		/**
		 * Indicates whether a view Class has a mapping rule.
		 * @param viewClass A Class.
		 * @return A Boolean.
		 * @example
		 * <listing version="3.0">mediators.isMapped(MyView);</listing>
		 */
		public function isMapped( viewClass : Class ) : Boolean
		{
			return ( _classes[ getClassName( viewClass )] != undefined );
		}

		/**
		 * Map a mediator Class to a view Class.
		 * @param viewClass A Class.
		 * @param mediatorClass A Class.
		 * @return A Boolean.
		 * @example
		 * <listing version="3.0">mediators.mapView(MyView, MyViewMediator);</listing>
		 */
		public function mapView( viewClass : Class, mediatorClass : Class ) : void
		{
			if ( !viewClass || !mediatorClass )
				return;

			if ( isMapped( viewClass ))
			{
				throw new Error( "Error in " + this + " View Class (mapView method) \"" + viewClass + "\" already mapped." );
			}
			var viewClassName : String = getClassName( viewClass );
			_classes[ viewClassName ] = mediatorClass;
		}

		/**
		 * Remove a mapping rule for a specific Class.
		 * @param viewClass A Class.
		 * @return A Boolean.
		 * @example
		 * <listing version="3.0">mediators.removeMapping(MyView);</listing>
		 */
		public function removeMapping( viewClass : Class ) : void
		{
			if ( !viewClass )
				return;

			if ( !isMapped( viewClass ))
			{
				throw new Error( "Error in " + this + " View Class (unmap method) \"" + viewClass + "\" not mapped." );
			}

			if ( _classes[ getClassName( viewClass )])
			{
				_classes[ getClassName( viewClass )] = null;
				delete _classes[ viewClass ];
			}
		}

	}
}
