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

package totem.animation
{

	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	
	import totem.display.MovieClipFPSThrottle;

	public class AnimatorMovieClip extends MovieClipFPSThrottle
	{

		protected var _currentAnimation : Object;

		private var animations : Dictionary;

		public function AnimatorMovieClip( mc : MovieClip, fps : int = 12, loop : Boolean = false )
		{
			super( mc, fps, loop );

			animations = new Dictionary();

			createAnimationFromLabels();
		}

		public function createAnimationFromLabels() : void
		{

			var labels : Array = _movieClip.currentLabels;
			var label : FrameLabel;
			var l : int = labels.length;
			var animation : Object;

			for ( var i : uint = 0; i < l; i++ )
			{
				label = labels[ i ];
				animation = new Object();
				animation.start = label.frame;

				if ( i < l - 1 )
				{
					animation.end = labels[ i + 1 ].frame - 1;
				}
				else
				{
					animation.end = _movieClip.totalFrames;
				}

				animations[ label.name ] = animation;
			}
		}

		public function get currentAnimation() : Object
		{
			return _currentAnimation;
		}

		override public function destroy() : void
		{

			animations = null;

			super.destroy();
		}

		public function getAnimations( value : String ) : Object
		{
			return animations[ value ];
		}

		public function hasAnimation( name : String ) : Boolean
		{
			return ( name in animations );
		}

		public function playAnimation( name : String, loop : Boolean = false ) : void
		{
			onPlayAniamtion( name, loop );
		}

		protected function onPlayAniamtion( name : String, loop : Boolean = false ) : void
		{

			if ( !hasAnimation( name )  || _currentAnimation == animations[ name ] )
				return;

			_loop = loop;
			gotoAndPlay( name );

			_currentAnimation = animations[ name ];
		}

		override protected function onUpdateAnimation() : void
		{
			if ( currentFrame >= _currentAnimation.end )
			{
				if ( _loop )
				{
					_movieClip.gotoAndStop( _currentAnimation.start );
				}
				else
				{
					stop();
				}
			}
		}
	}
}
