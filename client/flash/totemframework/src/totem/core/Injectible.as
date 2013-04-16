package totem.core
{
	import org.swiftsuspenders.Injector;

	public class Injectible extends Destroyable
	{
		private var injector_ : Injector;

		public function getInjector() : Injector
		{
			return injector_;
		}

		public function setInjector( injector : Injector ) : void
		{
			injector_ = injector;
		}
		
		override public function destroy():void
		{
			super.destroy();
			
			injector_.teardown();
			injector_ = null;
			
		}
	}
}
