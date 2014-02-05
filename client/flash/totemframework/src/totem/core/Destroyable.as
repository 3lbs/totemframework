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

package totem.core
{

	public class Destroyable implements IDestroyable
	{
		protected var _isDestroyed : Boolean;

		public function Destroyable()
		{
			super();
		}

		public function destroy() : void
		{
			if ( _isDestroyed )
				return;

			this._isDestroyed = true;
		}

		[Transient]
		public function get destroyed() : Boolean
		{
			return this._isDestroyed;
		}
	}
}
