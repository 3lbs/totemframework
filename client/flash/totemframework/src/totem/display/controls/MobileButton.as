package totem.display.controls
{

	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.TouchEvent;
	import flash.geom.Point;

	import totem.events.RemovableEventDispatcher;

	public class MobileButton extends RemovableEventDispatcher
	{

		/**
		 * @private
		 */
		private static const HELPER_POINT : Point = new Point();

		/**
		 * @private
		 */
		//private static const HELPER_TOUCHES_VECTOR : Vector.<Touch> = new <Touch>[];

		protected var _stateNames : Vector.<String> = new <String>[ STATE_UP, STATE_DOWN, STATE_HOVER, STATE_DISABLED ];

		/**
		 * @private
		 */
		public static const STATE_UP : String = "up";

		/**
		 * @private
		 */
		public static const STATE_DOWN : String = "down";

		/**
		 * @private
		 */
		public static const STATE_HOVER : String = "hover";

		/**
		 * @private
		 */
		public static const STATE_DISABLED : String = "disabled";

		public function MobileButton( target : IEventDispatcher = null )
		{
			super( target );
		}

		/**
		 * @private
		 */
		protected var _currentState : String = STATE_UP;

		/**
		 * @private
		 */
		protected function get currentState() : String
		{
			return this._currentState;
		}

		/**
		 * @private
		 */
		protected function set currentState( value : String ) : void
		{
			if ( this._currentState == value )
			{
				return;
			}

			/*if ( this.stateNames.indexOf( value ) < 0 )
			{
				throw new ArgumentError( "Invalid state: " + value + "." );
			}*/
			this._currentState = value;
		}

		/**
		 * @private
		 */
		protected var _isToggle : Boolean = false;

		/**
		 * Determines if the button may be selected or unselected when clicked.
		 */
		public function get isToggle() : Boolean
		{
			return this._isToggle;
		}

		/**
		 * @private
		 */
		public function set isToggle( value : Boolean ) : void
		{
			this._isToggle = value;
		}

		/**
		 * @private
		 */
		protected var _isSelected : Boolean = false;

		private var _isEnabled : Boolean;

		private var touchable : Boolean;

		private var _touchPointID : int;

		/**
		 * Indicates if the button is selected or not. The button may be
		 * selected programmatically, even if <code>isToggle</code> is false.
		 *
		 * @see #isToggle
		 */
		public function get isSelected() : Boolean
		{
			return this._isSelected;
		}

		/**
		 * @private
		 */
		public function set isSelected( value : Boolean ) : void
		{
			if ( this._isSelected == value )
			{
				return;
			}
			this._isSelected = value;
			//this.invalidate( INVALIDATION_FLAG_SELECTED );
			this.dispatchEvent( new Event( Event.CHANGE ));
		}

		/**
		 * @inheritDoc
		 */
		public function set isEnabled( value : Boolean ) : void
		{
			if ( this._isEnabled == value )
			{
				return;
			}

			if ( !this._isEnabled )
			{
				this.touchable = false;
				this.currentState = STATE_DISABLED;
				this._touchPointID = -1;
			}
			else
			{
				//might be in another state for some reason
				//let's only change to up if needed
				if ( this.currentState == STATE_DISABLED )
				{
					this.currentState = STATE_UP;
				}
				this.touchable = true;

			}
		}

		protected function touchHandler( event : TouchEvent ) : void
		{
			if ( !this._isEnabled )
			{
				return;
			}

			//HELPER_TOUCHES_VECTOR.length = 0;
		}
	}
}
