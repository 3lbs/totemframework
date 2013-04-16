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
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package totem.components.commands
{

	import totem.components.spatial.SpatialComponent;
	import totem.core.TotemComponent;

	public class UpdateDisplayComponentCommand
	{

		[Inject]
		public var displayComponent : TotemComponent;

		[Inject]
		public var spatialComponent : SpatialComponent;

		public function UpdateDisplayComponentCommand()
		{
			super();

			spatialComponent.positionChange.add( setPosition );
			spatialComponent.rotationChange.add( setRotation );
		}

		private function setPosition( x : Number, y : Number, z : Number ) : void
		{
			// TODO Auto Generated method stub

		}

		private function setRotation( x : Number, y : Number, z : Number ) : void
		{

		}
	}
}
