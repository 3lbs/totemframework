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

package totem.display.html
{

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.TextEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.Font;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;

	public class FtTableRenderer extends MovieClip
	{

		public static const TABLE_RENDERED_EVENT : String = "onTableRendered";

		public var _gridFitType : String;

		public var _sharpness : String;

		public var _thickness : String;

		public var _antiAliasType : String;

		var cellMcIdx;

		var colspan;

		var currCellNo;

		var currentCol;

		var currentColumn;

		var currentRow;

		var defImgHSpace = 0;

		var defImgVSpace = 0;

		var diffRatio;

		var drawObject;

		var j;

		var newColWidth;

		var rowID;

		var rowspan;

		var td;

		var tdCond1;

		var tdCond2;

		var tr : XMLNode;

		var xmlObj;

		private var _bytesLoaded : Number;

		private var _bytesTotal : Number;

		private var _cellList : Vector.<FtTableRendererBoxMc>;

		private var _fontColor : String;

		private var _fontFace : String;

		private var _fontSize : String;

		private var _isDirty : Boolean = true;

		private var _pageHeight : Number;

		private var _pageWidth : Number;

		private var _xmlDocument : XMLDocument;

		private var _xmlDocument2 : XMLDocument;

		private var cellNo : Number;

		private var clipperTimer : Timer;

		private var cssFileURL : String;

		private var filepath : String;

		// wait to figture this
		private var functionMaps : Dictionary;

		private var styleSheet : StyleSheet;

		public function FtTableRenderer()
		{
			_isDirty = true;
			functionMaps = new Dictionary();
			defImgVSpace = 0;
			defImgHSpace = 0;
			super();
			init();
		}

		public function get _height() : Number
		{
			return _pageHeight;
		}

		public function get _width() : Number
		{
			return _pageWidth;
		}

		public function adjustClipper() : void
		{
			clipperTimer = new Timer( 100, 0 );
			clipperTimer.addEventListener( "timer", timerHandler );
			clipperTimer.start();
		}

		public function get bytesLoaded() : Number
		{
			return _bytesLoaded;
		}

		public function get bytesTotal() : Number
		{
			return _bytesTotal;
		}

		public function createFromString( param1 : String ) : void
		{
			removeCells();
			_isDirty = true;
			this._xmlDocument = new XMLDocument();
			this._xmlDocument.parseXML( param1 );
			this._xmlDocument2 = new XMLDocument();
			this._xmlDocument.ignoreWhite = true;
			this._xmlDocument2.ignoreWhite = true;
			buildHTMLPage( _xmlDocument );
		}

		public function set fontColor( param1 : int ) : void
		{
			_fontColor = "#" + pp_getRGB( param1 );
		}

		public function set fontFace( param1 : String ) : void
		{
			_fontFace = param1;
		}

		public function set fontSize( param1 : String ) : void
		{
			_fontSize = param1;
		}

		public function getCells() : Vector.<FtTableRendererBoxMc>
		{
			return _cellList;
		}

		public function getData() : String
		{
			var i : int = 0;
			var _name : String;

			while ( i < this._xmlDocument.firstChild.childNodes.length )
			{
				_name = this._xmlDocument.firstChild.childNodes[ i ].nodeName;

				if ( _name.toLowerCase() == "body" )
				{
					this._xmlDocument.firstChild.childNodes[ i ].appendChild( this._xmlDocument2 );
					break;
				}
				i++;
			}
			return this._xmlDocument.toString();
		}

		public function getImgMc( param1 : MovieClip, param2 : String ) : DisplayObject
		{
			var _textField : TextField = param1.getChildByName( "textbox" ) as TextField;
			var _displayObject : DisplayObject = _textField.getImageReference( param2 );
			return _displayObject;
		}

		public function remove() : void
		{
			this.parent.removeChild( this );
		}

		public function removeCells() : void
		{
			var _loc1_ : DisplayObject;
			this.graphics.clear();

			for ( _loc1_ in this._cellList )
			{
				removeMc( this._cellList[ _loc1_ ]);
			}

			_cellList = new Vector.<FtTableRendererBoxMc>();

			cellNo = 0;
		}

		public function removeMc( param1 : DisplayObject ) : void
		{
			this.removeChild( param1 );
		}

		public function selectableText( param1 : MovieClip, param2 : Boolean ) : void
		{
			TextField( param1.getChildByName( "textbox" )).selectable = param2;
		}

		public function setCell( param1 : MovieClip, param2 : String, param3 : String ) : void
		{
			var _loc4_ : String = param3;

			if ( param3.toLowerCase().charAt( 1 ) == "x" )
			{
				_loc4_ = "#" + param3.substr( 2, param3.length );
			}
			param1.node.attributes[ param2 ] = _loc4_;

			if ( param2 == "width" )
			{
				param1.tdWidth = param3;
			}

			if ( param2 == "height" )
			{
				param1.tdHeight = param3;
			}

			if ( param2 == "bordercolor" )
			{
				param1.borderColor = param3;
			}

			if ( param2 == "borderalpha" )
			{
				param1.borderAlpha = param3;
			}

			if ( param2 == "bgcolor" )
			{
				param1.bgColor = param3;
			}

			if ( param2 == "bgalpha" )
			{
				param1.bgAlpha = param3;
			}

			if ( param2 == "align" )
			{
				if ( param1.embededFormat != undefined )
				{
					param1.embededFormat.align = param3;
					param1.tf.setTextFormat( param1.embededFormat );
				}
				else
				{
					xmlObj = new XMLDocument();
					xmlObj.parseXML( param1.defaultContent );
					xmlObj.firstChild.attributes.align = param3;
					param1.tf.text = String( xmlObj );
				}
			}

			if ( param2 == "cellfont" )
			{
				if ( param1.embededFormat != undefined )
				{
					param1.embededFormat.font = param3;
					param1[ "textbox" ].setTextFormat( param1.embededFormat );
				}
			}

			if (( !( param2 == "width" )) || ( !( param2 == "height" )) || ( !( param2 == "align" )) || ( !( param2 == "cellfont" )))
			{
				var cellpadding : Number = param1.cellpadding;
				var cellborder : Number = param1.cellborder;
				drawObject = new Object();
				drawObject.x1 = param1.tf.x - ( cellpadding + cellborder );
				drawObject.y1 = param1.tf.y - ( cellpadding + cellborder );
				drawObject.nwidth = param1.mywidth + 2 * ( cellpadding + cellborder );
				drawObject.nheight = param1.myheight + 2 * ( cellpadding + cellborder );
				drawObject.border = cellborder;
				drawObject.borderalpha = param1.borderAlpha;
				drawObject.bordercolor = param1.borderColor;
				drawObject.bgalpha = param1.bgAlpha;
				drawObject.bgcolor = param1.bgColor;
				drawCell( param1, drawObject );
			}
		}

		public function setClipper() : void
		{
			var _loc1_ : * = undefined;
			var _loc2_ : * = undefined;
			var _loc3_ : TextField;
			var _loc4_ : * = undefined;
			var _loc5_ : * = undefined;
			var _loc6_ : * = undefined;
			var _loc7_ : * = undefined;

			for ( _loc1_ in this._cellList )
			{
				_loc2_ = this._cellList[ _loc1_ ];
				_loc3_ = _loc2_.getChildByName( "textbox" );
				_loc4_ = _loc3_.width;
				_loc5_ = _loc3_.height;

				if (( !( _loc2_.imgId == undefined )) && ( !( _loc2_.imgId == null )))
				{
					_loc6_ = _loc3_.getImageReference( _loc2_.imgId );
					_loc7_ = _loc6_.mask;
					_loc7_.width = _loc4_;
					_loc7_.height = _loc5_;
					_loc6_.x = _loc6_.x - 2;
					_loc6_.y = _loc6_.y - 2;
				}
			}
			clipperTimer.removeEventListener( "timer", timerHandler );
		}

		public function setMethodPath( param1 : String, param2 : Function ) : void
		{
			functionMaps[ param1 ] = param2;
		}

		public function setTable( param1 : String, param2 : String ) : void
		{
			var _loc3_ : String = param2;

			if ( param2.toLowerCase().charAt( 1 ) == "x" )
			{
				_loc3_ = "#" + param2.substr( 2, param2.length );
			}

			this._xmlDocument2.firstChild.attributes[ param1 ] = _loc3_;
		}

		public function get sourceFile() : String
		{
			return filepath;
		}

		public function set sourceFile( param1 : String ) : void
		{
			filepath = param1;

			if ( filepath.charAt( 0 ) != "=" )
			{
				loadHTMLURL( filepath );
			}
		}

		public function updateTable() : void
		{
			buildTable( this._xmlDocument2 );
			_isDirty = false;
		}

		public function updateText( param1 : MovieClip, param2 : String ) : void
		{
			var length : int;
			var i : int = 0;
			var _xmlDoc : * = undefined;
			var nodeName : String;
			var align : String;
			var font : String;
			var fontColor : String;
			var fontSize : String;
			var htmlText : String;
			xmlObj = new XMLDocument();
			xmlObj.parseXML( param2 );

			while ( i < xmlObj.childNodes.length )
			{
				nodeName = xmlObj.childNodes[ i ].nodeName;

				if ( nodeName == "img" )
				{
					param1.minImgWidth = xmlObj.childNodes[ i ].attributes.width;
				}
				i++;
			}

			if ( param1.embededFormat != undefined )
			{
				param1.tf.htmlText = param2;
				param1.defaultContent = param2;
				param1.tf.setTextFormat( param1.embededFormat );
			}
			else
			{
				xmlObj = new XMLDocument();
				xmlObj.parseXML( param1.defaultContent );
				align = xmlObj.firstChild.attributes.align;
				font = xmlObj.firstChild.childNodes[ 0 ].attributes.font;
				fontColor = xmlObj.firstChild.childNodes[ 0 ].attributes.color;
				fontSize = xmlObj.firstChild.childNodes[ 0 ].attributes.size;
				htmlText = "<p align=\'" + align + "\'>" + "<font face=\'" + font + "\' size=\'" + fontSize + "\' color=\'" + fontColor + "\'>" + param2 + "</font></p>";
				param1.defaultContent = htmlText;
				param1.tf.htmlText = htmlText;
			}
			length = param1.node.childNodes.length;
			i = 0;

			while ( i < length )
			{
				param1.node.childNodes[ 0 ].removeNode();
				i++;
			}
			_xmlDoc = new XMLDocument();
			_xmlDoc.parseXML( param2 );
			param1.node.appendChild( _xmlDoc );
		}

		function timerHandler( param1 : TimerEvent ) : void
		{
			setClipper();
		}

		private function buildTableCells( xmlNode1 : XMLNode, xmlNode2 : XMLNode, param3 : int, param4 : int ) : void
		{
			var _textField : TextField;
			var _loc6_ : Object;
			var _loc7_ : Object;
			var _loc8_ : * = undefined;
			var _cellFieldName : String;
			var _textFieldName : String;
			var tableRenderBox : FtTableRendererBoxMc;
			var _loc14_ : * = undefined;
			var _cellFont : String;
			var _loc16_ : * = undefined;
			var _loc17_ : * = undefined;
			var _loc18_ : * = undefined;
			var _loc19_ : * = undefined;
			var _loc20_ : * = undefined;
			var _loc21_ : * = undefined;
			var _loc22_ : * = undefined;
			var _loc23_ : * = undefined;
			var _hspace : Number;
			var _font : Font;
			var _textFormat : TextFormat;
			this.cellNo++;
			_loc6_ = xmlNode2.attributes;
			_loc7_ = xmlNode1.attributes;
			xmlNode1.attributes();
			_loc8_ = xmlNode2.parentNode.attributes;
			_cellFieldName = "cellField_" + param3 + "_" + param4;

			if ( xmlNode2.attributes.id != undefined )
			{
				_cellFieldName = xmlNode2.attributes.id;
			}
			_textFieldName = "textbox";
			tableRenderBox = new FtTableRendererBoxMc();
			tableRenderBox.name = _cellFieldName;
			this.addChild( tableRenderBox );
			_textField = new TextField();
			_textField.width = 0;
			_textField.height = 0;
			_textField.x = 0;
			_textField.y = 0;
			_textField.name = _textFieldName;
			tableRenderBox.addChild( _textField );
			//_textField = _loc12_.getChildByName( _textFieldName );

			var tf : TextField;
			tableRenderBox.visited = 0;
			_loc14_ = "";

			_cellFont = this.getBestValue( _loc6_.cellfont, _loc8_.cellfont, _loc7_.cellfont, "" ) as String;
			_antiAliasType = this.getBestValue( _loc6_.antialias, _loc8_.antialias, _loc7_.antialias, "none" ) as String;
			_gridFitType = this.getBestValue( _loc6_.gridfit, _loc8_.gridfit, _loc7_.gridfit, "" ) as String;
			_sharpness = this.getBestValue( _loc6_.sharpness, _loc8_.sharpness, _loc7_.sharpness, "" ) as String;
			_thickness = this.getBestValue( _loc6_.thickness, _loc8_.thickness, _loc7_.thickness, "" ) as String;

			if ( _cellFont == "css" )
			{
				_textField.embedFonts = true;
			}
			_loc16_ = 0;

			if (( _cellFont == "" ) || ( _cellFont == "css" ))
			{
				_loc16_ = 1;
			}

			if ( _loc16_ )
			{
				_loc23_ = this.getBestValue( _loc6_.align, _loc8_.align, _loc7_.align, TextFormatAlign.RIGHT );
				_loc14_ = "<p align=\'" + _loc23_ + "\'>" + "<font face=\'" + _fontFace + "\' size=\'" + _fontSize + "\' color=\'" + _fontColor + "\'>";
				_textField.styleSheet = styleSheet;
			}
			_textField.autoSize = TextFieldAutoSize.LEFT;
			tableRenderBox.tdWidth = _loc6_.width;
			tableRenderBox.tdHeight = _loc6_.height;
			_textField.width = this.getBestValue( _loc6_.width, 1 ) as Number;
			_textField.height = this.getBestValue( _loc6_.height, 1 ) as Number;
			_loc17_ = this.getBestValue( _loc6_.bgcolor, _loc8_.bgcolor, _loc7_.bgcolor, "0xffffff" );

			if ( _loc17_.charAt( 0 ) != "0" )
			{
				_loc17_ = "0x" + _loc17_.substr( 1, _loc17_.length );
			}
			tableRenderBox.bgColor = _loc17_;
			_loc18_ = this.getBestValue( _loc6_.bgalpha, _loc8_.bgalpha, _loc7_.bgalpha, 1 );
			tableRenderBox.bgAlpha = _loc18_;
			_loc19_ = this.getBestValue( _loc6_.bordercolor, _loc8_.bordercolor, _loc7_.bordercolor, "0xffffff" );

			if ( _loc19_.charAt( 0 ) != "0" )
			{
				_loc19_ = "0x" + _loc19_.substr( 1, _loc19_.length );
			}
			tableRenderBox.borderColor = _loc19_;
			_loc20_ = this.getBestValue( _loc6_.borderalpha, _loc8_.borderalpha, _loc7_.borderalpha, 1 );
			tableRenderBox.borderAlpha = _loc20_;
			_textField.type = this.getBestValue( _loc6_.type, _loc7_.type, "dynamic" );
			_textField.multiline = true;
			_textField.wordWrap = false;

			if ( _cellFont != "" )
			{
				if ( _antiAliasType != "none" )
				{
					_textField.antiAliasType = _antiAliasType;
				}

				if ( _antiAliasType == "advanced" )
				{
					if ( _gridFitType != "" )
					{
						_textField.gridFitType = _gridFitType;
					}

					if ( _sharpness != "" )
					{
						_textField.sharpness = Number( _sharpness );
					}

					if ( _thickness != "" )
					{
						_textField.thickness = Number( _thickness );
					}
				}
			}
			tableRenderBox.tf = _textField;
			tableRenderBox.node = xmlNode2;
			tableRenderBox.rowid = param3;
			tableRenderBox.cellid = param4;
			tableRenderBox.minImgWidth = 0;
			_loc21_ = 0;

			while ( _loc21_ < xmlNode2.childNodes.length )
			{
				_loc14_ = _loc14_ + xmlNode2.childNodes[ _loc21_ ];

				if ( xmlNode2.childNodes[ _loc21_ ].nodeName == "img" )
				{
					if ( xmlNode2.childNodes[ _loc21_ ].attributes.id != undefined )
					{
						tableRenderBox.imgId = xmlNode2.childNodes[ _loc21_ ].attributes.id;
					}

					if ( xmlNode2.childNodes[ _loc21_ ].attributes.width == undefined )
					{
						tableRenderBox.minImgWidth = 10;
					}
					else
					{
						_hspace = xmlNode2.childNodes[ _loc21_ ].attributes.hspace == undefined ? 0 : Number( xmlNode2.childNodes[ _loc21_ ].attributes.hspace );
						tableRenderBox.minImgWidth = Number( xmlNode2.childNodes[ _loc21_ ].attributes.width ) + _hspace + defImgHSpace;
					}
				}
				_loc21_++;
			}

			if ( _loc16_ )
			{
				_loc14_ = _loc14_ + "</font></p>";
			}
			_loc22_ = _loc14_.indexOf( "event" );

			if ( _loc22_ )
			{
				_loc14_ = convertASFunction( _loc14_ );
				addEventListener( "link", linkHandler );
			}
			_textField.htmlText = _loc14_;
			tableRenderBox.defaultContent = _loc14_;

			if (( !( _cellFont == "" )) && ( !( _cellFont == "css" )))
			{
				_textField.embedFonts = true;
				var clazz : Class = getDefinitionByName( _cellFont ) as Class;
				_font = new clazz();
				_textFormat = new TextFormat();
				_textFormat.font = _font.fontName;
				_textFormat.align = this.getBestValue( _loc6_.align, _loc8_.align, _loc7_.align, "left" );
				_textField.setTextFormat( _textFormat );
				tableRenderBox.embededFormat = _textFormat;
			}

			if ( _textField.type == "input" )
			{
				_textField.addEventListener( Event.CHANGE, textFieldChangeHandler );
			}
			
			this._cellList.push( tableRenderBox );
		}

		private function buildHTMLPage( param1 : XMLDocument ) : void
		{
			var _nodeName : String = param1.firstChild.nodeName.toLowerCase();
			var _loc3_ : XMLNode = param1.firstChild;
			var i : int;
			var _pageXML : XMLNode;

			if ( _nodeName == "table" )
			{
				return;
			}
			i = 0;

			while ( i < _loc3_.childNodes.length )
			{
				_pageXML = _loc3_.childNodes[ i ];
				_nodeName = _pageXML.nodeName.toLowerCase();

				if ( _nodeName == "head" )
				{
					cssFileURL = _pageXML.firstChild.attributes.href;
				}

				if ( _nodeName == "body" )
				{
					this._xmlDocument2.parseXML( _pageXML.firstChild.toString());
					_pageXML.firstChild.removeNode();

					if ( cssFileURL != null )
					{
						loadCSSFile( cssFileURL );
					}
					else
					{
						buildTable( this._xmlDocument2 );
					}
				}
				i++;
			}
		}

		private function buildTable( param1 : XMLDocument ) : *
		{
			var _loc2_ : XMLNode= param1.firstChild;
			var _loc3_ : Array;
			var _loc4_ : Array;
			var _length : int;
			var _loc6_ : Number;
			var _loc7_ : Number;
			var _loc8_ : * = undefined;
			var _loc9_ : * = undefined;
			var _loc10_ : * = undefined;
			var _loc11_ : Number;
			var _loc12_ : * = undefined;
			var _loc13_ : * = NaN;
			var _loc14_ : * = NaN;
			var _loc15_ : * = undefined;
			var _loc16_ : * = NaN;
			var _loc17_ : * = undefined;
			var _loc18_ : * = NaN;
			var _loc19_ : * = NaN;
			var _loc20_ : * = NaN;
			var _loc21_ : * = NaN;
			var _loc22_ : * = NaN;
			var _loc23_ : * = NaN;
			var _loc24_ : * = NaN;
			var _loc25_ : int;
			var _loc26_ : * = undefined;
			var _loc27_ : * = undefined;
			var _loc28_ : * = undefined;
			var _loc29_ : * = undefined;
			var _loc30_ : * = undefined;
			var _loc31_ : * = undefined;
			var _loc32_ : * = undefined;
			var _loc33_ : * = undefined;
			var _loc34_ : * = undefined;
			var _loc35_ : * = undefined;
			var _loc36_ : * = undefined;
			var _loc37_ : * = undefined;
			var _loc38_ : * = undefined;
			var _loc39_ : * = undefined;
			var _loc40_ : * = undefined;
			var _loc41_ : * = undefined;
			var _loc42_ : * = undefined;
			var _loc43_ : int;
			var _loc44_ : int;
			var _loc45_ : XMLNode;
			var _loc46_ : * = undefined;
			var _loc47_ : * = undefined;
			var _loc48_ : * = undefined;
			var _loc49_ : * = undefined;
			var _loc50_ : * = undefined;
			var _loc51_ : * = undefined;
			var _loc52_ : * = undefined;
			var _loc53_ : * = undefined;
			var _loc54_ : * = undefined;
			var _loc55_ : * = undefined;
			var _loc56_ : * = undefined;
			var _loc57_ : * = undefined;
			var _loc58_ : * = undefined;
			var _loc59_ : * = undefined;
			var _loc60_ : * = undefined;
			var _loc61_ : * = undefined;
			var _loc62_ : * = undefined;
			var _loc63_ : * = undefined;
			var _loc64_ : * = undefined;
			var _loc65_ : * = undefined;
			var _loc66_ : * = undefined;
			var _loc67_ : * = undefined;
			var _loc68_ : * = undefined;
			var _loc69_ : * = undefined;
			var _loc70_ : * = undefined;
			var _loc71_ : * = undefined;
			var _loc72_ : * = undefined;
			var _loc73_ : * = undefined;
			var _loc74_ : * = undefined;
			var _loc75_ : * = undefined;
			_loc3_ = new Array();
			_loc4_ = new Array();
			_length = _loc2_.childNodes.length;
			_loc6_ = 0;
			_loc7_ = 0;
			_loc10_ = !( _loc2_.attributes.width == undefined );
			_loc11_ = _loc10_ ? Number( _loc2_.attributes.width ) : this.stage.stageWidth;

			if ( _loc10_ )
			{
				_loc41_ = _loc2_.attributes.width.charAt( _loc2_.attributes.width.length - 1 );

				if ( _loc41_ == "%" )
				{
					_loc8_ = Number( _loc2_.attributes.width.substr( 0, _loc2_.attributes.width.length - 1 ));
					_loc11_ = _loc8_ * this.stage.stageWidth / 100;
				}
			}
			_loc12_ = !( _loc2_.attributes.height == undefined );
			_loc13_ = _loc12_ ? Number( _loc2_.attributes.height ) : this.stage.stageHeight;

			if ( _loc12_ )
			{
				_loc42_ = _loc2_.attributes.height.charAt( _loc2_.attributes.height.length - 1 );

				if ( _loc42_ == "%" )
				{
					_loc8_ = Number( _loc2_.attributes.height.substr( 0, _loc2_.attributes.height.length - 1 ));
					_loc9_ = _loc13_ = _loc8_ * this.stage.stageHeight / 100;
				}
				else
				{
					_loc9_ = Number( _loc2_.attributes.height );
				}
			}
			_loc14_ = _loc2_.attributes.border ? Number( _loc2_.attributes.border ) : 0;
			_loc15_ = 0;

			if ( _loc2_.attributes.bordercolor )
			{
				_loc15_ = _loc2_.attributes.bordercolor;

				if ( _loc15_.charAt( 0 ) != "0" )
				{
					_loc15_ = "0x" + _loc15_.substr( 1, _loc15_.length );
				}
			}

			if ( _loc2_.attributes.borderalpha == undefined )
			{
				_loc16_ = 1;
			}
			else
			{
				_loc16_ = _loc2_.attributes.borderalpha;
			}
			_loc17_ = 16777215;

			if ( _loc2_.attributes.bgcolor )
			{
				_loc17_ = _loc2_.attributes.bgcolor;

				if ( _loc17_.charAt( 0 ) != "0" )
				{
					_loc17_ = "0x" + _loc17_.substr( 1, _loc17_.length );
				}
			}

			if ( _loc2_.attributes.bgalpha == undefined )
			{
				_loc18_ = 1;
			}
			else
			{
				_loc18_ = _loc2_.attributes.bgalpha;
			}
			_loc19_ = _loc2_.attributes.cellpadding ? Number( _loc2_.attributes.cellpadding ) : 0;
			_loc20_ = _loc2_.attributes.cellspacing ? Number( _loc2_.attributes.cellspacing ) : 0;
			_loc21_ = _loc2_.attributes.border ? Number( _loc2_.attributes.border ) : 0;

			if ( _loc21_ > 1 )
			{
				_loc21_ = 1;
			}
			_loc22_ = 2 * _loc19_ + 2 * _loc21_ + _loc20_;
			_loc23_ = _loc14_ + _loc20_ + _loc19_ + _loc21_;
			_loc24_ = _loc14_ + _loc20_ + _loc19_ + _loc21_;
			cellMcIdx = 0;
			_loc25_ = 0;

			while ( _loc25_ < _length )
			{
				tr = _loc2_.childNodes[ _loc25_ ];
				_loc43_ = tr.childNodes.length;
				_loc6_ = 0;
				_loc44_ = 0;

				while ( _loc44_ < _loc43_ )
				{
					_loc45_ = tr.childNodes[ _loc44_ ];

					if ( _isDirty == true )
					{
						this.buildTableCells( _loc2_, _loc45_, _loc25_, _loc44_ );
					}
					_cellList[ cellMcIdx ].cellborder = _loc21_;
					_cellList[ cellMcIdx ].cellpadding = _loc19_;
					_cellList[ cellMcIdx ].cellspacing = _loc20_;
					_loc46_ = this.getBestValue( _loc45_.attributes.bgcolor, tr.attributes.bgcolor, _loc2_.attributes.bgcolor, "0xffffff" );

					if ( _loc46_.charAt( 0 ) != "0" )
					{
						_loc46_ = "0x" + _loc46_.substr( 1, _loc46_.length );
					}
					_cellList[ cellMcIdx ].bgColor = _loc46_;
					_loc47_ = this.getBestValue( _loc45_.attributes.bordercolor, tr.attributes.bordercolor, _loc2_.attributes.bordercolor, "0xffffff" );

					if ( _loc47_.charAt( 0 ) != "0" )
					{
						_loc47_ = "0x" + _loc47_.substr( 1, _loc47_.length );
					}
					_cellList[ cellMcIdx ].borderColor = _loc47_;
					_cellList[ cellMcIdx ].bgAlpha = this.getBestValue( _loc45_.attributes.bgalpha, tr.attributes.bgalpha, _loc2_.attributes.bgalpha, 1 );
					_cellList[ cellMcIdx ].borderAlpha = this.getBestValue( _loc45_.attributes.borderalpha, tr.attributes.borderalpha, _loc2_.attributes.borderalpha, 1 );
					colspan = _loc45_.attributes.colspan > 1 ? Number( _loc45_.attributes.colspan ) : 1;
					_loc6_ = _loc6_ + colspan;
					cellMcIdx++;
					_loc44_++;
				}

				if ( _loc6_ >= _loc7_ )
				{
					_loc7_ = _loc6_;
				}
				_loc25_++;
			}
			_loc6_ = _loc7_;
			_loc11_ = _loc11_ - _loc6_ * _loc22_ - _loc20_ - 2 * _loc14_;
			_loc13_ = _loc13_ - _length * _loc22_ - _loc20_ - 2 * _loc14_;
			_isDirty = false;
			tr = _loc2_.firstChild;
			cellMcIdx = 0;
			_loc25_ = 0;

			while ( _loc25_ < _length )
			{
				_loc45_ = null;
				_loc29_ = 0;

				while ( _loc29_ < _loc6_ )
				{
					currentCol = _loc3_[ _loc29_ ];
					tdCond1 = false;

					if ( currentCol != undefined )
					{
						tdCond1 = ( currentCol.rowSpanCountdown == 0 ) || ( currentCol.rowSpanCountdown == undefined );
					}

					if (( currentCol == undefined ) || ( tdCond1 ))
					{
						_loc45_ = _loc45_ == null ? tr.firstChild : _loc45_.nextSibling;

						if ( _loc45_ != null )
						{
							if ( _loc45_.attributes.colspan != undefined )
							{
								colspan = Number( _loc45_.attributes.colspan );
							}
							else
							{
								colspan = 1;
							}

							if ( _cellList[ cellMcIdx ].tdWidth == undefined )
							{
								_cellList[ cellMcIdx ].tdWidth = 0;
							}

							if ( _cellList[ cellMcIdx ].tdWidth > _loc11_ )
							{
								_cellList[ cellMcIdx ].tdWidth = _loc11_;
							}

							if ( _cellList[ cellMcIdx ].tdHeight > _loc13_ )
							{
								_cellList[ cellMcIdx ].tdHeight = _loc13_;
							}
							_cellList[ cellMcIdx ].tf.autoSize = TextFieldAutoSize.LEFT;
							_cellList[ cellMcIdx ].tf.wordWrap = false;

							if ( _cellList[ cellMcIdx ].tdWidth is String )
							{
								_loc51_ = _cellList[ cellMcIdx ].tdWidth.charAt( _cellList[ cellMcIdx ].tdWidth.length - 1 );

								if ( _loc51_ == "%" )
								{
									_loc52_ = Number( _cellList[ cellMcIdx ].tdWidth.substr( 0, _cellList[ cellMcIdx ].tdWidth.length - 1 ));
									_cellList[ cellMcIdx ].tdWidth = _loc52_ * _loc11_ / 100;
								}
							}
							_loc48_ = Math.max( _cellList[ cellMcIdx ].tf.textWidth, _cellList[ cellMcIdx ].minImgWidth );
							_cellList[ cellMcIdx ].maxWidth = _cellList[ cellMcIdx ].tdWidth ? _cellList[ cellMcIdx ].tdWidth : _loc48_;
							_cellList[ cellMcIdx ].maxWidth = _cellList[ cellMcIdx ].maxWidth / colspan;
							_loc49_ = 1;

							if ( _cellList[ cellMcIdx ].tf.textWidth > 1 )
							{
								_loc49_ = qSnFppLVlrfGyeo( _cellList[ cellMcIdx ].tf.text, _cellList[ cellMcIdx ].tf.textWidth );
							}
							_loc49_ = Math.max( _loc49_, _cellList[ cellMcIdx ].minImgWidth );
							_loc49_ = _loc49_ / colspan;
							_loc50_ = _cellList[ cellMcIdx ].tdWidth / colspan;
							_cellList[ cellMcIdx ].minWidth = Math.max( _loc49_, _loc50_ );

							if ( colspan > 1 )
							{
								_loc49_ = _cellList[ cellMcIdx ].minWidth = _cellList[ cellMcIdx ].maxWidth = 0;
							}

							if ( _loc3_[ _loc29_ ] == null )
							{
								_loc3_[ _loc29_ ] = new Object();
							}
							_loc3_[ _loc29_ ].maxWidth = _loc3_[ _loc29_ ].maxWidth == undefined ? _cellList[ cellMcIdx ].maxWidth : Math.max( _cellList[ cellMcIdx ].maxWidth, _loc3_[ _loc29_ ].maxWidth );
							_loc3_[ _loc29_ ].minWidth = _loc3_[ _loc29_ ].minWidth == undefined ? _cellList[ cellMcIdx ].minWidth : Math.max( _cellList[ cellMcIdx ].minWidth, _loc3_[ _loc29_ ].minWidth );
							_loc3_[ _loc29_ ].minTextWidth = _loc3_[ _loc29_ ].minTextWidth == undefined ? _loc49_ : Math.max( _loc49_, _loc3_[ _loc29_ ].minTextWidth );
							_loc3_[ _loc29_ ].width = _loc3_[ _loc29_ ].maxWidth;
							_loc3_[ _loc29_ ].rowSpanCountdown = _loc45_.attributes.rowspan == undefined ? 0 : Number( _loc45_.attributes.rowspan ) - 1;
							_cellList[ cellMcIdx ].tf.wordWrap = true;

							if ( colspan > 1 )
							{
								j = _loc29_ + 1;

								while ( j < _loc29_ + colspan )
								{
									if ( _loc3_[ j ] == null )
									{
										_loc3_[ j ] = new Object();
										_loc3_[ j ].maxWidth = 0;
									}
									_loc3_[ j ].maxWidth = Math.max( _cellList[ cellMcIdx ].maxWidth, _loc3_[ j ].maxWidth );
									j++;
								}
							}
							_loc29_ = _loc29_ + colspan;
							cellMcIdx++;
						}
					}
					else
					{
						currentCol.rowSpanCountdown--;
						_loc29_++;
					}
				}
				tr = tr.nextSibling;
				_loc25_++;
			}
			_loc26_ = 0;
			diffRatio = 0;
			_loc27_ = 0;
			_loc28_ = 0;
			_loc29_ = 0;

			while ( _loc29_ < _loc6_ )
			{
				_loc53_ = _loc3_[ _loc29_ ];

				if ( _loc53_.width < _loc53_.minTextWidth )
				{
					_loc53_.width = _loc53_.minTextWidth;
				}
				_loc26_ = _loc26_ + _loc53_.width;
				_loc53_.visit = 0;
				_loc3_[ _loc29_ ].expand = 0;

				if ( _loc53_.width > _loc53_.minWidth )
				{
					_loc28_ = _loc28_ + 1;
					_loc53_.expand = 1;
				}
				_loc29_++;
			}

			if ( _loc26_ < _loc11_ )
			{
				_loc27_ = _loc11_ - _loc26_;

				if ( _loc28_ == 0 )
				{
					diffRatio = _loc27_ / _loc6_;
				}
				else
				{
					diffRatio = _loc27_ / _loc28_;
				}
				_loc29_ = 0;

				while ( _loc29_ < _loc6_ )
				{
					_loc53_ = _loc3_[ _loc29_ ];

					if (( _loc53_.expand == 1 ) || ( _loc28_ == 0 ))
					{
						_loc53_.width = _loc53_.width + diffRatio;
					}
					_loc29_++;
				}
			}

			if ( _loc26_ > _loc11_ )
			{
				_loc27_ = _loc26_ - _loc11_;
				diffRatio = _loc27_ / _loc6_;
				_loc54_ = _loc6_;
				_loc55_ = 0;
				_loc56_ = 1;
				_loc57_ = 0;

				while ( _loc56_ )
				{
					_loc29_ = 0;

					while ( _loc29_ < _loc6_ )
					{
						_loc53_ = _loc3_[ _loc29_ ];
						_loc53_.width = Number( _loc53_.width );
						_loc58_ = _loc53_.width - diffRatio;

						if (( _loc58_ < _loc53_.minWidth ) && ( _loc53_.visit == 0 ))
						{
							_loc57_ = _loc53_.width - _loc53_.minWidth;
							_loc55_ = _loc55_ + ( diffRatio - _loc57_ );
							_loc54_ = _loc54_ - 1;
							_loc53_.width = _loc53_.minWidth;
							_loc53_.visit = 1;
						}
						else
						{
							if ( _loc53_.width > _loc53_.minWidth )
							{
								_loc53_.width = _loc53_.width - diffRatio;
							}
						}
						_loc29_++;
					}

					if (( _loc55_ > 0 ) && ( _loc54_ > 0 ))
					{
						diffRatio = _loc55_ / _loc54_;
						_loc55_ = 0;
					}
					else
					{
						_loc56_ = 0;
					}
				}
				_loc29_ = 0;

				while ( _loc29_ < _loc6_ )
				{
					_loc3_[ _loc29_ ].visit = 0;
					_loc29_++;
				}

				if ( _loc55_ > 0 )
				{
					diffRatio = _loc55_ / _loc6_;
					_loc54_ = _loc6_;
					_loc55_ = 0;
					_loc56_ = 1;

					while ( _loc56_ )
					{
						_loc29_ = 0;

						while ( _loc29_ < _loc6_ )
						{
							_loc53_ = _loc3_[ _loc29_ ];
							_loc53_.width = Number( _loc53_.width );
							_loc58_ = _loc53_.width - diffRatio;

							if (( _loc58_ < _loc53_.minTextWidth ) && ( _loc53_.visit == 0 ))
							{
								_loc57_ = _loc53_.width - _loc53_.minTextWidth;
								_loc55_ = _loc55_ + ( diffRatio - _loc57_ );
								_loc54_ = _loc54_ - 1;
								_loc53_.width = _loc53_.minTextWidth;
								_loc53_.visit = 1;
							}
							else
							{
								if ( _loc53_.width > _loc53_.minTextWidth )
								{
									_loc53_.width = _loc53_.width - diffRatio;
								}
							}
							_loc29_++;
						}

						if (( _loc55_ > 0 ) && ( _loc54_ > 0 ))
						{
							diffRatio = _loc55_ / _loc54_;
							_loc55_ = 0;
						}
						else
						{
							_loc56_ = 0;
						}
					}
				}
			}
			zeroRowSpanCountDown( _loc3_ );
			tr = _loc2_.firstChild;
			cellMcIdx = 0;
			_loc25_ = 0;

			while ( _loc25_ < _length )
			{
				currentRow = _loc4_[ _loc25_ ];
				_loc45_ = null;
				_loc29_ = 0;

				while ( _loc29_ < _loc6_ )
				{
					currentCol = _loc3_[ _loc29_ ];
					_loc59_ = 0;
					tdCond1 = false;

					if ( currentCol != undefined )
					{
						tdCond1 = ( currentCol.rowSpanCountdown == 0 ) || ( currentCol.rowSpanCountdown == undefined );
					}

					if (( currentCol == undefined ) || ( tdCond1 ))
					{
						_loc45_ = _loc45_ == null ? tr.firstChild : _loc45_.nextSibling;
						_cellList[ cellMcIdx ].tf.autoSize = TextFieldAutoSize.LEFT;
						currentCol.rowSpanCountdown = _loc45_.attributes.rowspan == undefined ? 0 : Number( _loc45_.attributes.rowspan ) - 1;
						colspan = _loc45_.attributes.colspan == undefined ? 1 : Number( _loc45_.attributes.colspan );
						_loc60_ = 0;

						while ( colspan > 0 )
						{
							_loc60_ = _loc60_ + _loc3_[ _loc29_++ ].width;
							colspan--;
						}
						_cellList[ cellMcIdx ].tf.width = _loc60_;
						cellMcIdx++;
					}
					else
					{
						currentCol.rowSpanCountdown--;
						_loc29_++;
					}
				}
				tr = tr.nextSibling;
				_loc25_++;
			}
			zeroRowSpanCountDown( _loc3_ );
			cellMcIdx = 0;
			tr = _loc2_.firstChild;
			_loc25_ = 0;

			while ( _loc25_ < _length )
			{
				_loc45_ = null;
				_loc29_ = 0;

				while ( _loc29_ < _loc6_ )
				{
					currentCol = _loc3_[ _loc29_ ];
					tdCond1 = false;

					if ( currentCol != undefined )
					{
						tdCond1 = ( currentCol.rowSpanCountdown == 0 ) || ( currentCol.rowSpanCountdown == undefined );
					}

					if (( currentCol == undefined ) || ( tdCond1 ))
					{
						_loc45_ = _loc45_ == null ? tr.firstChild : _loc45_.nextSibling;

						if ( _loc45_ != null )
						{
							colspan = _loc45_.attributes.colspan == undefined ? 1 : Number( _loc45_.attributes.colspan );
							rowspan = _loc45_.attributes.rowspan == undefined ? 1 : Number( _loc45_.attributes.rowspan );

							if ( _cellList[ cellMcIdx ].tdHeight is String )
							{
								_loc65_ = _cellList[ cellMcIdx ].tdHeight.charAt( _cellList[ cellMcIdx ].tdHeight.length - 1 );

								if ( _loc65_ == "%" )
								{
									_loc52_ = Number( _cellList[ cellMcIdx ].tdHeight.substr( 0, _cellList[ cellMcIdx ].tdHeight.length - 1 ));

										// Eddie:  Not sure will figure out later
										//_loc45_.cellRef.tdHeight = _loc52_ * _loc13_ / 100;
								}
							}
							_loc62_ = _cellList[ cellMcIdx ].tf.height;
							_loc63_ = _loc62_ / rowspan;
							_loc64_ = _cellList[ cellMcIdx ].tdHeight - 2 * ( _loc19_ + _loc21_ );

							if ( _loc64_ > _cellList[ cellMcIdx ].tf.height )
							{
								_loc61_ = _loc64_ / rowspan;
							}
							else
							{
								_loc61_ = 0;
							}
							_cellList[ cellMcIdx ].maxHeight = Math.max( _loc63_, _loc61_ );
							_cellList[ cellMcIdx ].minHeight = _cellList[ cellMcIdx ].tf.height;

							if (( _loc45_.childNodes.length == 0 ) && ( _cellList[ cellMcIdx ].tdHeight == undefined ))
							{
								_cellList[ cellMcIdx ].minHeight = _cellList[ cellMcIdx ].maxHeight = 0;
							}

							if (( _loc45_.childNodes.length == 0 ) && ( !( _cellList[ cellMcIdx ].tdHeight == undefined )))
							{
								_cellList[ cellMcIdx ].minHeight = _cellList[ cellMcIdx ].maxHeight = _loc64_ / rowspan;
							}

							if (( _loc45_.childNodes.length == 1 ) && ( _loc45_.childNodes[ 0 ].nodeName == "img" ))
							{
								_loc66_ = _loc45_.childNodes[ 0 ].attributes.height;
								_loc67_ = _loc45_.childNodes[ 0 ].attributes.vspace == undefined ? 0 : Number( _loc45_.childNodes[ 0 ].attributes.vspace );

								if ( _loc66_ != undefined )
								{
									_loc66_ = Number( _loc66_ ) + _loc67_ + defImgVSpace;
									_cellList[ cellMcIdx ].minHeight = _cellList[ cellMcIdx ].maxHeight = _loc66_;

									if ( _loc64_ > _loc66_ )
									{
										_cellList[ cellMcIdx ].minHeight = _loc66_;
										_cellList[ cellMcIdx ].maxHeight = _loc64_ / rowspan;
									}
								}
							}

							if ( _loc4_[ _loc25_ ] == null )
							{
								_loc4_[ _loc25_ ] = new Object();
							}
							_loc4_[ _loc25_ ].maxHeight = Math.max( _cellList[ cellMcIdx ].maxHeight, _loc4_[ _loc25_ ].maxHeight == undefined ? _cellList[ cellMcIdx ].maxHeight : _loc4_[ _loc25_ ].maxHeight );
							_loc4_[ _loc25_ ].minHeight = Math.min( _cellList[ cellMcIdx ].minHeight, _loc4_[ _loc25_ ].minHeight == undefined ? _cellList[ cellMcIdx ].minHeight : _loc4_[ _loc25_ ].minHeight );
							_loc4_[ _loc25_ ].height = _loc4_[ _loc25_ ].maxHeight;
							_loc3_[ _loc29_ ].rowSpanCountdown = _loc45_.attributes.rowspan == undefined ? 0 : Number( _loc45_.attributes.rowspan ) - 1;

							if ( rowspan > 1 )
							{
								j = _loc25_ + 1;

								while ( j < _loc25_ + rowspan )
								{
									if ( _loc4_[ j ] == null )
									{
										_loc4_[ j ] = new Object();
										_loc4_[ j ].maxHeight = 0;
									}
									_loc4_[ j ].maxHeight = Math.max( _cellList[ cellMcIdx ].maxHeight, _loc4_[ j ].maxHeight );
									j++;
								}
							}
							_loc29_ = _loc29_ + colspan;
							cellMcIdx++;
						}
					}
					else
					{
						currentCol.rowSpanCountdown--;
						_loc29_++;
					}
				}
				tr = tr.nextSibling;
				_loc25_++;
			}
			_loc30_ = 0;
			_loc31_ = 0;
			_loc32_ = 0;
			diffRatio = 0;
			_loc25_ = 0;

			while ( _loc25_ < _length )
			{
				currentRow = _loc4_[ _loc25_ ];
				_loc30_ = _loc30_ + currentRow.height;
				currentRow.expand = 0;

				if ( currentRow.height > currentRow.minHeight )
				{
					_loc32_ = _loc32_ + 1;
					currentRow.expand = 1;
				}
				_loc25_++;
			}

			if ( _loc2_.attributes.height != undefined )
			{
				if ( _loc30_ < _loc9_ )
				{
					_loc31_ = _loc13_ - _loc30_;

					if ( _loc32_ == 0 )
					{
						diffRatio = _loc31_ / _length;
					}
					else
					{
						diffRatio = _loc31_ / _loc32_;
					}
					_loc25_ = 0;

					while ( _loc25_ < _length )
					{
						currentRow = _loc4_[ _loc25_ ];

						if (( currentRow.expand == 1 ) || ( _loc32_ == 0 ))
						{
							currentRow.height = currentRow.height + diffRatio;
						}
						_loc25_++;
					}
				}
			}
			_loc29_ = 0;

			while ( _loc29_ < _loc6_ )
			{
				_loc53_ = _loc3_[ _loc29_ ];

				if ( _loc29_ == 0 )
				{
					_loc53_.xMin = _loc23_;
				}
				else
				{
					_loc53_.xMin = _loc3_[ _loc29_ - 1 ].xMax;
				}

				if ( _loc29_ == _loc6_ - 1 )
				{
					_loc53_.xMax = _loc53_.xMin + _loc53_.width + _loc19_ + _loc21_ + _loc20_;
				}
				else
				{
					_loc53_.xMax = _loc53_.xMin + _loc53_.width + _loc22_;
				}
				_loc29_++;
			}
			_loc25_ = 0;

			while ( _loc25_ < _length )
			{
				currentRow = _loc4_[ _loc25_ ];

				if ( _loc25_ == 0 )
				{
					currentRow.yMin = _loc24_;
				}
				else
				{
					currentRow.yMin = _loc4_[ _loc25_ - 1 ].yMax;
				}

				if ( _loc25_ == _length - 1 )
				{
					currentRow.yMax = currentRow.yMin + currentRow.height + _loc19_ + _loc21_ + _loc20_;
				}
				else
				{
					currentRow.yMax = currentRow.yMin + currentRow.height + _loc22_;
				}
				_loc25_++;
			}
			zeroRowSpanCountDown( _loc3_ );
			cellMcIdx = 0;
			_loc33_ = 0;
			_loc34_ = 0;
			tr = _loc2_.firstChild;
			_loc25_ = 0;

			while ( _loc25_ < _length )
			{
				currentRow = _loc4_[ _loc25_ ];
				_loc45_ = null;
				_loc29_ = 0;

				while ( _loc29_ < _loc6_ )
				{
					currentCol = _loc3_[ _loc29_ ];

					if ( currentCol != undefined )
					{
						tdCond1 = ( currentCol.rowSpanCountdown == 0 ) || ( currentCol.rowSpanCountdown == undefined );
					}

					if (( currentCol == undefined ) || ( tdCond1 ))
					{
						_loc68_ = 0;
						_loc69_ = 0;
						_loc45_ = _loc45_ == null ? tr.firstChild : _loc45_.nextSibling;
						_cellList[ cellMcIdx ].tf.autoSize = TextFieldAutoSize.NONE;
						currentCol.rowSpanCountdown = _loc45_.attributes.rowspan == undefined ? 0 : Number( _loc45_.attributes.rowspan ) - 1;
						_cellList[ cellMcIdx ].x = currentCol.xMin;
						_cellList[ cellMcIdx ].y = currentRow.yMin;
						colspan = _loc45_.attributes.colspan == undefined ? 1 : Number( _loc45_.attributes.colspan );

						while ( colspan > 0 )
						{
							_loc29_++;
							colspan--;
						}
						rowspan = _loc45_.attributes.rowspan == undefined ? 0 : Number( _loc45_.attributes.rowspan ) - 1;
						_loc70_ = rowspan;

						if ( _loc29_ >= _loc6_ )
						{
							_loc33_ = _loc3_[ _loc6_ - 1 ].xMax - _loc20_ - _loc21_ - _loc19_;
						}
						else
						{
							_loc33_ = _loc3_[ _loc29_ - 1 ].xMax - _loc22_;
						}
						_loc71_ = _loc25_ + _loc70_;

						if ( _loc71_ >= _length - 1 )
						{
							_loc34_ = _loc4_[ _length - 1 ].yMax - _loc20_ - _loc21_ - _loc19_;
						}
						else
						{
							_loc34_ = _loc4_[ _loc71_ ].yMax - _loc22_;
						}
						_loc72_ = _loc33_ - _cellList[ cellMcIdx ].x;
						_loc73_ = _loc34_ - _cellList[ cellMcIdx ].y;
						_loc68_ = _loc72_;
						_loc69_ = _loc73_;
						_cellList[ cellMcIdx ].mywidth = _loc68_;
						_cellList[ cellMcIdx ].myheight = _loc69_;
						drawObject = new Object();
						drawObject.x1 = _cellList[ cellMcIdx ].tf.x - ( _loc19_ + _loc21_ );
						drawObject.y1 = _cellList[ cellMcIdx ].tf.y - ( _loc19_ + _loc21_ );
						drawObject.nwidth = _loc68_ + 2 * ( _loc19_ + _loc21_ );
						drawObject.nheight = _loc69_ + 2 * ( _loc19_ + _loc21_ );
						drawObject.border = _loc21_;
						drawObject.borderalpha = _cellList[ cellMcIdx ].borderAlpha;
						drawObject.bordercolor = _cellList[ cellMcIdx ].borderColor;
						drawObject.bgalpha = _cellList[ cellMcIdx ].bgAlpha;
						drawObject.bgcolor = _cellList[ cellMcIdx ].bgColor;
						drawCell( _cellList[ cellMcIdx ], drawObject );
						_cellList[ cellMcIdx ].tf.width = _loc68_;
						_cellList[ cellMcIdx ].tf.height = _loc69_;
						_cellList[ cellMcIdx ].visited = 1;
						cellMcIdx++;
					}
					else
					{
						currentCol.rowSpanCountdown--;
						_loc29_++;
					}
				}
				tr = tr.nextSibling;
				_loc25_++;
			}
			_loc35_ = new Array();
			_loc36_ = _loc3_[ _loc6_ - 1 ].xMax;
			_loc37_ = 0;
			_loc38_ = 0;

			while ( _loc38_ < cellNo )
			{
				_loc74_ = _cellList[ _loc38_ ];

				if ( _loc74_.visited == 0 )
				{
					if ( _loc35_[ _loc74_.rowid ] == undefined )
					{
						_loc35_[ _loc74_.rowid ] = new Object();
						_loc35_[ _loc74_.rowid ].xMax = _loc3_[ _loc6_ - 1 ].xMax + _loc21_ + _loc19_;
					}
					rowspan = _loc74_.node.attributes.rowspan > 1 ? Number( _loc74_.node.attributes.rowspan ) : 1;
					_loc75_ = _loc74_.rowid + rowspan - 1;

					if ( _loc75_ == _length - 1 )
					{
						_loc34_ = _loc4_[ _loc75_ ].yMax - ( _loc20_ + _loc21_ + _loc19_ );
					}
					else
					{
						_loc34_ = _loc4_[ _loc75_ ].yMax - ( _loc20_ + 2 * ( _loc21_ + _loc19_ ));
					}
					_loc74_.tf.autoSize = false;
					_loc74_.tf.wordWrap = true;
					_loc74_.x = _loc35_[ _loc74_.rowid ].xMax;
					_loc74_.y = _loc4_[ _loc74_.rowid - 1 ].yMax;
					_loc74_.height = _loc34_ - _loc74_.y;
					_loc74_.width = _loc3_[ _loc6_ - 1 ].width;

					if ( _loc74_.tf.textWidth < _loc74_.tf.width )
					{
						_loc74_.tf.width = _loc74_.tf.textWidth + 5;
					}
					_loc35_[ _loc74_.rowid ].xMax = _loc35_[ _loc74_.rowid ].xMax + _loc74_.tf.width;

					if ( _loc75_ > _length - 1 )
					{
						_loc75_ = _length - 1;
					}
					j = _loc74_.rowid + 1;

					while ( j <= _loc75_ )
					{
						if ( _loc35_[ j ] == undefined )
						{
							_loc35_[ j ] = new Object();
						}
						_loc35_[ j ].xMax = _loc35_[ _loc74_.rowid ].xMax + _loc22_;
						j++;
					}

					if ( _loc74_.rowid == _length - 1 )
					{
						_loc35_[ _length - 1 ].xMax = _loc35_[ _length - 1 ].xMax + _loc22_;
					}

					if ( _loc35_[ _loc74_.rowid ].xMax > _loc36_ )
					{
						_loc36_ = _loc35_[ _loc74_.rowid ].xMax;
					}
					_loc74_.visited = 1;
					_loc37_++;
					drawObject = new Object();
					drawObject.x1 = _loc74_.tf.x - ( _loc19_ + _loc21_ );
					drawObject.y1 = _loc74_.tf.y - ( _loc19_ + _loc21_ );
					drawObject.nwidth = _loc74_.tf.width + 2 * ( _loc19_ + _loc21_ );
					drawObject.nheight = _loc74_.tf.height + 2 * ( _loc19_ + _loc21_ );
					drawObject.border = _loc21_;
					drawObject.borderalpha = _loc74_.borderAlpha;
					drawObject.bordercolor = _loc74_.borderColor;
					drawObject.bgalpha = _loc74_.bgAlpha;
					drawObject.bgcolor = _loc74_.bgColor;
					drawCell( _loc74_, drawObject );
				}
				_loc38_++;
			}

			if ( _loc37_ > 0 )
			{
				_loc36_ = _loc36_ + ( _loc20_ + _loc21_ + _loc19_ );
			}
			_loc39_ = _loc4_[ _length - 1 ].yMax + _loc14_;
			_loc40_ = _loc36_ + _loc14_;
			drawObject = new Object();
			drawObject.x1 = 0;
			drawObject.y1 = 0;
			drawObject.nwidth = _loc40_;
			drawObject.nheight = _loc39_;
			drawObject.border = _loc14_;
			drawObject.borderalpha = _loc16_;
			drawObject.bordercolor = _loc15_;
			drawObject.bgalpha = _loc18_;
			drawObject.bgcolor = _loc17_;
			drawCell( this, drawObject );
			_pageWidth = _loc40_;
			_pageHeight = _loc39_;
			adjustClipper();
			dispatchEvent( new Event( TABLE_RENDERED_EVENT ));
		}

		private function convertASFunction( param1 : String ) : String
		{
			var _functionArray : Array;
			var _result : String = "";
			var _f : String;
			_functionArray = param1.split( "asfunction:" );
			var i : int = 0;

			while ( i < _functionArray.length )
			{
				_f = _functionArray[ i ];

				if ( i == _functionArray.length - 1 )
				{
					_result = _result + _f;
				}
				else
				{
					_result = _result + ( _f + "asfunction:functionCall," );
				}
				i++;
			}
			return _result;
		}

		private function drawCell( param1 : MovieClip, param2 : Object ) : void
		{
			var _loc3_ : Number = param2.x1;
			var _loc4_ : Number = param2.y1;
			var _loc5_ : Number = param2.nwidth;
			var _loc6_ : Number = param2.nheight;
			var _loc7_ : Number = param2.border;
			param1.graphics.clear();
			drawCellBorders( param1, _loc3_, _loc4_, _loc5_, _loc6_, param2.bordercolor, param2.borderalpha, _loc7_ );
			var _loc8_ : Number = _loc3_ + _loc7_;
			var _loc9_ : Number = _loc4_ + _loc7_;
			var _loc10_ : Number = _loc5_ - 2 * _loc7_;
			var _loc11_ : Number = _loc6_ - 2 * _loc7_;
			drawCellBackground( param1, _loc8_, _loc9_, _loc10_, _loc11_, param2.bgcolor, param2.bgalpha );
		}

		private function drawCellBackground( param1 : MovieClip, param2 : Number, param3 : Number, param4 : Number, param5 : Number, param6 : Number, param7 : Number ) : *
		{
			drawCellRect( param1, param2, param3, param4, param5, param6, param7 );
		}

		private function drawCellBorders( cellRenderer : MovieClip, param2 : Number, param3 : Number, param4 : Number, param5 : Number, color : Number, alpha : Number, param8 : Number ) : *
		{
			var _loc9_ : Number = param4;
			var _loc10_ : Number = param8;
			drawCellRect( cellRenderer, param2, param3, _loc9_, _loc10_, color, alpha );
			var _loc11_ : Number = param2 + ( param4 - param8 );
			var _loc12_ : Number = param3 + param8;
			_loc9_ = param8;
			_loc10_ = param5 - 2 * param8;
			drawCellRect( cellRenderer, _loc11_, _loc12_, _loc9_, _loc10_, color, alpha );
			var _loc13_ : Number = param2;
			var _loc14_ : Number = param3 + ( param5 - param8 );
			_loc9_ = param4;
			_loc10_ = param8;
			drawCellRect( cellRenderer, _loc13_, _loc14_, _loc9_, _loc10_, color, alpha );
			var _loc15_ : Number = param2;
			var _loc16_ : Number = param3 + param8;
			_loc9_ = param8;
			_loc10_ = param5 - 2 * param8;
			drawCellRect( cellRenderer, _loc15_, _loc16_, _loc9_, _loc10_, color, alpha );
		}

		private function drawCellRect( cellRenderer : MovieClip, pX : Number, pY : Number, pWidth : Number, pHeight : Number, color : Number, alpha : Number ) : void
		{
			cellRenderer.graphics.beginFill( color, alpha );
			cellRenderer.graphics.drawRect( pX, pY, pWidth, pHeight );
			cellRenderer.graphics.endFill();
		}

		private function functionCall( param1 : String ) : void
		{
			// wait to get it working to figure this one out
			var _loc2_ : Array = param1.split( "," );
			var _loc3_ : * = undefined;
			var _loc4_ : * = undefined;
			var _loc5_ : * = undefined;
			_loc3_ = _loc2_[ 0 ];
			_loc4_ = _loc2_[ 1 ];
			_loc5_ = functionMaps[ _loc3_ ];
			_loc5_[ _loc3_ ]( _loc4_ );
		}

		private function getBestValue( ... args ) : String
		{
			var i : int = 0;
			var _loc3_ : String;
			var _loc4_ : Boolean;

			while ( i < args.length )
			{
				_loc3_ = args[ i ];
				_loc4_ = !(( _loc3_ == undefined ) || ( _loc3_ == null ));

				if ( _loc4_ )
				{
					return _loc3_;
				}
				i++;
			}

			return null;
		}

		private function init() : void
		{
			_pageWidth = width;
			_pageHeight = height;
			scaleX = 1;
			scaleY = 1;
			removeChildAt( 0 );
			styleSheet = new StyleSheet();
			_cellList = new Vector.<FtTableRendererBoxMc>();
			cellNo = 0;
		}

		private function linkHandler( param1 : TextEvent ) : *
		{
			functionCall( param1.text );
		}

		private function loadCSSFile( url : String ) : void
		{
			var _loc3_ : * = new URLLoader();
			var _loc2_ : URLRequest = new URLRequest( url );
			_loc3_.addEventListener( Event.COMPLETE, onCSSFileLoaded );
			_loc3_.load( _loc2_ );
		}

		private function loadHTMLURL( url : String ) : void
		{
			var _xmlLoader_ : URLLoader = new URLLoader();
			var _urlRequest : URLRequest = new URLRequest( url );

			removeCells();

			_isDirty = true;

			this._xmlDocument = new XMLDocument();
			this._xmlDocument2 = new XMLDocument();
			this._xmlDocument.ignoreWhite = true;
			this._xmlDocument2.ignoreWhite = true;

			_xmlLoader_.load( _urlRequest );
			_xmlLoader_.addEventListener( ProgressEvent.PROGRESS, onProgress );
			_xmlLoader_.addEventListener( Event.COMPLETE, onComplete );
			_xmlLoader_.addEventListener( IOErrorEvent.IO_ERROR, onIOError );
		}

		private function onCSSFileLoaded( param1 : Event ) : void
		{
			styleSheet.parseCSS( param1.target.data );
			buildTable( this._xmlDocument2 );
		}

		private function onComplete( param1 : Event ) : void
		{
			var _loc2_ : URLLoader = param1.target as URLLoader;

			if ( _loc2_ != null )
			{
				this._xmlDocument.parseXML( _loc2_.data );
				buildHTMLPage( this._xmlDocument );
			}
			else
			{
				trace( "Loader is not a URLLoader!" );
			}
		}

		private function onIOError( param1 : Event ) : void
		{
			trace( "IOERROR (maybe table file does not exit or have an incorrect name)" );
		}

		private function onProgress( param1 : Event ) : void
		{
			_bytesLoaded = param1.target.bytesLoaded;
			_bytesTotal = param1.target.bytesTotal;
		}

		private function pp_getRGB( param1 : * ) : String
		{
			var length : int;
			var _loc2_ : String = param1.toString( 16 );
			length = 6 - _loc2_.length;
			var i : int = 0;

			while ( i < length )
			{
				_loc2_ = "0" + _loc2_;
				i++;
			}
			return _loc2_;
		}

		private function qSnFppLVlrfGyeo( text : String, textWidth : Number ) : Number
		{
			var _loc3_ : Array = null;
			var _loc4_ : Number = 0;
			var _loc5_ : * = undefined;
			var _loc6_ : * = undefined;
			var _loc7_ : Number = 0;
			var i : int = 0;
			var _loc9_ : * = undefined;
			_loc3_ = text.split( " " );
			_loc5_ = 1;
			_loc6_ = 0;

			while ( i < _loc3_.length )
			{
				_loc9_ = _loc3_[ i ].length;
				_loc5_ = _loc5_ + _loc9_;

				if ( _loc9_ > _loc4_ )
				{
					_loc4_ = _loc9_;
				}
				i++;
			}
			_loc6_ = textWidth / _loc5_;
			_loc7_ = _loc4_ * _loc6_ + 2 * _loc6_;
			return _loc7_;
		}

		private function textFieldChangeHandler( param1 : Event ) : void
		{
			updateTable();
		}

		private function zeroRowSpanCountDown( param1 : Array ) : void
		{
			var colID : int = 0;

			while ( colID < param1.length )
			{
				param1[ colID ].rowSpanCountdown = 0;
				colID++;
			}
		}
	}
}
