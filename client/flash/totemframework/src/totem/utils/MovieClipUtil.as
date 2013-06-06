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

	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;

	public class MovieClipUtil
	{

		public static function playAllAnimation( target : DisplayObjectContainer ) : void
		{
			if ( target is MovieClip )
				MovieClip( target ).play();

			var n : int = target.numChildren;
			var i : int;

			for ( i = 0; i < n; ++i )
			{
				var child : DisplayObjectContainer = target.getChildAt( i ) as DisplayObjectContainer;

				if ( child )
					playAllAnimation( child );
			}
		}

		public static function stopAllAnimation( target : DisplayObjectContainer ) : void
		{
			if ( target is MovieClip )
				MovieClip( target ).stop();

			var n : int = target.numChildren;
			var i : int;

			for ( i = 0; i < n; ++i )
			{
				var child : DisplayObjectContainer = target.getChildAt( i ) as DisplayObjectContainer;

				if ( child )
					stopAllAnimation( child );
			}
		}

		public static function stopAllAnimationOnFrame( target : DisplayObjectContainer, frame : Object = 1 ) : void
		{
			if ( target is MovieClip )
				MovieClip( target ).gotoAndStop( frame );

			var n : int = target.numChildren;
			var i : int;

			for ( i = 0; i < n; ++i )
			{
				var child : DisplayObjectContainer = target.getChildAt( i ) as DisplayObjectContainer;

				if ( child )
					stopAllAnimationOnFrame( child, frame );
			}
		}
	}
}
