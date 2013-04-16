package totem3d.texture
{
	import flash.events.IEventDispatcher;
	
	import totem.events.RemovableEventDispatcher;
	
	public class TextureBuilder extends RemovableEventDispatcher
	{
		public function TextureBuilder(target:IEventDispatcher=null)
		{
			super(target);
		}
	}
}