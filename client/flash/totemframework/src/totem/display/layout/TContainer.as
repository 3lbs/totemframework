package totem.display.layout
{

	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Point;

	public class TContainer extends TSprite
	{
		private var _contentWidth : Number = 0;

		private var _contentHeight : Number = 0;

		private var _scale : int = 1;

		private var _backgroundColor : uint = 0;

		private var _backgroundBitmapData : BitmapData;

		private var _backgroundAlpha : Number = 1.0;

		private var _backgroundRoundedCorners : Number = 0;

		private var _backgroundVisible : Boolean = false;

		public function TContainer()
		{
			super();
		}

		public function get contentWidth() : Number
		{
			return _contentWidth;
		}

		public function set contentWidth( value : Number ) : void
		{
			_contentWidth = value;
			updateDisplay();
		}

		public function get contentHeight() : Number
		{
			return _contentHeight;
		}

		public function set contentHeight( value : Number ) : void
		{
			_contentHeight = value;
			updateDisplay();
		}

		public function updateDisplay() : void
		{
			graphics.clear();

			if ( _backgroundVisible )
			{
				if ( _backgroundBitmapData )
				{
					graphics.beginBitmapFill( _backgroundBitmapData );
					graphics.drawRect( 0, 0, contentWidth, contentHeight );
					graphics.endFill();
				}
				else
				{
					graphics.beginFill( _backgroundColor, _backgroundAlpha );
					graphics.drawRect( 0, 0, contentWidth, contentHeight );
					graphics.endFill();
				}
			}
		}

		public function set backgroundBitmap( bitmapData : BitmapData ) : void
		{
			_backgroundVisible = ( bitmapData != null );
			_backgroundBitmapData = bitmapData;
			updateDisplay();
		}

		public function get backgroundColor() : uint
		{
			return _backgroundColor;
		}

		public function set backgroundColor( value : uint ) : void
		{
			_backgroundVisible = true;
			_backgroundColor = value;
			updateDisplay();
		}

		public function get backgroundAlpha() : Number
		{
			return _backgroundAlpha;
		}

		public function set backgroundAlpha( value : Number ) : void
		{
			_backgroundAlpha = value;
			updateDisplay();
		}

		public function get center() : Point
		{
			var px : Number = this.x + (( this.contentWidth * _scale ) / 2 );
			var py : Number = this.y + (( this.contentHeight * _scale ) / 2 );
			var p0 : Point = new Point( px, py );
			return p0;
		}

		public function get centerX() : Number
		{
			return this.x + (( this.contentWidth * _scale ) / 2 );
		}

		public function set centerX( _x : Number ) : void
		{
			this.x = _x - (( this.contentWidth * _scale ) / 2 );
		}

		public function get centerY() : Number
		{
			return this.y + (( this.contentHeight * _scale ) / 2 );
		}

		public function set centerY( _y : Number ) : void
		{
			this.y = _y - (( this.contentHeight * _scale ) / 2 );
		}

		override public function set enabled( enable : Boolean ) : void
		{
			super.enabled = enable;

			for each ( var sprite : DisplayObject in this.children )
			{
				if ( sprite is TSprite )
				{
					( sprite as TSprite ).enabled = enable;
				}
			}
		}
		
		public function get backgroundVisible() : Boolean
		{
			return _backgroundVisible;
		}
		
		public function set backgroundVisible( value : Boolean ) : void
		{
			_backgroundVisible = value;
			updateDisplay();
		}
		
		public function centerChildObject( displayObject : DisplayObject ) : void
		{
			var w : Number = displayObject.width;
			var h : Number = displayObject.height;
			
			displayObject.x = center.x - ( w / 2 );
			displayObject.y = center.y - ( h / 2 );
		}
	}
}
