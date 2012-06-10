package totem3d.enums
{
	
	public class AnimationCategoryTypeEnum
	{
		public static const NONE : AnimationCategoryTypeEnum = new AnimationCategoryTypeEnum ( "NONE" );
		
		public static const WALK : AnimationCategoryTypeEnum = new AnimationCategoryTypeEnum ( "walk" );
		
		public static const IDLE : AnimationCategoryTypeEnum = new AnimationCategoryTypeEnum ( "idle" );
		
		public static const RUN : AnimationCategoryTypeEnum = new AnimationCategoryTypeEnum ( "run" );
		
		public static const ATTACK : AnimationCategoryTypeEnum = new AnimationCategoryTypeEnum ( "attack" );
		
		public static const TURN : AnimationCategoryTypeEnum = new AnimationCategoryTypeEnum ( "turn" );
		
		public static var animationCategoryList : Array = list;
		
		public var name : String;
		
		
		public function AnimationCategoryTypeEnum( name : String )
		{
			this.name = name;
		}
		
		public static function addAnimationCategory( name : String ) : AnimationCategoryTypeEnum
		{
			var enum : AnimationCategoryTypeEnum = new AnimationCategoryTypeEnum ( name );
			
			animationCategoryList.push ( enum );
			
			return enum;
		}
		
		public function get label() : String
		{
			return name;
		}
		
		public static function get list() : Array
		{
			return [ NONE, WALK, IDLE, RUN, ATTACK, TURN ];
		}
		
		public static function get comboList() : Array
		{
			//var clist : Array = AnimationCategoryTypeEnum.list;
			//clist.unshift ( NONE );
			return null;
		}
		
		public static function get categoryList() : Array
		{
			return animationCategoryList;
		}
		
		public static function selectByName( value : String ) : AnimationCategoryTypeEnum
		{
			for each ( var categoryType : AnimationCategoryTypeEnum in AnimationCategoryTypeEnum.animationCategoryList )
			{
				if ( value == categoryType.name )
					return categoryType;
			}
			
			if ( value )
			{
				return AnimationCategoryTypeEnum.addAnimationCategory ( value );
			}
			
			return NONE;
		}
		
		public function equals( enum : AnimationCategoryTypeEnum ) : Boolean
		{
			return ( this.name == enum.name );
		}
	
	}
}

