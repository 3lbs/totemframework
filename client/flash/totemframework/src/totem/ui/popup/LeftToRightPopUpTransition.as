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
	import com.greensock.easing.Back;
	
	import flash.display.DisplayObject;
	
	import ladydebug.Logger;

	public class LeftToRightPopUpTransition extends BasePopUpTransition
	{
		public function LeftToRightPopUpTransition( displayObject : DisplayObject )
		{
			super( displayObject );
			
			Logger.info( this, "LeftToRightPopUpTransition", " constructor" );
		}

		override public function animateIn() : void
		{
			TweenMax.from( popUp, .8, { alpha: .3, x: popUp.x - 150, ease: Back.easeOut, onComplete: complete });
		}

		override public function animateOut() : void
		{
			TweenMax.to( popUp, .8, { alpha: 0, x: popUp.x + 150, ease: Back.easeOut, onComplete: complete });
		}
	}
}
