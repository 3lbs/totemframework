package totem.math.physics
{
	import totem.math.Vector2D;
	
	public interface IForce
	{
		function getValue( invMass : Number ) : Vector2D;
	}
}

