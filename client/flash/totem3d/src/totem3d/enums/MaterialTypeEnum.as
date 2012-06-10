package totem3d.enums
{
	
	public class MaterialTypeEnum
	{
		public static const BITMAPDATA_MATERIAL : MaterialTypeEnum = new MaterialTypeEnum ( "Bitmap Material", "away3d.materials.TextureMaterial" );
		
		public static const ANIMATED_BITMAPMATERIAL : MaterialTypeEnum = new MaterialTypeEnum ( "Animated Material", "away3d.materials.AnimatedBitmapMaterial" );
		
		public static const VIDEOMATERIAL : MaterialTypeEnum = new MaterialTypeEnum ( "Video Material", "away3d.materials.VideoMaterial" );
		
		public static const WIREFRAMEMATERIAL : MaterialTypeEnum = new MaterialTypeEnum( "Wireframe Material", "" );
		
		public static const NONE : MaterialTypeEnum = new MaterialTypeEnum ( "[Empty]" );
		
		public static const MISSING : MaterialTypeEnum = new MaterialTypeEnum ( "[Missing]" );
		
		public var value : String;
		
		public var classType : String;
		
		public function MaterialTypeEnum( value : String, classType : String = null )
		{
			this.value = value;
			this.classType = classType;
		}
		
		public static function get list() : Array
		{
			return [ BITMAPDATA_MATERIAL ];
		}
		
		public static function get comboList() : Array
		{
			var clist : Array = MaterialTypeEnum.list;
			//list.unshift ( NONE );
			return clist;
		}
		
		public static function selectByValue( value : String ) : MaterialTypeEnum
		{
			for each ( var materialType : MaterialTypeEnum in MaterialTypeEnum.list )
			{
				if ( value == materialType.value )
					return materialType;
			}
			
			return NONE;
		}
		
		public static function selectByClassType ( value : String ) : MaterialTypeEnum
		{
			for each ( var materialType : MaterialTypeEnum in MaterialTypeEnum.list )
			{
				if ( value == materialType.classType )
					return materialType;
			}
			
			return NONE;
		}
		
		public function equals( enum : MaterialTypeEnum ) : Boolean
		{
			return ( this.classType == enum.classType && this.value == enum.value );
		}
	}
}

