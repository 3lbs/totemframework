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

package totem.core.params
{

	/**
	 *
	 * @author eddie
	 */
	public class BaseParam
	{
		private var _id : String;

		private var _name : String;

		/**
		 *
		 */
		public function BaseParam()
		{
			//_name = TypeUtility.getObjectShortClassName( this ) + "_" + StringUtil.createRandomIdentifier( 3 );
			//_id = _name + StringUtil.createRandomIdentifier( 4 );
		}

		/**
		 *
		 * @return Game ID
		 */
		public function get id() : String
		{
			return _id;
		}

		/**
		 *
		 * @param value
		 */
		public function set id( value : String ) : void
		{
			_id = value;
		}

		/**
		 *
		 * @return Object Instance human readable name
		 */
		public function get name() : String
		{
			return _name;
		}

		/**
		 *
		 * @param value
		 */
		public function set name( value : String ) : void
		{
			_name = value;
		}
	}
}

