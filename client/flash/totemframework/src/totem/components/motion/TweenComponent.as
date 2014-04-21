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

	import AI.steering.ISteering;
	import AI.steering.TweenSteeringBehavior;

	import totem.components.spatial.SpatialComponent;

	public class TweenComponent extends SpatialComponent implements ISteeringObject
	{

		public static const NAME : String = "TweenComponent";

		private var _previousSteering : ISteering;

		private var _steering : ISteering;

		private var _velocity : Number;

		public function TweenComponent( data : MovingParam )
		{
			super( NAME, data );

			_velocity = data.velocity;

			_steering = new TweenSteeringBehavior( this );
		}

		override public function destroy() : void
		{
			_steering.destroy();
			_steering = null;
			super.destroy();
		}

		public function goToPreviousBehavior() : Boolean
		{
			if ( _previousSteering )
			{

				_steering.stop();

				_steering = null;
				_steering = _previousSteering;

				return true;
			}

			return false;
		}

		override public function onTick() : void
		{
			if ( _steering.update())
			{
				dirtyPosition = true;
			}
			dispatchUpdate();
		}

		public function setBehavior( behavior : ISteering ) : ISteering
		{
			if ( _steering )
			{
				_steering.stop();
				_previousSteering = _steering;
			}

			_steering = behavior;

			return _steering;
		}

		public function get steering() : ISteering
		{
			return _steering;
		}

		public function get velocity() : Number
		{
			return _velocity;
		}

		public function set velocity( value : Number ) : void
		{
			_velocity = value;
		}
	}
}
