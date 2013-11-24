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

	import totem.core.Destroyable;

	public class Matrix2D extends Destroyable
	{

		internal static var disposed : Vector.<Matrix2D> = new Vector.<Matrix2D>();

		public static function create( a1 : Number = 1, a2 : Number = 0, a3 : Number = 0, b1 : Number = 0, b2 : Number = 1, b3 : Number = 0, c1 : Number = 0, c2 : Number = 0, c3 : Number = 1 ) : Matrix2D
		{
			if ( disposed.length > 0 )
				return disposed.shift().setTo( a1, a2, a3, b1, b2, b3, c1, c2, c3 );
			else
				return new Matrix2D( a1, a2, a3, b1, b2, b3, c1, c2, c3 );
		}

		public static function grow( value : int ) : void
		{
			for ( var i : int = 0; i < value; ++i )
			{
				disposed.push( new Matrix2D());
			}
		}

		private var a1 : Number;

		private var a2 : Number;

		private var a3 : Number;

		private var b1 : Number;

		private var b2 : Number;

		private var b3 : Number;

		private var c1 : Number;

		private var c2 : Number;

		private var c3 : Number;

		/**
		 * Use to perform complex Matrix operations on the <code>Vector</code> Object
		 * @param a1
		 * @param a2
		 * @param a3
		 * @param b1
		 * @param b2
		 * @param b3
		 * @param c1
		 * @param c2
		 * @param c3
		 *
		 */
		public function Matrix2D( a1 : Number = 1, a2 : Number = 0, a3 : Number = 0, b1 : Number = 0, b2 : Number = 1, b3 : Number = 0, c1 : Number = 0, c2 : Number = 0, c3 : Number = 1 )
		{
			this.a1 = a1;
			this.a2 = a2;
			this.a3 = a3;
			this.b1 = b1;
			this.b2 = b2;
			this.b3 = b3;
			this.c1 = c1;
			this.c2 = c2;
			this.c3 = c3;
		}

		/**
		 * Use to easily set the values of the Matrix.
		 * Leave blank to set as an Identity Matrix.
		 * @param a1
		 * @param a2
		 * @param a3
		 * @param b1
		 * @param b2
		 * @param b3
		 * @param c1
		 * @param c2
		 * @param c3
		 *
		 */

		/**
		 * Creates a clone of this Matrix object.
		 * @return The copied Matrix.
		 *
		 */
		public function copy() : Matrix2D
		{
			return new Matrix2D( a1, a2, a3, b1, b2, b3, c1, c2, c3 );
		}

		override public function destroy() : void
		{
			disposed.length = 0;
			disposed = null;
		}

		public function dispose() : Matrix2D
		{

			var a : Matrix2D;

			for each ( a in disposed )
				if ( this == a )
					return this;

			disposed.push( this );

			return this;
		}

		/**
		 * Use to multiply two Matrixes...mainly used internally.
		 * @param matrix The Matrix to multiply by.
		 *
		 */
		public function multiply( matrix : Matrix2D ) : Matrix2D
		{
			var m : Matrix2D = Matrix2D.create();

			//first row
			m.a1 = ( a1 * matrix.a1 ) + ( a2 * matrix.b1 ) + ( a3 * matrix.c1 );
			m.a2 = ( a1 * matrix.a2 ) + ( a2 * matrix.b2 ) + ( a3 * matrix.c2 );
			m.a3 = ( a1 * matrix.a3 ) + ( a2 * matrix.b3 ) + ( a3 * matrix.c3 );
			//second row
			m.b1 = ( b1 * matrix.a1 ) + ( b2 * matrix.b1 ) + ( b3 * matrix.c1 );
			m.b2 = ( b1 * matrix.a2 ) + ( b2 * matrix.b2 ) + ( b3 * matrix.c2 );
			m.b3 = ( b1 * matrix.a3 ) + ( b2 * matrix.b3 ) + ( b3 * matrix.c3 );
			//third row
			m.c1 = ( c1 * matrix.a1 ) + ( c2 * matrix.b1 ) + ( c3 * matrix.c1 );
			m.c2 = ( c1 * matrix.a2 ) + ( c2 * matrix.b2 ) + ( c3 * matrix.c2 );
			m.c3 = ( c1 * matrix.a3 ) + ( c2 * matrix.b3 ) + ( c3 * matrix.c3 );

			return setTo( m.a1, m.a2, m.a3, m.b1, m.b2, m.b3, m.c1, m.c2, m.c3 );
		}

		/**
		 * Use to rotate.
		 * ( Considers that the Vector object represents a point, not an actual vector )
		 * @param rot
		 *
		 */
		public function rotate( rot : Number ) : Matrix2D
		{
			var sin : Number = Math.sin( rot );
			var cos : Number = Math.cos( rot );
			return multiply( Matrix2D.create( cos, sin, 0, -sin, cos, 0, 0, 0, 1 ));
		}

		/**
		 * Use to rotate an ACTUAL Vector object.
		 * @param fwd The heading Vector
		 * @param side The perpendicular Vector to the heading.
		 *
		 */
		public function rotateVector( a_fwd : Vector2D, a_side : Vector2D ) : Matrix2D
		{
			return multiply( Matrix2D.create( a_fwd.x, a_fwd.y, 0, a_side.x, a_side.y, 0, 0, 0, 1 ));
		}

		/**
		 * Use to scale
		 * @param xScale
		 * @param yScale
		 *
		 */
		public function scale( xScale : Number, yScale : Number ) : Matrix2D
		{
			return multiply( Matrix2D.create( xScale, 0, 0, 0, yScale, 0, 0, 0, 1 ));
		}

		public function setTo( a1 : Number = 1, a2 : Number = 0, a3 : Number = 0, b1 : Number = 0, b2 : Number = 1, b3 : Number = 0, c1 : Number = 0, c2 : Number = 0, c3 : Number = 1 ) : Matrix2D
		{
			this.a1 = a1;
			this.a3 = a3;
			this.b1 = b1;
			this.b2 = b2;
			this.b3 = b3;
			this.c1 = c1;
			this.c2 = c2;
			this.c3 = c3;
			return this;
		}

		/**
		 * This is used to do the final transformation upon a Vector
		 * @param point The Vector to apply this Matrix transformation to.
		 *
		 */
		public function transformVector( point : Vector2D ) : Matrix2D
		{
			var tempX : Number = ( a1 * point.x ) + ( b1 * point.y ) + ( c1 );
			var tempY : Number = ( a2 * point.x ) + ( b2 * point.y ) + ( c2 );
			point.x = tempX;
			point.y = tempY;

			return this;
		}

		/**
		 * Use to apply a translation (move position)
		 * @param x The x offset to move.
		 * @param y The y offset to move.
		 *
		 */
		public function translate( x : Number, y : Number ) : Matrix2D
		{
			return multiply( Matrix2D.create( 1, 0, 0, 0, 1, 0, x, y, 1 ));
		}
	}
}

