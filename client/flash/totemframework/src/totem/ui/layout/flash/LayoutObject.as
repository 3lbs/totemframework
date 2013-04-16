package totem.ui.layout.flash
{
	public class LayoutObject
	{
		
		public var depth : Number = 1;
		
		public var x : Number = 0;
		
		public var y : Number = 0;
		
		public var scaleX : Number = 1;
		
		public var scaleY : Number = 1;
		
		public var name : String;
		
		public var textureName : String = "";
		
		public var type : String = "";
		
		public var children : Vector.<LayoutObject>;
		
		public var width : Number = 1;
		
		public var height : Number = 1;
		
		
		// font specific properties
		
		public var typeFace : String;
		
		public var fontSize : Number;
		
		public var fillColor : String;
		
		public var bold : Boolean;
		
		public var text : String;
		
		public var textType : String;

		public function LayoutObject()
		{
		}
	}
}