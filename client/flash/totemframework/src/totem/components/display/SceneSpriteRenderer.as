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

package totem.components.display
{

	import starling.display.DisplayObject;

	import totem.display.layout.starling.TStarlingSprite;

	public class SceneSpriteRenderer extends TStarlingSprite implements ISceneRenderer
	{

		private var _zIndex : int;

		public function SceneSpriteRenderer()
		{
		}

		public function get displayObject() : DisplayObject
		{
			return this;
		}

		public function get zIndex() : int
		{
			return _zIndex;
		}

		public function set zIndex( value : int ) : void
		{
			_zIndex = value;
		}
	}
}
