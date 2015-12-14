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
	import flash.events.Event;
	import flash.utils.Dictionary;

	import totem.display.MovieClipFPSThrottle;

	public class AnimatorMovieClip extends MovieClipFPSThrottle
	{

		protected var _currentAnimation : Object;

		protected var _count : int;

		private var animations : Dictionary;

		public function AnimatorMovieClip( mc : MovieClip, fps : int = 12, loop : int = 0 )
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

		public function playAnimation( name : String, loop : int = 0 ) : void
		{
			onPlayAniamtion( name, loop );
		}

		protected function onPlayAniamtion( name : String, loop : int = 0 ) : Boolean
		{

			if ( !hasAnimation( name ) || _currentAnimation == animations[ name ])
				return false;

			_count = 0;
			_loop = loop;
			gotoAndPlay( name );

			_currentAnimation = animations[ name ];
			
			return true;
		}

		override protected function onUpdateAnimation() : void
		{
			if ( currentFrame >= _currentAnimation.end )
			{
				_count += 1;

				if ( _loop == 0 ||  _count < _loop )
				{
					_movieClip.gotoAndStop( _currentAnimation.start );
				}
				else
				{
					stop();
					dispatchEvent( new Event( Event.COMPLETE ));
				}

			}
		}
	}
}
