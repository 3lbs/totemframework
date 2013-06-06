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

	import com.greensock.TweenMax;

	import flash.display.DisplayObject;

	public class BasicFadePopUpTransition extends BasePopUpTransition
	{
		public function BasicFadePopUpTransition( displayObject : DisplayObject )
		{
			super( displayObject );
		}

		override public function animateIn() : void
		{
			TweenMax.from( popUp, .3, { alpha: 0 });
		}

		override public function animateOut() : void
		{
			TweenMax.to( popUp, .3, { alpha: 0, onComplete: complete });
		}
	}
}
