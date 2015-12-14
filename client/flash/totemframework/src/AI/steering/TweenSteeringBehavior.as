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
	import AI.steering.motion.MLinear;

	import flash.utils.Dictionary;

	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import totem.components.motion.ISteeringObject;
	import totem.core.Destroyable;
	import totem.core.time.TimeManager;
	import totem.math.Vector2D;

	/**
	 *
	 * @author eddie
	 *
	 */
	public class TweenSteeringBehavior extends Destroyable implements ISteering
	{

		private static const PI2 : Number = ( 180 / Math.PI );

		public var dispatchComplete : ISignal = new Signal();

		protected var _distance : Number;

		protected var _duration : Number;

		protected var _targetPoint : Vector2D;

		// degrees
		protected var angle : Number = 0;

		protected var steeringComponent : ISteeringObject;

		private var _motion : IMotion;

		private var _motionMap : Dictionary = new Dictionary();

		private var _pointAngle : Boolean;

		private var _startPosition : Vector2D = new Vector2D();

		private var _timeElapsed : Number;

		private var defalutEaseType : Class = MLinear;

		public function TweenSteeringBehavior( component : ISteeringObject )
		{
			steeringComponent = component;
		}

		override public function destroy() : void
		{
			_motion = null;

			_motionMap = null;

			if ( _startPosition )
			{
				_startPosition.dispose();
				_startPosition = null;
			}

			steeringComponent = null;

			dispatchComplete.removeAll();
			dispatchComplete = null;

			_targetPoint = null;

			super.destroy();
		}

		public function get direction() : Number
		{
			return angle;
		}

		public function isComplete() : Boolean
		{
			return _targetPoint == null;
		}

		public function moveTo( vector : Vector2D, easeType : Class = null ) : Number
		{

			easeType ||= defalutEaseType;

			if ( !_motionMap[ easeType ])
			{
				_motion = new easeType();
				_motionMap[ easeType ] = _motion;
			}

			_motion = _motionMap[ easeType ];

			_targetPoint = vector;

			_startPosition.copy( steeringComponent.position );

			_distance = _startPosition.distanceTo( _targetPoint );

			_duration = ( _distance / steeringComponent.velocity ); // * ( TimeManager.TICK_RATE );

			_timeElapsed = 0.0;

			angle = _targetPoint.angleTo( _startPosition ) * PI2;

			steeringComponent.rotation = 0;

			if ( _pointAngle )
			{
				var rot : int = angle;

				if ( angle > 90 )
					rot -= 180;
				else if ( angle < -90 )
					rot += 180;

				steeringComponent.rotation = rot;
			}

			return angle;
		}

		public function set pointDirection( value : Boolean ) : void
		{
			_pointAngle = value;
		}

		public function stop() : void
		{
			_targetPoint = null;

			_motion = null;
		}

		public function update() : Boolean
		{
			if ( _targetPoint )
			{
				//var position : Vector2D = steeringComponent.position;

				_timeElapsed += TimeManager.TICK_RATE;

				var _result : Number = _motion.ease( _timeElapsed, _duration );

				steeringComponent.x = _result * ( _targetPoint.x - _startPosition.x ) + _startPosition.x;
				steeringComponent.y = _result * ( _targetPoint.y - _startPosition.y ) + _startPosition.y;

				if ( _timeElapsed >= _duration )
				{
					steeringComponent.x = _targetPoint.x;
					steeringComponent.y = _targetPoint.y;
					_targetPoint = null;

					dispatchComplete.dispatch();
				}

				return true;
			}
			return false;
		}
	}
}

