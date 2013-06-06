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

package totem.display.controls
{

	import flash.text.TextField;

	
	
	
	
	
	import totem.events.RemovableEventDispatcher;
	import totem.time.TimeClock;
	import totem.utils.TimeCodeUtil;

	public class ClockTextField extends RemovableEventDispatcher
	{

		private var clock : TimeClock;

		private var isCountDown : Boolean;

		private var textField : TextField;

		private var totalTime : Number;

		public function ClockTextField( tf : TextField, time : Number, down : Boolean = true )
		{
			textField = tf;
			totalTime = time;

			clock = new TimeClock();

			isCountDown = down;

			clock.timeTickDispatcher.add( onTick );
		}

		override public function destroy() : void
		{
			super.destroy();

			clock.destroy();
			clock = null;

			textField = null;
		}

		public function start() : void
		{
			clock.start();
			onTick( clock.currentTime );
		}

		public function stop() : void
		{
			clock.stop();
		}

		private function onTick( time : Number ) : void
		{
			textField.text = TimeCodeUtil.formatTime(( isCountDown ) ? totalTime - time : time );

			if ( time >= ( totalTime - 1000 ) )
			{
				stop();
			}
		}
	}
}
