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

package totem.input.draganddrop
{

	import flash.events.IEventDispatcher;
	
	import totem.events.RemovableEventDispatcher;
	import totem.input.dragDrop.IDragSource;

	public class DragManager extends RemovableEventDispatcher
	{
		private var isDragging : Boolean;

		public function DragManager( target : IEventDispatcher = null )
		{
			super( target );
		}

		public function startDrag( source : IDragSource ) : void
		{
			if ( isDragging )
			{
				cancelDrag();
			}

		}

		public function stopDrag() : void
		{

		}

		private function cancelDrag() : void
		{
			// TODO Auto Generated method stub

		}
	}
}
