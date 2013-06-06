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
	import com.greensock.plugins.TransformAroundCenterPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.display.DisplayObject;

	public class ScalePopupTransition extends BasePopUpTransition
	{
		public function ScalePopupTransition( displayObject : DisplayObject )
		{
			super( displayObject );
		}

		override public function animateIn() : void
		{
			TweenPlugin.activate([ TransformAroundCenterPlugin ]);
			TweenMax.from( popUp, .3, { transformAroundCenter: { scale: .8 }, ease: Back.easeOut });
		}

		/*override public function animateOut() : void
		{
			TweenMax.to( popUp, .2, { transformAroundCenter: { scale: .5 }, onComplete: complete });
		}*/
	}
}
