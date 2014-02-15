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

package totem.components.motion
{

	import AI.steering.TweenSteeringBehavior;

	import totem.components.spatial.SpatialComponent;

	public class TweenComponent extends SpatialComponent implements ISteeringObject
	{

		public static const NAME : String = "TweenComponent";

		private var _steering : TweenSteeringBehavior;

		public function TweenComponent( data : MovingParam )
		{
			super( NAME, data );

			_steering = new TweenSteeringBehavior( this );
		}

		override public function destroy() : void
		{
			_steering.destroy();
			_steering = null;
			super.destroy();
		}

		override public function onTick() : void
		{
			if ( _steering.update())
			{
				dirtyPosition = true;
				dispatchUpdate();
			}
		}

		public function get steering() : TweenSteeringBehavior
		{
			return _steering;
		}
	}
}
