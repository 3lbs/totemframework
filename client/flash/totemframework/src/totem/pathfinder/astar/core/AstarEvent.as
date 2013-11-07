/*
Copyright (c) 2011 Jeroen Beckers

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
*/

package totem.pathfinder.astar.core
{
	import flash.events.Event;

	/**
	 * The AstarEvent is dispatched by the Astar class when the path has or hasn't been found.
	 * @author Jeroen Beckers
	 */
	public class AstarEvent extends Event
	{
		/**
		 * Indicates that a path has been found
		 */
		public static const PATH_FOUND:String = "pathFound";
		
		/**
		 * Indicates that a path couldn't be found
		 */
		public static const PATH_NOT_FOUND:String = "pathNotFound";
		
		private var path:AstarPath;
		private var _request : PathRequest;
		
		
		/**
		 * Creates a new AstarEvent instance.
		 * 
		 * @param type		The type of event.
		 * @param path		The path that has been found (if any)
		 * @param request	The request that has been handled
		 */
		public function AstarEvent(type:String, path : AstarPath, request:PathRequest, bubbles:Boolean = false, cancelable:Boolean = false) 
		{
			super(type, bubbles, cancelable);
			this.path = path;
			this._request = request;
		}
		
		
		override public function clone():Event 
		{
			return new AstarEvent(this.type, this.path, this.request, this.bubbles, this.cancelable);
		}
		
		/**
		 * Returns the path thas has been found
		 */
		public function get result() : AstarPath
		{
			return path;
		}
		
		
		/**
		 * Returns the request that has been handled
		 */
		public function get request() : PathRequest
		{
			return _request;
		}
	}
}
