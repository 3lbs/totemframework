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
			else
			{
				return disposed.pop().SetTo( x, y ) as Point2d;
			}
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

		public static function grow( value : int ) : void
		{
			for ( var i : int = 0; i < value; ++i )
			{
				disposed.push( new Point2d());
			}
		}

		public function Point2d( x : Number = 0, y : Number = 0 )
		{
			super( x, y );
		}

		public function SetTo( x, y ) : Point2d
		{
			this.x = x;
			this.y = y;
			return this;
		}

		public function addedTo( vector : Point2d ) : Point2d
		{
			return Point2d.create( x + vector.x, y + vector.y );
		}

		override public function clone() : Point
		{
			return Point2d.create( x, y );
		}

		public function dispose() : void
		{
			var a : Point2d;

			for each ( a in disposed )
				if ( this == a )
					return;

			disposed.push( this );
		}

		public function distance( point0 : Point2d ) : Number
		{
			return Point.distance( this, point0 );
		}
	}
}