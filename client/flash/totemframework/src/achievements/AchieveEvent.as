//------------------------------------------------------------------------------
//
//     _______ __ __           
//    |   _   |  |  |--.-----. 
//    |___|   |  |  _  |__ --| 
//     _(__   |__|_____|_____| 
//    |:  1   |                
//    |::.. . |                
//    `-------'      
//                       
//   3lbs Copyright 2014 
//   For more information see http://www.3lbs.com 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package achievements
{

	import flash.events.Event;
	
	import totem.events.ObjectEvent;

	public class AchieveEvent extends ObjectEvent
	{
		public static const ACHIEVEMENT_COMPLETED : String = "AM:AchievementCompleted";

		public static const ACHIEVEMENT_VIEWED: String = "AM:AchievementViewed";
		
		public var achievement : Achievement;

		public function AchieveEvent( type : String, achieve : Achievement = null, bubbles : Boolean = false, cancelable : Boolean = false )
		{
			achievement = achieve;

			super( type, null, bubbles, cancelable );
		}

		override public function clone() : Event
		{
			return new AchieveEvent( type, achievement, bubbles, cancelable );
		}
	}
}
