package AI.collision
{
	import totem.core.Destroyable;

	public class ACollider extends Destroyable implements ICollision
	{
		public function ACollider()
		{
		}
		
		override public function destroy():void
		{
			super.destroy();
			
		}
		
	}
}