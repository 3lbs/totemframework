package totem3d.actors.components
{
	public interface IAnimatorComponent
	{
		function playAnimation( id : String ) : Boolean;
		
		function stopAnimation () : void
	}
}

