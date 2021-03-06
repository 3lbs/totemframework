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
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package totem.core.input.dragDrop
{

	/**
	 * Stores data associated with a drag and drop operation.
	 *
	 * @see DragDropManager
	 */
	public class DragData
	{

		/**
		 * @private
		 */
		protected var _data : Object = {};

		/**
		 * Constructor.
		 */
		public function DragData()
		{
		}

		/**
		 * Removes all data for the specified format.
		 */
		public function clearDataForFormat( format : String ) : *
		{
			var data : * = undefined;

			if ( this._data.hasOwnProperty( format ))
			{
				data = this._data[ format ];
			}
			delete this._data[ format ];
			return data;

		}

		/**
		 * Returns data for the specified format.
		 */
		public function getDataForFormat( format : String ) : *
		{
			if ( this._data.hasOwnProperty( format ))
			{
				return this._data[ format ];
			}
			return undefined;
		}

		/**
		 * Determines if the specified data format is available.
		 */
		public function hasDataForFormat( format : String ) : Boolean
		{
			return this._data.hasOwnProperty( format );
		}

		/**
		 * Saves data for the specified format.
		 */
		public function setDataForFormat( format : String, data : * ) : void
		{
			this._data[ format ] = data;
		}
	}
}
