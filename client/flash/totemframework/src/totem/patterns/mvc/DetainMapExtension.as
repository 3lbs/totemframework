package totem.patterns.mvc
{
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IExtension;

	import totem.utils.UID;

	public class DetainMapExtension implements IExtension
	{

		private const _uid : String = UID.create( DetainMapExtension );

		public function extend( context : IContext ) : void
		{
			context.injector.map( IDetainMap ).toSingleton( DetainMap );
		}

		public function toString() : String
		{
			return _uid;
		}
	}
}
