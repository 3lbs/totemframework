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

package
{

	import com.childoftv.xlsxreader.Worksheet;
	import com.childoftv.xlsxreader.XLSXLoader;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;

	public class DidYouKnowDatabase extends EventDispatcher
	{

		protected var excel_loader : XLSXLoader = new XLSXLoader();

		private var LOADED : Boolean;

		private var _url : String;

		private var sheet : String;

		private var sheet_1 : Worksheet;

		private var totalRows : int;

		public function DidYouKnowDatabase()
		{
		}

		public function getFact( row : Number ) : String
		{
			return sheet_1.getCellValue( "A" + row );
		}

		public function getRandomFact() : String
		{
			var rnd : Number = Math.floor( Math.random() * ( 1 + totalRows - 2 ) + 2 );
			return sheet_1.getCellValue( "A" + rnd );
		}

		public function getTitle() : String
		{
			return sheet_1.getCellValue( "A1" );
		}

		public function isLoaded() : Boolean
		{
			return LOADED;
		}

		public function loadDatabase( pURL : String, pSheet : String = "Sheet1" ) : void
		{
			_url = pURL;
			sheet = pSheet;
			excel_loader.addEventListener( Event.COMPLETE, loadingComplete );

			//excel_loader.load( url );
		}
		public function loadDatabaseByteArray( data : ByteArray, pSheet : String = "Sheet1" ) : void
		{
			sheet = pSheet;

			excel_loader.addEventListener( Event.COMPLETE, loadingComplete );

		//	excel_loader.loadFromByteArray( data );
		}

		
		public function get url() : String
		{
			return _url;
		}

		private function loadingComplete( e : Event ) : void
		{
			LOADED = true;

			//Access a worksheet by name ('Sheet1')
			sheet_1 = excel_loader.worksheet( sheet );

			//Access a cell in sheet 1 and output to trace
			totalRows = sheet_1.getTotalRows();
		}
	}
}
