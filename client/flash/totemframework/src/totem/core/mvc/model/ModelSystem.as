package totem.core.mvc.model
{
	import flash.utils.Dictionary;
	
	import avmplus.getQualifiedClassName;
	
	import totem.core.ITotemSystem;
	import totem.core.TotemSystem;
	
	public class ModelSystem extends TotemSystem
	{
		
		private var _models : Dictionary = new Dictionary();
		
		public function ModelSystem(name:String=null)
		{
			super(name);
		}
		
		
		public function removeModel ( clazz : Class ) : void 
		{
			var shortName : String = getShortName( clazz );
			
			var instance : Object = retriveModel( clazz );
			
			if ( instance.hasOwnProperty("destroy" ) )
				instance.destroy();
			
		}
		public function registerModel( clazz : Class, instance : *, doInjectInto : Boolean = true ) : *
		{
			// register a short name for the manager, this is mainly used for tooling
			var shortName : String = getShortName( clazz );
			
			injector.map( clazz ).toValue( instance );
			
			
			_models [ shortName ] = instance;
			
			if ( doInjectInto )
				injector.injectInto( instance );
			
			/*if ( instance is TotemObject )
			{
				TotemObject( instance ).owningGroup = this;
			}*/
			
			if ( instance is ITotemSystem )
			{
				( instance as ITotemSystem ).initialize();
			}
			
			return instance;
		}
		
		public function retriveModel ( clazz : Class ) : *
		{
			var shortName : String = getShortName( clazz );
			
			if ( _models[ shortName ] )
				return _models[ shortName ];
			
			return null;
		}
		
		private function getShortName ( clazz : Class ) : String
		{
			return getQualifiedClassName( clazz ).split( "::" )[ 1 ];
		}
		
		override public function destroy():void
		{
			super.destroy();
			
			
		}
	}
}