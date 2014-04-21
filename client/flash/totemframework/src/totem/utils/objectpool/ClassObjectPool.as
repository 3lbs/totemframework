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

package totem.utils.objectpool
{

	import totem.core.Destroyable;
	import totem.utils.construct;

	public class ClassObjectPool extends Destroyable
	{

		private var pool : Array = new Array();

		private var _type : Class;

		public function ClassObjectPool( type : Class )
		{
			super();

			_type = type;
		}

		public function checkIn( object : * ) : void
		{
			
			pool.push( object );
		}

		public function checkOut( ... parameters ) : *
		{

			if ( pool.length > 0 )
			{
				return pool.pop();
			}
			else
			{
				return construct( _type, parameters );
			}
		}

		override public function destroy() : void
		{
			super.destroy();

			pool.length = 0;
		}
	}
}
