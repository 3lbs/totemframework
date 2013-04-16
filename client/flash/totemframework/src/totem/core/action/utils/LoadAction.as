package totem.core.action.utils
{

	import totem.core.action.Action;

	public class LoadAction extends Action
	{
		public function LoadAction( url : String, name : String = null, instantUpdate : Boolean = false )
		{
			super( name, instantUpdate );
		}
	}
}
