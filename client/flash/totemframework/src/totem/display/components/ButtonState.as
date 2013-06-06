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
//   3lbs Copyright 2013 
//   For more information see http://www.3lbs.com 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package totem.display.components
{
	import totem.core.Destroyable;

	public class ButtonState extends Destroyable
	{

		public var DOWN_STATE_FRAME : int = 3;

		public var OVER_STATE_FRAME : int = 2;

		public var UP_STATE_FRAME : int = 1;

		public var data : Object;

		public var name : String;

		public function ButtonState( name : String = "", frame : int = 1 )
		{
			this.name = name;
			firstFrame( frame );
			super();
		}

		public function firstFrame( frame : int ) : void
		{
			UP_STATE_FRAME = frame;
			OVER_STATE_FRAME = UP_STATE_FRAME + 1;
			DOWN_STATE_FRAME = OVER_STATE_FRAME + 1;
		}
		
		override public function destroy():void
		{
			super.destroy();
			data = null;
		}
	}
}
