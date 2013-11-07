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

package totem.pathfinder.astar.basic3d 
{
	import flash.geom.Point;

	/**
	 * @author Jeroen
	 */
	public class Point3D extends Point
	{
		
		private var _z:int;
		
		
		public function Point3D(x:int, y:int, z:int = 0)
		{
			super(x, y);
			this._z = z;
		}
		
		public function get z():int
		{
			return _z;
			
		}
		
		override public function equals(pt:Point):Boolean
		{
			if(pt is Point3D)
			{
				var p:Point3D = pt as Point3D;
				return super.equals(pt) && _z == p._z;
			}
			else
			{
				return false;
			}
		}
		
		override public function toString():String
		{
			return "[Point3D (x="+this.x +", y="+this.y+", z="+this.z+")]";
		}
	}
	
	
	
	
	
}
