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

	import flash.geom.Point;

	import totem.data.type.Point2d;

	public class Circle extends Point2d
	{
		public var radius : Number;

		private const POINT : Point = new Point();

		public function Circle( x : Number = 0, y : Number = 0, radius : Number = 0 )
		{
			this.radius = radius;
			super( x, y );
		}

		public function containsPoint( dx : Number, dy : Number ) : Boolean
		{
			POINT.x = dx;
			POINT.y = dy;

			return Point.distance( this, POINT ) <= radius;
			//return this.distance( pt ) <= radius;
		}

		public function randomPosition( padding : Number = 0, pt : Point2d = null ) : Point2d
		{
			pt ||= new Point2d();

			var r = ( radius - padding ) * Math.sqrt( Math.random());
			var theta = 2 * Math.PI * Math.random();
			pt.x = x + r * Math.cos( theta );
			pt.y = y + r * Math.sin( theta );

			return pt;
		}
	}
}
