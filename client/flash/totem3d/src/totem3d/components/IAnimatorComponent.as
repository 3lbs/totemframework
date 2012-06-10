package totem3d.components
{
	import totem3d.core.datatypeobject.AnimationParam;
	
	public interface IAnimatorComponent
	{
		function loadAnimations( data : Vector.<AnimationParam> ) : void;
		function playAnimation( id : String ) : Boolean;
	}
}

