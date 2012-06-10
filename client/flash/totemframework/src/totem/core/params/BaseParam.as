package totem.core.params
{
	
	public class BaseParam
	{
		private var _id : String;
		
		private var _type : String;
		
		private var _name : String;
		
		public function BaseParam()
		{
		}
		
		public function get id() : String
		{
			return _id;
		}
		
		public function set id( value : String ) : void
		{
			_id = value;
		}
		
		public function set type( value : String ) : void
		{
			_type = value;
		}
		
		public function get type() : String
		{
			return _type;
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function set name(value:String):void
		{
			_name = value;
		}
	
	
	}
}

