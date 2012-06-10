/*
 * Copyright (c) 2007-2011 the original author or authors
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package org.as3commons.reflect {
	import org.as3commons.lang.IEquals;

	/**
	 * Holds a key/value pair of metadata information.
	 *
	 * @author Christophe Herreman
	 */
	public class MetadataArgument implements IEquals {

		private static const _cache:Object = {};

		// --------------------------------------------------------------------
		//
		// Class Methods
		//
		// --------------------------------------------------------------------

		public static function newInstance(name:String, value:String):MetadataArgument {
			var cacheKey:String = getCacheKeyByNameAndValue(name, value);
			if (!_cache[cacheKey]) {
				_cache[cacheKey] = new MetadataArgument(name, value);
			}
			return _cache[cacheKey];
		}

		public static function getCacheKey(arg:MetadataArgument):String {
			return getCacheKeyByNameAndValue(arg.key, arg.value);
		}

		public static function getCacheKeyByNameAndValue(key:String, value:String):String {
			return key + ":" + value;
		}

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		/**
		 * Creates a new MetadataArgument
		 *
		 * @param key the metadata key
		 * @param value the metadata value
		 */
		public function MetadataArgument(key:String, value:String) {
			_key = key;
			_value = value;
		}

		// --------------------------------------------------------------------
		//
		// Properties
		//
		// --------------------------------------------------------------------

		// ----------------------------

		private var _key:String;

		public function get key():String {
			return _key;
		}

		// ----------------------------

		private var _value:String;

		public function get value():String {
			return _value;
		}

		// --------------------------------------------------------------------
		//
		// Methods
		//
		// --------------------------------------------------------------------

		public function equals(other:Object):Boolean {
			if (this === other) {
				return true;
			}

			if (!(other is MetadataArgument)) {
				return false;
			}

			var that:MetadataArgument = MetadataArgument(other);
			return ((that.key === key) && (that.value === value));
		}

	}
}
