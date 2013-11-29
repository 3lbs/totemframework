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
 Copyright (c) 2006 - 2010  Eric J. Feminella  <eric@ericfeminella.com>
 All rights reserved.

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.

 @internal
 */

package com.ericfeminella.support.signals.binding
{

	import org.osflash.signals.ISignal;

	/**
	 *
	 * <code>SignalBinding</code> provides a value object implementation
	 * which represents and encapsulates a <code>SignalBinding</code>
	 * resistered via <code>SignalDataBinding.addBindableListener</code>.
	 *
	 */
	public class SignalBinding
	{

		/**
		 *
		 * @private
		 *
		 */
		private var _listener : Function = null;

		/**
		 *
		 * @private
		 *
		 */
		private var _signal : ISignal = null;

		/**
		 *
		 * <code>SignalBinding</code> constructor requires the <code>Signal</code>
		 * and <code>listener</code> associated with this particular binding.
		 *
		 * @param The <code>Signal</code> associated with this binding.
		 * @param The listener associated with the specified <code>Signal</code>
		 *
		 */
		public function SignalBinding( signal : ISignal, listener : Function )
		{
			_signal = signal;
			_listener = listener;
		}

		/**
		 *
		 * Retrieves the <code>Function</code> reference associated with
		 * this object.
		 *
		 * @return <code>Function</code> instance
		 *
		 */
		public function get listener() : Function
		{
			return _listener;
		}

		/**
		 *
		 * Retrieves the <code>ISignal</code> instance associated with
		 * this object.
		 *
		 * @return <code>ISignal</code> instance
		 *
		 */
		public function get signal() : ISignal
		{
			return _signal;
		}
	}
}
