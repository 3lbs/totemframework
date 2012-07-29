package totem.utils
{
	import flash.utils.Dictionary;
	
	import totem.core.IDestroyable;

	public class DestroyUtil
	{
		public function DestroyUtil()
		{
		}
		
		public static function destroyDictionary ( dict : Dictionary ) : void
		{
			for ( var key : String in dict )
			{
				if ( dict[key] is IDestroyable )
				{
					IDestroyable( dict[key] ).destroy();
				}
				
				dict[key] = null;
				delete dict[key];
			}
		}
	}
}