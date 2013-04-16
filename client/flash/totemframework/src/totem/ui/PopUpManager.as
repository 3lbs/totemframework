package totem.ui
{

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import org.as3commons.collections.LinkedMap;

	/**
	 * Popup management class.
	 *
	 * <p>Adds, removes and places modeless or modal popups.</p>
	 *
	 * @author Jens Struwe 02.02.2011
	 */
	public class PopUpManager
	{

		private var _container : Sprite;

		/**
		 * Modal overlay template.
		 */

		/**
		 * The popup container.
		 */
		public function get container():Sprite
		{
			return _container;
		}

		/**
		 * Callback invoked after a popup has been added or removed.
		 */
		private var _popUpCallback : Function;

		/**
		 * Stage width.
		 */
		private var _width : uint;

		/**
		 * Stage height.
		 */
		private var _height : uint;

		/**
		 * List of all popups added.
		 */
		private var _popUps : LinkedMap;


		private static var _instance : PopUpManager;

		/**
		 * PopUpManager constructor.
		 *
		 * <p>The <code>PopUpManager</code> will add all popups to the specified
		 * container. The container should be positioned at (0,0) on the stage.</p>
		 *
		 * TODO Remove contructor argument to be able to run this class with a singleton manager.
		 *
		 * @param container Popup container.
		 */
		public function PopUpManager( container : Sprite, enforcer : PopupEnforcer )
		{
			
			if ( !enforcer )
				throw new Error( "Cannot instantiate a singleton class. Use static getInstance instead." );
			
			if ( !container.stage )
				throw new Error( "The container must already be added to the display list." );

			_container = container;
			_width = _container.stage.fullScreenWidth;
			_height = _container.stage.fullScreenHeight;

			_popUps = new LinkedMap();
		}

		public static function initialize( container : Sprite ) : void
		{
			_instance = new PopUpManager( container, new PopupEnforcer() );
		}

		public static function getInstance() : PopUpManager
		{
			return _instance; // ||= new PopUpManager( container );
		}

		/**
		 * Optional method to explicitly set the popup container size.
		 *
		 * <p>To calculate the centered position and size a modal overlay the PopUpManager
		 * uses by default the stage's <code>stageWidth</code> and <code>stageHeight</code>
		 * properties. In certain cases these properties may not be set propertly at the
		 * time of instantiation. Is is possible to specify a size using this method.</p>
		 *
		 * @param width The popup container width.
		 * @param height The popup container height.
		 */
		public function setSize( width : uint, height : uint ) : void
		{
			_width = width;
			_height = height;
		}

		/**
		 * Callback invoked after a popup has been added or removed.
		 */
		public function set popUpCallback( popUpCallback : Function ) : void
		{
			_popUpCallback = popUpCallback;
		}

		/**
		 * Creates a popup.
		 *
		 * @param displayObject The popup content.
		 * @param centerPopUp Centers the popup if <code>true</code>.
		 * @param modal Modal popup if <code>true</code>.
		 */
		public function createPopUp( displayObject : DisplayObject, centerPopUp : Boolean = false ) : void
		{
			if ( _popUps.hasKey( displayObject ))
				return;

			var overlay : DisplayObject;

			_popUps.add( displayObject, new PopUpData( displayObject, overlay ));
			_container.addChild( displayObject );

			if ( displayObject.hasOwnProperty( "initialize" ) )
				displayObject["initialize"]();
		
			
			center( displayObject );

			if ( _popUpCallback != null )
				_popUpCallback();
		}
		
		/**
		 * <code>true</code> if popups are present.
		 *
		 * <p>If a display object is given, the method will check if that
		 * object is an active popup.</p>
		 *
		 * @param displayObject The object to test if it is an active popup.
		 * @return <code>true</code> if popups are present.
		 */
		public function hasPopUp( displayObject : DisplayObject = null ) : Boolean
		{
			if ( displayObject )
				return _popUps.hasKey( displayObject );
			return _popUps.size > 0;
		}


		/**
		 * Number of popups added.
		 */
		public function get numPopUps() : uint
		{
			return _popUps.size;
		}


		/**
		 * Tests whether the given object is allowed to be focused by key or mouse.
		 *
		 * <p>Checks if the object is placed underneath a modal popup and returns then <code>false</code>.</p>
		 *
		 * @param displayObject The object to test.
		 * @return <code>true</code> if the object can be focused.
		 */
		public function focusEnabled( displayObject : DisplayObject ) : Boolean
		{
			if ( !displayObject )
				return false;

			if ( !displayObject.stage )
				return false;

			var center : Point = new Point( displayObject.width / 2, displayObject.height / 2 );
			var global : Point = displayObject.localToGlobal( center );
			var objects : Array = displayObject.stage.getObjectsUnderPoint( global );
			objects.reverse();

			for each ( var object : DisplayObject in objects )
			{
				// the object to test is reached
				if ( object == displayObject )
					return true;

				if ( object.parent == _container )
				{
					var data : PopUpData = _popUps.itemFor( object );

					if ( !data )
						return false; // overlay

					if ( data && data.isModal )
						return false; // modal pop up
				}
			}

			return true;
		}

		/**
		 * Returns the top popup.
		 *
		 * @return The top popup or <code>null</code> if no popups are present.
		 */
		public function get popUpOnTop() : DisplayObject
		{
			if ( _container.numChildren )
				return _container.getChildAt( _container.numChildren - 1 );
			return null;
		}

		/**
		 * Brings the specified popup to front.
		 *
		 * <p>Aborts if the object is no present popup.</p>
		 *
		 * @param displayObject The popup to bring to front.
		 */
		public function bringToFront( displayObject : DisplayObject ) : void
		{
			if ( !_popUps.hasKey( displayObject ))
				return;

			var popUpData : PopUpData = _popUps.itemFor( displayObject );

			if ( popUpData.isModal )
			{
				_container.setChildIndex( popUpData.modalOverlay, _container.numChildren - 1 );
			}
			_container.setChildIndex( displayObject, _container.numChildren - 1 );
		}

		/**
		 * Centers the specified object.
		 *
		 * @param displayObject The popup to center.
		 */
		public function center( displayObject : DisplayObject ) : void
		{
			displayObject.x = Math.round(( _width - displayObject.width ) / 2 );
			displayObject.y = Math.round(( _height - displayObject.height ) / 2 );
		}

		/**
		 * Removes a popup.
		 *
		 * <p>Aborts if the object is no present popup.</p>
		 *
		 * @param displayObject The popup to remove.
		 */
		public function removePopUp( displayObject : DisplayObject ) : void
		{
			if ( !_popUps.hasKey( displayObject ))
				return;

			var popUpData : PopUpData = _popUps.removeKey( displayObject );

			_container.removeChild( displayObject );

			if ( displayObject.hasOwnProperty( "destroy" ) )
				displayObject["destroy"]();
			
			if ( _popUpCallback != null )
				_popUpCallback();

		}

	}
}

class PopupEnforcer
{
}
