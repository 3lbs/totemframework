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
//   3lbs Copyright 2013 
//   For more information see http://www.3lbs.com 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package totem.math
{

	import flash.geom.Rectangle;

	public class BoxRectangle extends Rectangle
	{

		public static const ZERO_RECTANGLE : BoxRectangle = new BoxRectangle();

		internal static var disposed : Vector.<BoxRectangle> = new Vector.<BoxRectangle>();

		public static function create( x : Number = 0, y : Number = 0, width : Number = 0, height : Number = 0 ) : BoxRectangle
		{
			if ( disposed.length > 0 )
				return disposed.shift().SetTo( x, y, width, height );
			else
				return new BoxRectangle( x, y, width, height );
		}

		public static function grow( value : int ) : void
		{
			for ( var i : int = 0; i < value; ++i )
			{
				disposed.push( new BoxRectangle());
			}
		}

		public function BoxRectangle( x : Number = 0, y : Number = 0, width : Number = 0, height : Number = 0 )
		{
			super( x, y, width, height );
		}

		public function SetTo( xa : Number, ya : Number, widtha : Number, heighta : Number ) : BoxRectangle
		{

			setTo( xa, ya, widtha, heighta );
			return this;

		}

		public function area() : Number
		{
			return width * height;
		}

		override public function clone() : Rectangle
		{
			var newVector : BoxRectangle = BoxRectangle.create( x, y, width, height );
			return newVector;
		}

		public function copy( v : BoxRectangle ) : BoxRectangle
		{
			this.x = v.x;
			this.y = v.y;
			this.width = v.width;
			this.height = v.height;
			return this;
		}

		public function destroy() : void
		{
			disposed.length = 0;
			disposed = null;
		}

		public function dispose() : BoxRectangle
		{

			this.setEmpty();

			var a : BoxRectangle;

			for each ( a in disposed )
				if ( this == a )
					return this;

			disposed.push( this );

			return this;
		}

		public function divide( scalar : Number ) : BoxRectangle
		{
			this.x /= scalar;
			this.y /= scalar;
			this.width /= scalar;
			this.height /= scalar;

			return this;
		}

		public function dividedBy( scalar : Number ) : BoxRectangle
		{
			if ( scalar == 0 )
			{
				trace( "Vector::dividedBy() - Illegal Divide by Zero!" );
				return BoxRectangle.create();
			}
			else
			{
				return BoxRectangle.create( x / scalar, y / scalar, width / scalar, height / scalar );
			}
		}

		public function moveTo( x, y ) : BoxRectangle
		{
			this.x = x;
			this.y = y;
			return this;
		}

		public function multiply( scalar : Number ) : BoxRectangle
		{
			this.x *= scalar;
			this.y *= scalar;
			this.width *= scalar;
			this.height *= scalar;
			return this;
		}

		public function multiplyBy( scalar : Number ) : BoxRectangle
		{
			return BoxRectangle.create( x * scalar, y * scalar, width * scalar, height * scalar );
		}
	}
}
