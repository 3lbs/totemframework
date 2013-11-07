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

	import flash.display.DisplayObject;
	
	import totem.core.task.Task;

	public class RemoveDisplayObjectTask extends Task
	{
		private var displayObject : DisplayObject;

		public function RemoveDisplayObjectTask( d : DisplayObject = null )
		{
			super();
			displayObject = d;
		}
		
		public function setProperties ( d : DisplayObject ) : void
		{
			displayObject = d;	
		}

		override protected function doStart() : void
		{
			if ( displayObject && displayObject.parent )
			{
				displayObject.parent.removeChild( displayObject );
			}
			
			complete();
		}
	}
}
