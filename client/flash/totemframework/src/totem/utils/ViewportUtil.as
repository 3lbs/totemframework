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

package totem.utils
{
	import flash.display.Stage;
	import flash.geom.Rectangle;
	
	import org.casalib.util.StageReference;

	public class ViewportUtil
	{
		
		private static var _STAGE : Stage;
		
		private static var _viewRect : Rectangle;
		
		public function ViewportUtil()
		{
		}
		
		public static function viewRect() : Rectangle
		{
			if ( !_STAGE )
				_STAGE = StageReference.getStage();
			
			return _viewRect; //||= ( isIOS() || isAndroid() ? new Rectangle( 0, 0, _STAGE.fullScreenWidth, _STAGE.fullScreenHeight ) : new Rectangle( 0, 0, _STAGE.stageWidth, _STAGE.stageHeight ));
		}
		
		public static function getViewWidth () : Number
		{
			return viewRect().width;
		}
		
		public static function getViewHeight () : Number
		{
			return viewRect().height;
		}
	}
}
