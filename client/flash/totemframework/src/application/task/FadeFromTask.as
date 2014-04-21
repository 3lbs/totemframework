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

package application.task
{

	import com.greensock.TweenMax;
	
	import flash.display.DisplayObjectContainer;
	
	import totem.core.task.Task;

	public class FadeFromTask extends Task
	{
		private var color : int;

		private var displayObject : DisplayObjectContainer;

		private var time : Number;

		public function FadeFromTask( d : DisplayObjectContainer = null, c : int = 0, t : Number = 0 )
		{
			super();

			time = t;
			color = c;
			displayObject = d;
		}

		override public function destroy() : void
		{
			super.destroy();

			displayObject = null;
		}

		override protected function complete() : Boolean
		{
			return super.complete();
		}
		
		public function reset () : void
		{
			displayObject = null;
		}
		
		public function setProperties( d : DisplayObjectContainer, c : int, t : Number ) : void
		{
			time = t;
			color = c;
			displayObject = d;
		}

		override protected function doStart() : void
		{
			
			if ( displayObject )
			{
				displayObject.visible = true;
				TweenMax.from( displayObject, time, { tint: color, onComplete: complete });
			}
			else
			{
				complete();
			}
		}
	}
}
