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

package totem.components.display.starling
{

	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import starling.textures.Texture;

	import totem.core.time.TimeManager;
	import totem.display.starling.Animation;
	import totem.display.starling.AnimationMovieClip;

	public class MovieClipStarlingComponent extends DisplayStarlingComponent
	{

		public var dispatchAddToScene:ISignal=new Signal(MovieClipStarlingComponent);

		public function MovieClipStarlingComponent()
		{
			super();
		}

		public function addAnimation(animName:String, textures:Vector.<Texture>, fps:Number=12, loop:Boolean=true):Animation
		{
			return movieClip.addAnimation(animName, textures, fps, loop);
		}

		public function set movieClip(value:AnimationMovieClip):void
		{

			if (value == displayObject)
				return;

			if (displayObject)
				displayObject.dispose();

			displayObject=value;
		}

		public function get movieClip():AnimationMovieClip
		{
			return displayObject as AnimationMovieClip;
		}

		override protected function addToScene():void
		{
			super.addToScene();

			registerForTicks=true;

			dispatchAddToScene.dispatch(this);
		}

		override protected function removeFromScene():void
		{
			super.removeFromScene();
			registerForTicks=false;
		}

		override public function onTick():void
		{
			super.onTick();
			movieClip.advanceTime(TimeManager.TICK_RATE);
		}
	}
}
