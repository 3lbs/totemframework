package totem.core.mvc.view
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import totem.core.Destroyable;
	import totem.core.mvc.TotemContext;

	/**
	 * <p><b>Author:</b> Romuald Quantin - <a href="http://www.soundstep.com/" target="_blank">www.soundstep.com</a></p>
	 * <p><b>Resources:</b> <a href="http://www.soundstep.com/downloads/somacore" target="_blank">http://www.soundstep.com/downloads/somacore</a></p>
	 * <p><b>Actionscript version:</b> 3.0</p>
	 * <p><b>Copyright:</b>
	 * Mozilla Public License 1.1 (MPL 1.1)<br />
	 * <a href="http://www.opensource.org/licenses/mozilla1.1.php" target="_blank">http://www.opensource.org/licenses/mozilla1.1.php</a></p>
	 * <p>A Mediator is a class that extends a wire and has a relation one-to-one with a view. A mediator can be created with the injection enabled or disabled.</p>
	 * <p>The first step is to map a view class to a mediator class, and everytime a view is added to a display list, a mediator for this view is automatically instantiated by the framework.</p>
	 * <p>The mediator instance will automatically be destroyed by the framework when the view it represents will be removed from the display list.</p>
	 * @example
	 * Map a view class to a mediator class
	 * <listing version="3.0">
package {
	import com.soma.core.interfaces.IMediator;
	import com.soma.core.mediator.Mediator;

	public class MyViewMediator extends Mediator implements IMediator {

		[Inject]
		public var myView:MyView;

		override public function initialize():void {
			// called when the mediator has been created and registered to the framework
			trace(myView == viewComponent);
		}

		override public function dispose():void {
			// called when the mediator has been destroyed by the framework
		}

	}
}
	 * </listing>
	 * Map a mediator class to a view class.
	 * <listing version="3.0">
mediators.mapView(MyView, MyViewMediator);
	 * </listing>
	 * Remove mapping.
	 * <listing version="3.0">
mediators.removeMapping(MyView);
	 * </listing>
	 * Retrieve a mediator.
	 * <listing version="3.0">
var mediator:MyViewMediator = mediators.getMediatorByView(view) as MyViewMediator;
	 * </listing>
	 * Trigger the creation of a mediator by adding a view to the display list.
	 * <listing version="3.0">
mediators.mapView(MyView, MyViewMediator);
var view:MyView = new MyView();
myDisplayObjectContainer.addChild(view);
// mediator instance created
var mediator:MyViewMediator = mediators.getMediatorByView(view) as MyViewMediator;
trace(mediators.hasMediator(view));
	 * </listing>
	 * @see com.soma.core.mediator.SomaMediators
	 * @see com.soma.core.interfaces.IMediator
	 * @see com.soma.core.wire.Wire
	 * @see com.soma.core.wire.SomaWires
	 */

	public class Mediator extends Destroyable
	{

		public var instance : TotemContext;
		
		[Inject]
		public var eventDispatcher : IEventDispatcher;
		
		/**
		 * View that has been mapped to the mediator instance.
		 */
		protected var _viewComponent : Object;

		/**
		 * Create an instance of a Mediator class. The Mediator class should be extended and is usually automatically created (and removed) by the framework.
		 * @param name Name of the wire.
		 */
		public function Mediator()
		{
			
		}

		/**
		 * View that has been mapped to the mediator instance.
		 */
		public final function get viewComponent() : Object
		{
			return _viewComponent;
		}

		public final function set viewComponent( value : Object ) : void
		{
			_viewComponent = value;
		}

		/** @private */
		[PostConstruct]
		public function postConstruct() : void
		{ /* removes post construct from super class (the mediator is initialized manually) */
		}


		public function initialize() : void
		{
			throw new Error()
		}

		/**
		 * Method that can you can override, called when if the view is part of the Flex Framework (not used for a pure AS3 view).
		 */
		public function creationComplete() : void
		{

		}

		protected function addContextListener( type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = true ) : void
		{
			eventDispatcher.addEventListener( type, listener, useCapture, priority, useWeakReference );
		}
		
		protected function dispatchContext( event : Event ) : void
		{
			if ( eventDispatcher.hasEventListener( event.type ))
				eventDispatcher.dispatchEvent( event );
		}
		
		
		override public function destroy():void
		{
			super.destroy();
			
			instance = null;
			
			viewComponent = null;
		}
	}
}
