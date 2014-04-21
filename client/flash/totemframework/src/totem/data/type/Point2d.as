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

package totem.data.type
{

	import flash.geom.Point;
	
	import totem.math.Vector2D;

	public class Point2d extends Point
	{

		internal static var disposed : Vector.<Point2d> = new Vector.<Point2d>();

		public static function create( x : Number = 0, y : Number = 0 ) : Point2d
		{
			if ( disposed.length == 0 )
			{
				return new Point2d( x, y );
			}
			return disposed.pop().reset( x, y ) as Point2d;
		}

		public static function destroy() : void
		{
			disposed.length = 0;
			disposed = null;
		}

		public static function distanceTwoPoints( x1 : Number, y1 : Number, x2 : Number, y2 : Number ) : Number
		{
			var dx : Number = x1 - x2;
			var dy : Number = y1 - y2;
			return Math.sqrt( dx * dx + dy * dy );
		}

		public static function fromPoint( point : Point ) : Point2d
		{
			return create( point.x, point.y );
		}

		public static function grow( value : int ) : void
		{
			while ( value-- )
			{
				disposed.push( new Point2d());
			}
		}

		public function Point2d( x : Number = 0, y : Number = 0 )
		{
			super( x, y );
		}

		public function subBy( vector : Point2d ) : Point2d
		{
			x -= vector.x;
			y -= vector.y;
			
			return this;
		}
		
		public function addTo( pt : Point2d ) : Point2d
		{
			x += pt.x;
			y += pt.y;

			return this;
		}

		public function addedTo( pt : Point2d ) : Point2d
		{
			return Point2d.create( x + pt.x, y + pt.y );
		}

		override public function clone() : Point
		{
			return Point2d.create( x, y );
		}

		public function copy( pt : Point ) : Point2d
		{
			x = pt.x;
			y = pt.y;

			return this;
		}

		public function dispose() : Point2d
		{
			var a : Point2d;

			var idx : int = disposed.indexOf( this );

			if ( idx > -1 )
				return this;

			disposed.push( this );
			return this;
		}

		public function distance( point0 : Point2d ) : Number
		{
			return Point.distance( this, point0 );
		}

		public function empty() : void
		{
			x = 0;
			y = 0;
		}

		public function multiply( scaler : Number ) : Point2d
		{
			this.x *= scaler;
			this.y *= scaler;

			return this;
		}

		public function reset( x : Number = 0, y : Number = 0 ) : Point2d
		{
			this.x = x;
			this.y = y;
			return this;
		}

		public function toVector2d() : Vector2D
		{
			return Vector2D.create( x, y );
		}
	}
}
