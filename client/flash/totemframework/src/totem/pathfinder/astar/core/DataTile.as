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

	/**
	 * @private
	 * @author Jeroen Beckers
	 */
	 
	internal class DataTile
	{
			
		private var target : IAstarTile;
		private var g:Number;
		private var h:Number;
		private var f:Number;
		
		private var open:Boolean;
		private var closed:Boolean;
		
		private var parent:DataTile;
		
		private var multiplier:Number = 1;
		
		
		//the standard cost for this tile
		public var _standardCost:Number;
		
		
		public function DataTile()
		{
		}
		
		public function getTarget() : IAstarTile
		{
			return target;
		}
		
		public function setTarget(target : IAstarTile) : void
		{
			this.target = target;
		}
		
		public function getG() : Number
		{
			return g;
		}
		
		public function setG(g : Number) : void
		{
			this.g = g + getCost();
			this.f = this.h + this.g;
		}
		
		public function getH() : Number
		{
			return h;
		}
		
		public function setH(h:Number) : void
		{
			this.h = h;
			this.f = this.h + this.g;
		}
		
		public function getF() : Number
		{
			return this.f;
		}
		
		public function getOpen() : Boolean
		{
			return open;
		}
		
		public function setOpen(isOpen : Boolean) : void
		{
			this.open = isOpen;
		}
		
		public function getClosed() : Boolean
		{
			return closed;
		}
		
		public function setClosed() : void
		{
			this.closed = true;
		}
		
		public function getParent() : DataTile
		{
			return parent;
		}
		
		public function setParent(parent : DataTile) : void
		{
			this.parent = parent;
		}
		
		
		/**
		 * Sets the distance from this tile to its parent
		 */
		public function setDistance(ml : Number) : void
		{
			multiplier = ml;
		}
		

		public function getCost():Number
		{
			
			// If the target tile has implemented the ICostTile, it has a getCost() that has to be used
			if(target is ICostTile)
			{
				return ICostTile(target).getCost() * multiplier;
			}
			else
			{
				//if not, return standard cost
				return this._standardCost * multiplier;
			}
			
		}
		
		public function calculateUpdateF(parentCost:Number):Number
		{
			return (this.getCost() + parentCost + getH());
		}
	
	}


}
