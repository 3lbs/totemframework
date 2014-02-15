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

package AI.steering
{

	import AI.steering.motion.IMotion;

	import flash.utils.Dictionary;

	import totem.components.motion.ISteeringObject;
	import totem.core.Destroyable;
	import totem.core.time.TimeManager;
	import totem.math.Vector2D;

	public class TweenSteeringBehavior extends Destroyable
	{

		private var _distance : Number;

		private var _duration : Number;

		private var _motion : IMotion;

		private var _motionMap : Dictionary = new Dictionary();

		private var _startPosition : Vector2D = new Vector2D();

		private var _targetPoint : Vector2D;

		private var _timeElapsed : Number;

		private var steeringComponent : ISteeringObject;

		public function TweenSteeringBehavior( component : ISteeringObject )
		{
			steeringComponent = component;
		}

		//Vec2DDistance(Pos(), pos) / (MaxSpeed() * FrameRate);

		/*
		var result:Number =  EasingUtil.call(easingFunction, timeElapsed, _duration, _easingMod1, _easingMod2);

		target[property] = result * (endValue - startValue) + startValue;
		*/

		override public function destroy() : void
		{
			super.destroy();

		}

		public function isComplete() : Boolean
		{
			return _targetPoint == null;
		}

		public function moveTo( vector : Vector2D, easeType : Class ) : void
		{

			if ( !_motionMap[ easeType ])
			{
				_motion = new easeType();
				_motionMap[ easeType ] = _motion;
			}

			_motion = _motionMap[ easeType ];

			_targetPoint = vector;

			 _startPosition.copy( steeringComponent.position );

			_distance = _startPosition.distanceTo( _targetPoint );

			_duration = ( _distance / 24 ); // * ( TimeManager.TICK_RATE );

			_timeElapsed = 0.0;

		}

		public function update() : Boolean
		{
			if ( _targetPoint )
			{
				var position : Vector2D = steeringComponent.position;

				_timeElapsed += TimeManager.TICK_RATE;

				var _result : Number = _motion.ease( _timeElapsed, _duration );

				steeringComponent.x = _result * ( _targetPoint.x - _startPosition.x ) + _startPosition.x;
				steeringComponent.y = _result * ( _targetPoint.y - _startPosition.y ) + _startPosition.y;

				//_car.x = _result * ( _endPoint.x - _startPosition.x ) + _startPosition.x;
				//_car.y = _result * ( _endPoint.y - _startPosition.y ) + _startPosition.y;
				
				
				/*steeringComponent.x = ( _targetPoint.x - position.x ) * .01;
				steeringComponent.y = ( _targetPoint.y - position.y ) * .01;*/

				if ( _timeElapsed >= _duration )
				{
					steeringComponent.x = _targetPoint.x;
					steeringComponent.y = _targetPoint.y;
					_targetPoint = null;
				}
				return true;
			}
			return false;
		}

		private function onComplete() : void
		{
			_targetPoint = null;

		}
	}
}

