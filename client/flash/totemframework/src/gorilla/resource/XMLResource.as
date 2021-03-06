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

/*******************************************************************************
 * PushButton Engine
 * Copyright (C) 2009 PushButton Labs, LLC
 * For more information see http://www.pushbuttonengine.com
 *
 * This file is licensed under the terms of the MIT license, which is included
 * in the License.html file at the root directory of this SDK.
 ******************************************************************************/
package gorilla.resource
{

	import flash.system.System;
	import flash.utils.ByteArray;

	import ladydebug.Logger;

	[EditorData( extensions = "xml" )]
	/**
	 * This is a Resource subclass for XML data.
	 */
	public class XMLResource extends Resource
	{

		private var _valid : Boolean = true;

		private var _xml : XML = null;

		/**
		 * The loaded XML. This will be null until loading of the resource has completed.
		 */
		public function get XMLData() : XML
		{
			return _xml;
		}

		override public function destroy() : void
		{
			super.destroy();

			System.disposeXML( _xml );
			_xml = null;
		}

		/**
		 * The data loaded from an XML file is just a string containing the xml itself,
		 * so we don't need any special loading. This just converts the byte array to
		 * a string and marks the resource as loaded.
		 */
		override public function initialize( data : * ) : void
		{

			try
			{
				_xml = new XML( data );
			}
			catch ( e : TypeError )
			{
				if ( data is ByteArray )
				{
					// convert ByteArray data to a string
					data = ( data as ByteArray ).readUTFBytes(( data as ByteArray ).length );
				}

				try
				{
					_xml = new XML( data );
				}
				catch ( e : TypeError )
				{
					Logger.print( this, "Got type error parsing XML: " + e.toString());
					_valid = false;
				}
			}

			onLoadComplete();
		}

		/**
		 * @inheritDoc
		 */
		override protected function onContentReady( content : * ) : Boolean
		{
			return _valid;
		}
	}
}
