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

	import totem.core.Destroyable;
	import totem.data.type.Point2d;

	public class AABBox extends Destroyable
	{
		internal static var disposed : Vector.<AABBox> = new Vector.<AABBox>();

		public static function create( center : Vector2D, width : Number, height : Number ) : AABBox
		{
			if ( disposed.length > 0 )
				return disposed.pop().setTo( center, width, height );
			else
				return new AABBox( center, width, height );
		}

		public static function grow( value : int ) : void
		{
			while ( value-- )
			{
				disposed.push( new AABBox( Vector2D.create().dispose(), 0, 0 ));
			}
		}

		public var bottom : Number;

		public var bottomLeft : Vector2D;

		public var bottomRight : Vector2D;

		public var center : Vector2D;

		public var halfHeight : Number;

		public var halfWidth : Number;

		public var height : Number;

		public var left : Number;

		public var right : Number;

		public var top : Number;

		public var topLeft : Vector2D;

		public var topRight : Vector2D;

		public var width : Number;

		/**
		 * Use to store Rect shape data
		 * @param left
		 * @param top
		 * @param right
		 * @param bottom
		 *
		 */
		public function AABBox( _center : Vector2D = null, width : Number = 0, height : Number = 0 )
		{
			this.center = ( _center ) ? _center.clone() : new Vector2D( _center.x, _center.y );

			this.width = width;
			this.height = height;
			halfWidth = width / 2;
			halfHeight = height / 2;

			left = _center.x - halfWidth;
			right = _center.x + halfWidth;
			top = _center.y - halfHeight;
			bottom = _center.y + halfHeight;

			topLeft = new Vector2D( left, top );
			topRight = new Vector2D( right, top );
			bottomRight = new Vector2D( right, bottom );
			bottomLeft = new Vector2D( left, bottom );

		}

		public function contains( x : int, y : int ) : Boolean
		{
			if (( x > right ) || ( x < left ) || ( y < top ) || ( y > bottom ))
			{
				return false;
			}

			return true;
		}

		public function containsPoint( pt : Point2d ) : Boolean
		{
			return contains( pt.x, pt.y );
		}

		override public function destroy() : void
		{
			disposed.length = 0;
			disposed = null;
		}

		public function dispose() : AABBox
		{
			var a : AABBox;

			for each ( a in disposed )
				if ( this == a )
					return this;

			disposed.push( this );

			return this;
		}

		public function isOverlapping( box : AABBox ) : Boolean
		{
			return !(( box.top > bottom ) || ( box.bottom < top ) || ( box.left > right ) || ( box.right < left ));
		}

		/**
		 * Centers the box at the specified point.
		 * @param point Center point at which to move the box.
		 *
		 */
		public function moveTo( point : Vector2D ) : AABBox
		{

			center.x = point.x;
			center.y = point.y;
			left = center.x - halfWidth;
			right = center.x + halfWidth;
			top = center.y - halfHeight;
			bottom = center.y + halfHeight;
			topLeft.x = left;
			topLeft.y = top;
			topRight.x = right;
			topRight.y = top;
			bottomRight.x = right;
			bottomRight.y = bottom;
			bottomLeft.x = left;
			bottomLeft.y = bottom;

			return this;
		}

		public function setSize( width : Number, height : Number ) : AABBox
		{
			this.width = width;
			this.height = height;
			halfWidth = width / 2;
			halfHeight = height / 2;

			left = center.x - halfWidth;
			right = center.x + halfWidth;
			top = center.y - halfHeight;
			bottom = center.y + halfHeight;

			topLeft.x = left;
			topLeft.y = top;
			topRight.x = right;
			topRight.y = top;
			bottomRight.x = right;
			bottomRight.y = bottom;
			bottomLeft.x = left;
			bottomLeft.y = bottom;
			return this;
		}

		/**
		 * Use to change any values in the AABBox so that everything is updated correctly.
		 * @param left
		 * @param top
		 * @param right
		 * @param bottom
		 *
		 */
		public function setTo( center : Vector2D, width : Number, height : Number ) : AABBox
		{
			this.center.x = center.x;
			this.center.y = center.y;

			setSize( width, height );

			return this;
		}

		public function toRectangle() : BoxRectangle
		{
			var rectangle : BoxRectangle = new BoxRectangle( left, top, width, height );

			return rectangle;
		}

		public function toString() : String
		{
			return ( "center: " + center.toString() + ", dimen: l = " + left + ", r = " + right + ", t = " + top +  ", b = " + bottom )
		}
	}
}

