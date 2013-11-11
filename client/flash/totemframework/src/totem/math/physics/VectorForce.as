

package totem.math.physics
{
	import totem.math.Vector2D;
	
	/**
	 * A force represented by a 2D vector.
	 */
	public class VectorForce implements IForce
	{
		
		private var fvx : Number;
		
		private var fvy : Number;
		
		private var value : Vector2D;
		
		private var scaleMass : Boolean;
		
		
		public function VectorForce( useMass : Boolean, vx : Number, vy : Number )
		{
			fvx = vx;
			fvy = vy;
			scaleMass = useMass;
			value = new Vector2D ( vx, vy );
		}
		
		
		public function set vx( x : Number ) : void
		{
			fvx = x;
			value.x = x;
		}
		
		
		public function set vy( y : Number ) : void
		{
			fvy = y;
			value.y = y;
		}
		
		
		public function set useMass( b : Boolean ) : void
		{
			scaleMass = b
		}
		
		
		public function getValue( invmass : Number ) : Vector2D
		{
			if ( scaleMass )
			{
				value.setTo ( fvx * invmass, fvy * invmass );
			}
			return value;
		}
		
		public function toString() : String
		{
			return ( fvx + " : " + fvy );
		}
	}
}


