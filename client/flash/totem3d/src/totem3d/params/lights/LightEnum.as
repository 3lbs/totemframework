package totem3d.params.lights
{
	import avmplus.getQualifiedClassName;
	
	import away3d.lights.DirectionalLight;
	import away3d.lights.PointLight;
	
	public class LightEnum
	{
		
		public static const POINT_LIGHT : LightEnum = new LightEnum ( PointLight );
		
		public static const DIRECTION_LIGHT : LightEnum = new LightEnum ( DirectionalLight );
		
		private var _typeClass : Class;
		
		[Bindable]
		public var type : String;
		
		public function LightEnum( value : Class )
		{
			_typeClass = value;
			
			type = getQualifiedClassName ( _typeClass ).split ( "::" )[ 1 ];
		
		}
		
		public static function get list() : Array
		{
			return [ POINT_LIGHT, DIRECTION_LIGHT ];
		}
		
		public static function getEnumByType( value : String ) : LightEnum
		{
			for each ( var enum : LightEnum in list )
			{
				if ( enum.type == value )
				{
					return enum;
				}
			}
			return null;
		}
		
		public function getTypeClass() : Class
		{
			return _typeClass;
		}
	
	
	}
}

