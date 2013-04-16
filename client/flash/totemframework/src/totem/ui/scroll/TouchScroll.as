package totem.ui.scroll
{

	import com.greensock.BlitMask;
	import com.greensock.TweenLite;
	import com.greensock.easing.Strong;
	import com.greensock.plugins.ThrowPropsPlugin;
	import com.greensock.plugins.TweenPlugin;

	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;

	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import totem.display.layout.TSprite;

	public class TouchScroll extends TSprite
	{

		public var mouseUpScrollEvent : ISignal = new Signal( TouchScroll );

		public var mouseDownScrollEvent : ISignal = new Signal( TouchScroll );

		public var scrollTweenComplete : ISignal = new Signal( TouchScroll );

		private var bounds : Rectangle;

		/**
		 * Constructor function
		 */
		var t1 : uint, t2 : uint, y1 : Number, y2 : Number, yOverlap : Number, yOffset : Number, dy : int;

		private var blitMask : BlitMask;

		private var _scrollContent : DisplayObject;

		private var _bitmapMode : Boolean = false;

		private var _scrollEnabled : Boolean = true;

		public var isAnimating : Boolean;

		public function TouchScroll() : void
		{
			initialize();
		}

		public function get scrollEnabled() : Boolean
		{
			return _scrollEnabled;
		}

		public function set scrollEnabled( value : Boolean ) : void
		{
			_scrollEnabled = value;
		}

		protected function initialize() : void
		{
			TweenPlugin.activate([ ThrowPropsPlugin ]);
			bounds = new Rectangle( 0, 0, 500, 500 );

			blitMask = new BlitMask( null );
			blitMask.addEventListener( MouseEvent.MOUSE_DOWN, mouseDownHandler );
			blitMask.bitmapMode = true;
		}

		protected function mouseDownHandler( event : MouseEvent ) : void
		{

			if ( !_scrollEnabled )
				return;

			TweenLite.killTweensOf( _scrollContent );
			dy = y1 = y2 = _scrollContent.y;
			yOffset = _scrollContent.stage.mouseY - _scrollContent.y;
			yOverlap = Math.max( 0, _scrollContent.height - bounds.height );
			t1 = t2 = getTimer();
			_scrollContent.stage.addEventListener( MouseEvent.MOUSE_MOVE, mouseMoveHandler );
			_scrollContent.stage.addEventListener( MouseEvent.MOUSE_UP, mouseUpHandler );

			blitMask.bitmapMode = false;
			blitMask.update( null, true );

			mouseDownScrollEvent.dispatch( this );
		}

		protected function mouseMoveHandler( event : MouseEvent ) : void
		{
			var y : Number = _scrollContent.stage.mouseY - yOffset;

			//if mc's position exceeds the bounds, make it drag only half as far with each mouse movement (like iPhone/iPad behavior)
			if ( y > bounds.top )
			{
				_scrollContent.y = ( y + bounds.top ) * 0.5;
			}
			else if ( y < bounds.top - yOverlap )
			{
				_scrollContent.y = ( y + bounds.top - yOverlap ) * 0.5;
			}
			else
			{
				_scrollContent.y = y;
			}
			//blitMask.update();
			var t : uint = getTimer();

			//if the frame rate is too high, we won't be able to track the velocity as well, so only update the values 20 times per second
			if ( t - t2 > 50 )
			{
				y2 = y1;
				t2 = t1;
				y1 = _scrollContent.y;
				t1 = t;
			}
			event.updateAfterEvent();
		}

		public function get scrollContent() : DisplayObject
		{
			return _scrollContent;
		}

		public function set scrollContent( value : DisplayObject ) : void
		{
			_scrollContent = value;
			blitMask.target = value;
			blitMask.bitmapMode = false;
			blitMask.update();
		}

		protected function mouseUpHandler( event : MouseEvent ) : void
		{

			mouseUpScrollEvent.dispatch( this );

			_scrollContent.stage.removeEventListener( MouseEvent.MOUSE_UP, mouseUpHandler );
			_scrollContent.stage.removeEventListener( MouseEvent.MOUSE_MOVE, mouseMoveHandler );
			var time : Number = ( getTimer() - t2 ) / 1000;
			var yVelocity : Number = ( _scrollContent.y - y2 ) / time;

			// prevent interactivity
			if ( ( Math.abs( _scrollContent.y - dy ) > 5 ) || Math.abs( yVelocity ) > 50 )
				isAnimating = true;
	
			ThrowPropsPlugin.to( _scrollContent, { throwProps: { y: { velocity: yVelocity, max: bounds.top, min: bounds.top - yOverlap, resistance: 50 }}, onStart: blitMask.enableBitmapMode, onComplete: onTweenComplete, onUpdate: blitMask.update, ease: Strong.easeOut }, 10, 0.3, 1 );
		}

		protected function onTweenComplete() : void
		{
			blitMask.bitmapMode = false;
			isAnimating = false;
			scrollTweenComplete.dispatch( this );
		}

		public function get bitmapMode() : Boolean
		{
			return _bitmapMode;
		}

		public function set bitmapMode( value : Boolean ) : void
		{
			if ( value != _bitmapMode )
			{
				_bitmapMode = value;
				blitMask.bitmapMode = _bitmapMode;
			}
		}

		public function resize( width : Number, height : Number ) : void
		{
			maskWidth = width;
			maskHeight = height;
		}

		public function get maskWidth() : Number
		{
			return bounds.width;
		}

		public function set maskWidth( value : Number ) : void
		{
			bounds.width = value;

			blitMask.width = value;
			blitMask.update( null, true );
		}

		public function get maskHeight() : Number
		{
			return bounds.height;
		}

		public function set maskHeight( value : Number ) : void
		{
			bounds.height = value;

			blitMask.height = value;
			blitMask.update( null, true );
		}
		

		override public function destroy() : void
		{
			super.destroy();

			TweenLite.killTweensOf( _scrollContent );

			blitMask.dispose();
			blitMask = null;

			_scrollContent = null;
		}
	}
}
