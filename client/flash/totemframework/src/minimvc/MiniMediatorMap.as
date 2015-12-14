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

package minimvc
{

	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	import totem.core.Destroyable;

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
	public class MiniMediatorMap extends Destroyable
	{
		/** @private */
		private var _classes : Dictionary;

		/** @private */
		private var _instance : MiniContext;

		/** @private */
		private var _mediators : Dictionary;

		/**
		 * Create an instance of the SomaWires class. Should not be directly instantiated, the framework will instantiate the class.
		 * @param instance Framework instance.
		 */
		public function MiniMediatorMap( instance : MiniContext )
		{
			_instance = instance;
			initialize();
		}

		public function addMediator( view : Object, mediatorClass : Class ) : void
		{
			var mediator : MiniMediator;
			mediator = new mediatorClass();
			mediator.instance = _instance;
			_mediators[ view ] = mediator;
			mediator.viewComponent = view;
			mediator.initialize();
		}

		/**
		 * Destroys all the mediators and properties. The class will call the dispose method of each mediator instance.
		 */
		override public function destroy() : void
		{
			_instance.mainStage.removeEventListener( Event.ADDED_TO_STAGE, addedhandler, true );
			_instance.mainStage.removeEventListener( Event.REMOVED_FROM_STAGE, removedhandler, true );

			for each ( var mediator : MiniMediator in _mediators )
			{
				mediator.destroy();
			}
			_classes = null;
			_mediators = null;
			_instance = null;
		}

		/**
		 * Retrieves a mediator instance using its view.
		 * @param view View that the mediator represents.
		 * @return A mediator instance.
		 * @example
		 * <listing version="3.0">var mediator:MyViewMediator = mediators.getMediatorByView(myView) as MyViewMediator;</listing>
		 */
		public function getMediatorByView( view : Object ) : MiniMediator
		{
			return _mediators[ view ];
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

		/** @private */
		private function addedhandler( event : Event ) : void
		{
			var viewClassName : String = getClassName( event.target );

			if ( _classes[ viewClassName ])
			{
				createMediator( event.target, _classes[ viewClassName ]);
			}
		}

		/** @private */
		private function createMediator( view : Object, mediatorClass : Class ) : void
		{
			if ( _classes[ getClassName( view )] && !_mediators[ view ])
			{
				var mediator : MiniMediator;
				mediator = new mediatorClass();
				mediator.instance = _instance;
				_mediators[ view ] = mediator;
				view.addEventListener( "creationComplete", creationComplete, false, 0, true );
				mediator.viewComponent = view;
				mediator.initialize();
			}
		}

		/** @private */
		private function creationComplete( event : Event ) : void
		{
			event.target.removeEventListener( "creationComplete", creationComplete );
			var mediator : MiniMediator = getMediatorByView( event.target );

			if ( mediator && Object( mediator ).hasOwnProperty( "creationComplete" ))
			{
				Object( mediator ).creationComplete();
			}
		}

		/** @private */
		private function disposeMediator( view : Object ) : void
		{
			view.removeEventListener( "creationComplete", creationComplete, false );

			if ( _mediators[ view ])
			{
				MiniMediator( _mediators[ view ]).destroy();
				MiniMediator( _mediators[ view ]).viewComponent = null;
				MiniMediator( _mediators[ view ]).instance = null;
				_mediators[ view ] = null;
				delete _mediators[ view ];
			}
		}

		private function getClassName( value : Object ) : String
		{
			return getQualifiedClassName( value );
		}

		/** @private */
		private function initialize() : void
		{
			_classes = new Dictionary();
			_mediators = new Dictionary( true );
			_instance.mainStage.addEventListener( Event.ADDED_TO_STAGE, addedhandler, true, 0, true );
			_instance.mainStage.addEventListener( Event.REMOVED_FROM_STAGE, removedhandler, true, 0, true );
		}

		/** @private */
		private function removedhandler( event : Event ) : void
		{
			disposeMediator( event.target );
		}
	}
}
