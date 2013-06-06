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

	public class DropDownPopUpTransition extends BasePopUpTransition
	{
		public function DropDownPopUpTransition( displayObject : DisplayObject )
		{
			super( displayObject );
		}
		
		override public function animateIn() : void
		{
			TweenMax.from( popUp, .5, { alpha : .3, y : popUp.y - 150, ease:Back.easeOut } );
		}
		
		override public function animateOut() : void
		{
			TweenMax.to( popUp, .3, { alpha: 0, onComplete: complete });
		}
	}
}
