package totem.core.mvc.controller.api
{
	public class Guard implements IGuard
	{
		public function Guard()
		{
		
		}
		
		public function allow () : Boolean
		{
			return false;
		}
	}
}