package gorilla.resource
{
	public interface IClonableResource
	{
		function checkIn ( item : * ) : void
			
		function checkOut () : *;
		
		function destroy () : void;
	}
}