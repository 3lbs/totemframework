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

package totem.core.input
{

	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import totem.core.Destroyable;
	import totem.math.MathUtils;
	import totem.math.Vector2D;

	public class NativeMouseSwipeMonitor extends Destroyable
	{

		public static const ALL : int = 2;

		public static const LEFT_RIGHT : int = 1;

		public static const UP_DOWN : int = 0;

		public var clickDispatch : ISignal = new Signal( Number, Number );

		public var moveDispatch : ISignal = new Signal( Number, Number );

		public var swipeDispatch : ISignal = new Signal( Number, Number );

		private var DOWN : Vector2D = new Vector2D( 0, -1 ); //South

		private var LEFT : Vector2D = new Vector2D( -1, 0 ); //West

		private var RIGHT : Vector2D = new Vector2D( 1, 0 ); //East

		private var UP : Vector2D = new Vector2D( 0, 1 ); //North

		private var _container : InteractiveObject;

		private var _deviationFromMains : Number = MathUtils.radianOf( 45 );

		private var _direction : Vector.<Vector2D>;

		private var _first : Vector2D = new Vector2D();

		private var _last : Vector2D = new Vector2D();

		private var _magnitude : int = 20;

		private var _moveEnabled : Boolean = false;

		private var _prevVector : Vector2D = new Vector2D();

		private var _priority : int = 0;

		private var _result : Vector2D = new Vector2D();

		private var _state : int = ALL;

		private var all_directions : Vector.<Vector2D> = new <Vector2D>[ UP, RIGHT, DOWN, LEFT ];

		private var leftright_directions : Vector.<Vector2D> = new <Vector2D>[ RIGHT, LEFT ];

		private var updown_directions : Vector.<Vector2D> = new <Vector2D>[ UP, DOWN ];

		public function NativeMouseSwipeMonitor( container : InteractiveObject, s : int = LEFT_RIGHT )
		{
			super();

			setState( s );
			_container = container;
		}

		override public function destroy() : void
		{
			removeListeners();

			_container = null;

			all_directions.length = 0;
			all_directions = null;

			leftright_directions.length = 0;
			leftright_directions = null;

			updown_directions.length = 0;
			updown_directions = null;

			_direction = null;

			clickDispatch.removeAll();
			clickDispatch = null

			swipeDispatch.removeAll();
			swipeDispatch = null;

		}

		public function get magnitude() : int
		{
			return _magnitude;
		}

		public function set magnitude( value : int ) : void
		{
			_magnitude = value;
		}

		public function get moveEnabled() : Boolean
		{
			return _moveEnabled;
		}

		public function set moveEnabled( value : Boolean ) : void
		{
			_moveEnabled = value;
		}

		public function get priority() : int
		{
			return _priority;
		}

		public function set priority( value : int ) : void
		{
			_priority = value;
		}

		public function setState( s : int ) : void
		{
			_state = s;

			if ( _state == ALL )
			{
				_direction = all_directions;

				_deviationFromMains = 45 / 180 * Math.PI;
			}
			else
			{
				_deviationFromMains = 70 / 180 * Math.PI;

				_direction = ( _state == UP_DOWN ) ? updown_directions : leftright_directions;
			}
		}

		public function start() : void
		{
			_container.addEventListener( MouseEvent.MOUSE_DOWN, handleMouseDown, false, priority, true );
		}

		protected function calculateDirection( _result : Vector2D ) : Vector2D
		{

			var l : int = _direction.length;
			var angle : Number;
			var vector : Vector2D;

			while ( l-- )
			{
				angle = _direction[ l ].angleBetween( _result );
				angle = Math.abs( angle );

				if ( angle < _deviationFromMains )
				{
					vector = _direction[ l ];

					return vector;
				}
			}

			return null;

		}

		protected function handleMouseDown( event : MouseEvent ) : void
		{

			_first.x = event.localX;

			_prevVector.copy( _first );

			_container.addEventListener( MouseEvent.MOUSE_UP, handleMouseUp, false, priority, true );
			_container.addEventListener( MouseEvent.MOUSE_OUT, handleMouseUp, false, priority, true );

			if ( _moveEnabled )
			{
				_container.addEventListener( MouseEvent.MOUSE_MOVE, handleMouseMove );
			}
		}

		protected function handleMouseMove( event : MouseEvent ) : void
		{
			_last.setTo( event.localX, event.localY );

			_result.copy( _last );

			_result.subtract( _prevVector );

			var dir : Vector2D;

			if (( dir = calculateDirection( _result )) != null )
			{
				moveDispatch.dispatch( dir.x, dir.y );

				_prevVector.copy( _last );
			}

		}

		protected function handleMouseUp( event : MouseEvent ) : void
		{

			_last.setTo( event.localX, event.localY );

			_result.copy( _last );

			_result.subtract( _first );

			if ( _result.length > _magnitude )
			{
				var dir : Vector2D;

				if (( dir = calculateDirection( _result )) != null )
				{
					swipeDispatch.dispatch( dir.x, dir.y );
				}
			}
			else
			{
				clickDispatch.dispatch( event.localX, event.localY );
			}

			removeListeners();
		}

		private function angleBetween( point0 : Point, point1 : Point ) : Number
		{
			//get normalised vectors
			var norm1 : Point = point0.clone();
			norm1.normalize( 1 );

			var norm2 : Point = point1.clone();
			norm2.normalize( 1 );

			//dot product of vectors to find angle
			var product : Number = ( norm1.x * norm2.x ) + ( norm1.y * norm2.y );
			product = Math.min( 1, product );

			var angle : Number = Math.acos( product );

			//slides of vector
			if (( point0.x * point1.y - point0.y * point1.x ) < 0 )
				angle *= -1;

			return angle;
		}

		private function removeListeners() : void
		{

			_container.removeEventListener( MouseEvent.MOUSE_UP, handleMouseUp );
			_container.removeEventListener( MouseEvent.MOUSE_OUT, handleMouseUp );

			if ( _moveEnabled )
				_container.removeEventListener( MouseEvent.MOUSE_MOVE, handleMouseMove );
		}
	}
}
