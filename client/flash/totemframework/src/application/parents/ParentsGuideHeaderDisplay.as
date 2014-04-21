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
//   3lbs Copyright 2014 
//   For more information see http://www.3lbs.com 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package application.parents
{

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import localization.localize;
	
	import threepounds.assets.parentguide.ExitButton;
	import threepounds.assets.parentguide.ParentGuideHeader;
	
	import totem.display.components.MovieClipButton;
	import totem.display.layout.TSprite;
	import totem.ui.layout.ElementUI;
	import totem.ui.layout.layouts.CanvasUI;
	import totem.utils.Alignment;
	import totem.utils.DisplayObjectUtil;
	import totem.utils.MobileUtil;

	public class ParentsGuideHeaderDisplay extends TSprite
	{

		private var canvas : CanvasUI;

		private var exitButton : MovieClipButton;

		public function ParentsGuideHeaderDisplay()
		{
			super();

			initialize();

			cacheAsBitmap = true;
		}

		override public function destroy() : void
		{
			super.destroy();

			exitButton.destroy();
			
			
			exitButton = null;

			canvas.dispose();
			canvas = null;
		}

		protected function handleExitParentGuide( event : Event ) : void
		{
			dispatchEvent( new Event( Event.CLOSE ));
		}

		private function initialize() : void
		{
			var header : ParentGuideHeader = new ParentGuideHeader();

			DisplayObjectUtil.fitIntoRect( header, MobileUtil.viewRect(), false, Alignment.TOP_LEFT );

			canvas = new CanvasUI( this, MobileUtil.getViewWidth(), header.height );

			var label : TextField = header.guideLabel;
			label.htmlText = localize( "AppGame", "parentguide.header.HEADER_TEXT" );

			header.x = 0;
			header.y = 0;

			var headerUI : ElementUI = canvas.add( header );
			headerUI.alignX = ElementUI.ALIGN_LEFT;
			headerUI.alignY = ElementUI.ALIGN_TOP;
			headerUI.left = 0;
			headerUI.top = 0;

			var backButton : ExitButton = new ExitButton();

			backButton.scaleX = backButton.scaleY = header.scaleX;

			exitButton = new MovieClipButton( backButton );
			exitButton.addEventListener( MouseEvent.CLICK, handleExitParentGuide );

			backButton.y = 10;
			backButton.x = MobileUtil.getViewWidth() - backButton.width - 10;

			addChild( backButton );

			var exitUI : ElementUI = canvas.add( backButton );
			exitUI.alignX = ElementUI.ALIGN_RIGHT;
			exitUI.alignY = ElementUI.ALIGN_CENTER;
			exitUI.right = 20;
			exitUI.top = 10;

			addChild( canvas );
			canvas.refresh();
		}
	}
}
