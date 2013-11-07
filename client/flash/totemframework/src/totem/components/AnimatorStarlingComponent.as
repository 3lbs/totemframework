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

package totem.components
{

	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import starling.display.DisplayObjectContainer;
	import starling.textures.Texture;

	import totem.core.time.TickedComponent;
	import totem.display.starling.Animation;
	import totem.display.starling.AnimationMovieClip;

	public class AnimatorStarlingComponent extends TickedComponent
	{

		public var dispatchAddToScene : ISignal = new Signal( AnimatorStarlingComponent );

		private var _movieClip : AnimationMovieClip = new AnimationMovieClip();

		private var _scene : DisplayObjectContainer;

		public function AnimatorStarlingComponent()
		{
			super();
		}

		public function addAnimation( animName : String, textures : Vector.<Texture>, fps : Number = 12, loop : Boolean = true ) : Animation
		{
			return _movieClip.addAnimation( animName, textures, fps, loop );
		}

		public function addMovieClip( value : AnimationMovieClip ) : void
		{
			if ( _movieClip.isPlaying )
				_movieClip = value;
		}

		public function addToScene( scene : DisplayObjectContainer ) : void
		{

			_movieClip.x = 100;
			_movieClip.y = 200;

			_movieClip.play( "ants_wave" );

			scene.addChild( _movieClip );
			_scene = scene;

			registerForTicks = true;
			
			dispatchAddToScene.dispatch( this );
		}

		override public function onTick() : void
		{
			super.onTick();
			_movieClip.advanceTime( 1/60 );
		}
	}
}
