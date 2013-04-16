package totem.core.mvc.modular.base
{

	import totem.core.mvc.TotemContext;
	import totem.core.mvc.view.MediatorSystem;

	/**
	 * @author dlaurent 7 juin 2012
	 */
	public class ModuleMediatorMap extends MediatorSystem
	{
		public function ModuleMediatorMap( instance : TotemContext )
		{
			super( instance );
		}

		public function dispose() : void
		{
			
		}
	}
}
