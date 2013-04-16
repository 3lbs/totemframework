package AI.boid
{
	import totem.math.Vector2D;
	
	public interface IBoid
	{
		function get neighborDistance():Number;
		
		function set neighborDistance(value:Number):void;
		
		function get maxAcceleration():Number;
		
		function set maxAcceleration(value:Number):void;
		
		/*function get parent():Entity;
		
		function set parent(a_value:Entity):void*/
		
		function get actualPos () : Vector2D;
		
		function get velocity () : Vector2D;
		
		function get maxSpeed() : Number;
	}
}


