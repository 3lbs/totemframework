package totem3d.texture
{
	import org.casalib.core.IDestroyable;
	
	public class BasicTexture implements IDestroyable
	{
		public function BasicTexture()
		{
		}
		
		public function destroy():void
		{
		}
		
		public function get destroyed():Boolean
		{
			return false;
		}
	}
}