package totem
{

	import mx.collections.IList;
	
	import nz.co.codec.flexorm.EntityManager;
	
	import org.swiftsuspenders.Injector;
	
	import totem.core.TotemGroup;
	import totem.core.TotemObject;

	use namespace totem_internal;

	public class Totem
	{
		public static const rootGroup : TotemGroup = new TotemGroup();

		// warning dont use this!!!  I did this to make compatiable for robot legs and other system using injection.  Not for game use
		
		public static function setInjector( object : TotemObject, injector : Injector ) : void
		{
			object.setInjector( injector );
		}
		
		private var entityManager : EntityManager;
		
		private var list : IList;
	}
}
