package totem3d.texture
{
	import flash.events.IEventDispatcher;
	
	import org.casalib.events.RemovableEventDispatcher;
	
	public class TextureBuilder extends RemovableEventDispatcher
	{
		public function TextureBuilder(target:IEventDispatcher=null)
		{
			super(target);
		}
	}
}