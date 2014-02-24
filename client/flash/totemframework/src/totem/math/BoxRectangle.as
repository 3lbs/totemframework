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

package totem.math
{

	import flash.geom.Rectangle;

	import totem.data.type.Point2d;

	public class BoxRectangle extends Rectangle
	{

		public static const ZERO_RECTANGLE : BoxRectangle = new BoxRectangle();

		internal static var disposed : Vector.<BoxRectangle> = new Vector.<BoxRectangle>();

		public static function create( x : Number = 0, y : Number = 0, width : Number = 0, height : Number = 0 ) : BoxRectangle
		{
			if ( disposed.length > 0 )
				return disposed.pop().reset( x, y, width, height );
			else
				return new BoxRectangle( x, y, width, height );
		}

		public static function grow( value : int ) : void
		{
			while ( value-- )
			{
				disposed.push( new BoxRectangle());
			}
		}

		private var _center : Vector2D;

		private var _position : Vector2D;

		public function BoxRectangle( x : Number = 0, y : Number = 0, width : Number = 0, height : Number = 0 )
		{
			_position = new Vector2D( x, y );
			super( x, y, width, height );
		}

		public function area() : Number
		{
			return width * height;
		}

		public function get center() : Vector2D
		{
			_center ||= new Vector2D();

			_center.x = width * 0.5;
			_center.y = height * 0.5;

			return _center;
		}

		override public function clone() : Rectangle
		{
			return BoxRectangle.create( x, y, width, height );
		}

		public function copy( v : Rectangle ) : BoxRectangle
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

		public function dispose() : void
		{

			this.setEmpty();

			var a : BoxRectangle;

			var idx : int = disposed.indexOf( this );

			if ( idx > -1 )
				return;

			disposed.push( this );

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

		public function get position() : Vector2D
		{
			_position.x = x;
			_position.y = y;
			return _position;
		}

		public function randomPosition( result : Point2d = null ) : Point2d
		{
			result ||= Point2d.create();

			result.x = Math.floor( Math.random() * this.width ) + this.x;
			result.y = Math.floor( Math.random() * this.height ) + this.y;

			return result;
		}

		public function reset( xa : Number, ya : Number, widtha : Number, heighta : Number ) : BoxRectangle
		{

			setTo( xa, ya, widtha, heighta );
			return this;

		}
	}
}
