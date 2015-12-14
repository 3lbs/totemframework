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

package totem.ui.popup
{

	import flash.display.DisplayObject;
	
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	import totem.core.Destroyable;

	public class BasePopUpTransition extends Destroyable
	{
		public var channel : int;

		public var completeTransition : ISignal = new Signal( BasePopUpTransition );

		public var popUp : DisplayObject;

		public function BasePopUpTransition( displayObject : DisplayObject )
		{
			popUp = displayObject;
		}

		public function animateIn() : void
		{
			complete();
		}

		public function animateOut() : void
		{
			complete();
		}

		public function clone() : BasePopUpTransition
		{
			return new BasePopUpTransition( popUp );
		}

		override public function destroy() : void
		{
			super.destroy();

			completeTransition.removeAll();
			completeTransition = null;

			popUp = null;
		}

		protected function complete() : void
		{
			
			//if ( completeTransition )
				completeTransition.dispatch( this );
			//popUp = null;
		}
	}
}
