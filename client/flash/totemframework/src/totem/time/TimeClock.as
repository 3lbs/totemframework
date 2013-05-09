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

/*
 * hexagonlib - Multi-Purpose ActionScript 3 Library.
 *       __    __
 *    __/  \__/  \__    __
 *   /  \__/HEXAGON \__/  \
 *   \__/  \__/  LIBRARY _/
 *            \__/  \__/
 *
 * Licensed under the MIT License
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 * the Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
package totem.time
{

	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import totem.core.Destroyable;

	/**
	 * A more precise timer class than the default ActionScript Timer class.
	 * You must set StageReference.stage before using this class!
	 */
	public class TimeClock extends Destroyable
	{

		public var timeCompleteDispatcher : ISignal;

		public var timeTickDispatcher : ISignal;

		private var _currentCount : int;

		//-----------------------------------------------------------------------------------------
		// Properties
		//-----------------------------------------------------------------------------------------

		private var _interval : Number;

		private var _isRunning : Boolean = false;

		private var _offset : int;

		private var _repeatCount : int;

		private var _stopWatch : Stopwatch;

		private var _updateTimer : UpdateTimer;

		/**
		 * Constructs a new PreciseTimer object with the specified delay and repeatCount states.
		 * The timer does not start automatically; you must call the start() method to start it.
		 *
		 * @param delay The delay between timer events, in milliseconds.
		 * @param repeatCount Specifies the number of repetitions. If zero, the timer repeats
		 *         infinitely. If nonzero, the timer runs the specified number of times and then
		 *         stops.
		 */
		public function TimeClock( interval : Number = 1000, repeatCount : int = 0 )
		{
			this.interval = interval;
			this.repeatCount = repeatCount;

			timeCompleteDispatcher = new Signal( int );
			timeTickDispatcher = new Signal( int );

			_updateTimer = new UpdateTimer( interval );
			_updateTimer.updateSignal.add( onTick );

			_stopWatch = new Stopwatch();

			reset();
		}

		/**
		 * The total number of times the timer has fired since it started at zero.
		 * If the timer has been reset, only the fires since the reset are counted.
		 */
		public function get currentCount() : int
		{
			return _currentCount;
		}

		/**
		 * The timer's current state; true if the timer is running, otherwise false.
		 */

		public function get currentTime() : Number
		{
			return _stopWatch.time;
		}

		override public function destroy() : void
		{
			super.destroy();

			stop();

			_updateTimer.destroy();
			_updateTimer = null;

			_stopWatch = null;

			timeCompleteDispatcher.removeAll();
			timeCompleteDispatcher = null;

			timeTickDispatcher.removeAll();
			timeTickDispatcher = null;

		}

		//-----------------------------------------------------------------------------------------
		// Accessors
		//-----------------------------------------------------------------------------------------

		/**
		 * The delay, in milliseconds, between timer events. If you set the delay
		 * interval while the timer is running, the timer will restart at the same
		 * repeatCount iteration.
		 *
		 * @throws com.hexagonstar.env.exception.IllegalArgumentException if the
		 *          delay specified is negative or not a finite number.
		 */
		public function get interval() : Number
		{
			return _interval;
		}

		public function set interval( v : Number ) : void
		{
			if ( v < 0 || v == Number.POSITIVE_INFINITY )
			{
				return;
			}
			_interval = v;
		}

		public function get isRunning() : Boolean
		{
			return _isRunning;
		}

		/**
		 * The total number of times the timer is set to run. If the repeat count is
		 * set to 0, the timer continues forever or until the stop() method is invoked
		 * or the program stops. If the repeat count is nonzero, the timer runs the
		 * specified number of times. If repeatCount is set to a total that is the same
		 * or less then currentCount  the timer stops and will not fire again.
		 */
		public function get repeatCount() : int
		{
			return _repeatCount;
		}

		public function set repeatCount( v : int ) : void
		{
			_repeatCount = v;
		}

		/**
		 * Stops the timer, if it is running, and sets the currentCount property back
		 * to 0, like the reset button of a stopwatch. Then, when start() is called,
		 * the timer instance runs for the specified number of repetitions, as set by
		 * the repeatCount value.
		 */
		public function reset() : void
		{
			stop();
			_currentCount = _offset = 0;
		}

		//-----------------------------------------------------------------------------------------
		// Public Methods
		//-----------------------------------------------------------------------------------------

		/**
		 * Starts the timer, if it is not already running.
		 */
		public function start() : void
		{
			if ( _isRunning )
				return;
			_isRunning = true;

			_updateTimer.start();
			_stopWatch.start();

		}

		/**
		 * Stops the timer. When start() is called after stop(), the timer instance runs
		 * for the remaining number of repetitions, as set by the repeatCount property.
		 */
		public function stop() : void
		{
			if ( !_isRunning )
				return;
			_isRunning = false;

			_updateTimer.stop();
			_stopWatch.stop();

		}

		/**
		 * Returns a String Representation of PreciseTimer.
		 *
		 * @return A String Representation of PreciseTimer.
		 */
		public function toString() : String
		{
			return "[PreciseTimer, currentCount=" + _currentCount + "]";
		}

		//-----------------------------------------------------------------------------------------
		// Event Handlers
		//-----------------------------------------------------------------------------------------

		private function onTick() : void
		{

			_currentCount++;

			if ( _repeatCount != 0 )
			{
				if ( _currentCount == _repeatCount )
				{
					timeCompleteDispatcher.dispatch( _stopWatch.time );
					timeTickDispatcher.dispatch( _stopWatch.time );
					stop();
				}
				else if ( _currentCount < _repeatCount )
				{
					timeTickDispatcher.dispatch( _stopWatch.time );
				}
			}
			else
			{
				timeTickDispatcher.dispatch( _stopWatch.time );
			}
		}
	}
}
