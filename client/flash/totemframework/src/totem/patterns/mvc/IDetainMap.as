package totem.patterns.mvc
{
	public interface IDetainMap
	{
		function detain( command : Object ) : void
		
		function release( command : Object ) : void
	}
}