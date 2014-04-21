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

package totem.ui.popup
{

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import ladydebug.Logger;
	
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	import totem.core.IDestroyable;
	import totem.display.layout.TContainer;
	import totem.ui.StopPropagationController;
	import totem.utils.objectpool.SimpleObjectPool;

	public class PopUpManager
	{

		private static var _instance : PopUpManager;

		public static function getInstance() : PopUpManager
		{
			if ( !_instance )
				throw new Error( "PopupManager needs to be initalized." );

			return _instance; // ||= new PopUpManager( container );
		}

		public static function initialize( container : DisplayObjectContainer ) : void
		{
			_instance = new PopUpManager( container, new PopupEnforcer());
		}

		public var backgroundAlpha : Number = .2;

		public var backgroundColor : int = 0x000000;

		public var defaultPopupTransition : Class;

		public var popupDispatcher : ISignal = new Signal( Boolean );

		private var _closedCallback : Function;

		private var _container : DisplayObjectContainer;

		/**
		 * Stage height.
		 */
		private var _height : uint;

		/**
		 * Callback invoked after a popup has been added or removed.
		 */
		private var _popUpCallback : Function;

		private var _popUpChannelMap : Dictionary = new Dictionary();

		private var _popUpPool : SimpleObjectPool;

		private var _popUpsMap : Dictionary = new Dictionary();

		private var _scale : Number = 1;

		/**
		 * Stage width.
		 */
		private var _width : uint;

		private var propagationController : StopPropagationController;

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
		public function PopUpManager( container : DisplayObjectContainer, enforcer : PopupEnforcer )
		{

			if ( !enforcer )
				throw new Error( "Cannot instantiate a singleton class. Use static getInstance instead." );

			if ( !container.stage )
				throw new Error( "The container must already be added to the display list." );

			_container = container;
			_width = _container.width;
			_height = _container.height;

			propagationController = new StopPropagationController( _container );

			_popUpPool = new SimpleObjectPool( createPopUpData, null, 8 );

		}

		/**
		 * Centers the specified object.
		 *
		 * @param displayObject The popup to center.
		 */
		public function center( displayObject : DisplayObject ) : void
		{

			var width : Number = displayObject.width;
			var height : Number = displayObject.height;

			if (( displayObject is BaseDialog ) && BaseDialog( displayObject ).dialogRect )
			{
				width = BaseDialog( displayObject ).dialogRect.width;
				height = BaseDialog( displayObject ).dialogRect.height;
			}

			displayObject.x = Math.round(( _width - width ) * .5 );
			displayObject.y = Math.round(( _height - height ) * .5 );
		}

		public function cleanPopUpData( data : PopUpData ) : void
		{
			data.transition = null;
			data.popUp = null;
		}

		/**
		 * Modal overlay template.
		 */

		/**
		 * The popup container.
		 */
		public function get container() : DisplayObjectContainer
		{
			return _container;
		}

		/**
		 * Creates a popup.
		 *
		 * @param displayObject The popup content.
		 * @param centerPopUp Centers the popup if <code>true</code>.
		 * @param modal Modal popup if <code>true</code>.
		 */
		public function createPopUp( displayObject : DisplayObject, channel : int = 0, transition : BasePopUpTransition = null ) : void
		{
			if ( _popUpsMap[ displayObject ])
				return;

			Logger.info( this, "createPopUp", " please 0" );

			var popupData : PopUpData = _popUpPool.checkOut() as PopUpData;
			popupData.popUp = displayObject;
			popupData.channel = channel;
			popupData.transition = transition || ( defaultPopupTransition != null ? new defaultPopupTransition( displayObject ) : null );

			var channelList : ChannalData = getChannel( channel );
			channelList.list.push( popupData );

			_popUpsMap[ displayObject ] = popupData;

			Logger.info( this, "createPopUp", " please" );

			showNextPopup( channel );
		}

		public function createPopUpData() : PopUpData
		{
			return new PopUpData();
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
				return _popUpsMap.hasKey( displayObject );
			return _popUpsMap.size > 0;
		}

		public function isActive() : Boolean
		{
			return numPopUps > 0;
		}

		/**
		 * Number of popups added.
		 */
		public function get numPopUps() : uint
		{
			return _popUpsMap.size;
		}

		/**
		 * Callback invoked after a popup has been added or removed.
		 */
		public function set popUpCallback( popUpCallback : Function ) : void
		{
			_popUpCallback = popUpCallback;
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
		 * Removes a popup.
		 *
		 * <p>Aborts if the object is no present popup.</p>
		 *
		 * @param displayObject The popup to remove.
		 */
		public function removePopUp( displayObject : DisplayObject, callback : Function = null ) : void
		{
			if ( !_popUpsMap[ displayObject ])
				return;

			var popUpData : PopUpData = _popUpsMap[ displayObject ];

			_popUpsMap[ displayObject ] = null;
			delete _popUpsMap[ displayObject ];

			var transition : BasePopUpTransition = popUpData.transition;

			var channel : int = popUpData.channel;

			_popUpPool.checkIn( popUpData );

			if ( transition )
			{
				transition.channel = channel;
				transition.completeTransition.addOnce( handleTransitionComplete );
				transition.animateOut();

				_closedCallback = callback;
			}
			else
			{
				if ( _popUpCallback != null )
					_popUpCallback();

				_container.removeChild( displayObject );

				propagationController.enabled = false;

				var channelData : ChannalData = getChannel( channel );
				channelData.isBusy = false;
				showNextPopup( channel );

				if ( callback )
					callback();
			}
		}

		public function get scale() : Number
		{
			return _scale;
		}

		public function set scale( value : Number ) : void
		{
			_scale = value;
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

		private function getChannel( channel : int ) : ChannalData
		{
			if ( _popUpChannelMap[ channel ])
			{
				return _popUpChannelMap[ channel ];
			}

			var channelData : ChannalData = new ChannalData();

			var backgroundScreen : TContainer = new TContainer();

			backgroundScreen.contentWidth = _width;
			backgroundScreen.contentHeight = _height;
			backgroundScreen.backgroundColor = backgroundColor;
			backgroundScreen.backgroundAlpha = backgroundAlpha;
			/*backgroundScreen.addEventListener( MouseEvent.CLICK, handleMouseEvent, false, -1 );
			backgroundScreen.addEventListener( MouseEvent.MOUSE_MOVE, handleMouseEvent, false, -1 );
			backgroundScreen.addEventListener( MouseEvent.MOUSE_DOWN, handleMouseEvent, false, -1 );
			backgroundScreen.addEventListener( MouseEvent.MOUSE_UP, handleMouseEvent, false, -1 );
			backgroundScreen.addEventListener( MouseEvent.MOUSE_OVER, handleMouseEvent, false, -1 );
			backgroundScreen.addEventListener( MouseEvent.MOUSE_OUT, handleMouseEvent, false, -1 );
			backgroundScreen.addEventListener( MouseEvent.ROLL_OVER, handleMouseEvent, false, -1 );
			backgroundScreen.addEventListener( MouseEvent.ROLL_OUT, handleMouseEvent, false, -1 );*/

			channelData.backgroundScreen = backgroundScreen;

			_popUpChannelMap[ channel ] = channelData;

			return channelData;
		}

		/*private function handleMouseEvent( event : MouseEvent ) : void
		{
			event.stopImmediatePropagation();
			event.stopPropagation();
		}*/

		private function handleTransitionComplete( transition : BasePopUpTransition ) : void
		{

			var displayObject : DisplayObject = transition.popUp;

			_container.removeChild( displayObject );

			propagationController.enabled = false;

			if ( _closedCallback )
			{
				_closedCallback();
				_closedCallback = null;
			}
			else
			{
				if ( displayObject is IDestroyable )
					IDestroyable( displayObject ).destroy();
			}

			var channelData : ChannalData = getChannel( transition.channel );
			channelData.isBusy = false;

			if ( _popUpCallback != null )
				_popUpCallback();

			showNextPopup( transition.channel );

			transition.destroy();
		}

		private function showNextPopup( channelID : int ) : void
		{
			var channel : ChannalData = getChannel( channelID );

			if ( !channel.isBusy && channel.list.length > 0 )
			{

				channel.isBusy = true;

				var popUpData : PopUpData = channel.list.shift() as PopUpData;
				var displayObject : DisplayObject = popUpData.popUp;
				var transition : BasePopUpTransition = popUpData.transition;

				if ( !channel.backgroundScreen.parent )
				{

					Logger.info( this, "backgroundScreen", " please" );
					channel.backgroundScreen.visible = true;
					_container.addChild( channel.backgroundScreen );
				}

				displayObject.scaleX = displayObject.scaleY = scale;
				_container.addChild( displayObject );
				center( displayObject );

				propagationController.enabled = true;
				
				if ( transition )
				{
					transition.animateIn();
				}

				Logger.info( this, "showNextPopup", " please please" );

				if ( _popUpCallback != null )
					_popUpCallback();

			}
			else
			{
				if ( channel.backgroundScreen.parent )
					_container.removeChild( channel.backgroundScreen );
			}


			popupDispatcher.dispatch( isActive());
		}
	}
}

import flash.display.DisplayObject;

import totem.core.Destroyable;
import totem.display.layout.TContainer;
import totem.ui.popup.BasePopUpTransition;

internal class ChannalData extends Destroyable
{
	public var backgroundScreen : TContainer;

	public var isBusy : Boolean = false;

	public var list : Array = new Array();
}

internal class PopUpData extends Destroyable
{

	public var channel : int;

	public var popUp : DisplayObject;

	public var transition : BasePopUpTransition;

	override public function destroy() : void
	{
		super.destroy();

		popUp = null;

		//transition.destroy();
		transition = null;

	}
}

class PopupEnforcer
{
}
