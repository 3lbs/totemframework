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
	import flash.display.DisplayObjectContainer;

	import totem.core.task.Task;

	public class AddDisplayObjectTask extends Task
	{

		private var displayObject : DisplayObject;

		private var displayParent : DisplayObjectContainer;

		public function AddDisplayObjectTask( p : DisplayObjectContainer, d : DisplayObject = null )
		{
			super();
			displayObject = d;
			displayParent = p;
		}

		public function setProperties( d : DisplayObject ) : void
		{
			displayObject = d;
		}

		override protected function doStart() : void
		{
			if ( displayObject && displayParent )
			{
				displayParent.addChild( displayObject );
			}
			
			complete();
		}
	}
}
