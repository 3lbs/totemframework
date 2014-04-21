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

/*******************************************************************************
 * Smash Engine
 * Copyright (C) 2009 Smash Labs, LLC
 * For more information see http://www.Smashengine.com
 *
 * This file is licensed under the terms of the MIT license, which is included
 * in the License.html file at the root directory of this SDK.
 ******************************************************************************/
package ladydebug
{

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.StageOrientationEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.Timer;

	import totem.core.input.simple.KeyboardKey;
	import totem.monitors.promise.wait;

	use namespace ladydebug_internal;

	/**
	 * UI to display Logger output and process simple commands from the user.
	 * Commands are registered via ConsoleCommandManager.
	 */
	//, ITicked, ITotemSystem
	public class ConsoleMobile extends Sprite implements ILogAppender
	{

		private static var _instance : ConsoleMobile;

		public static function getIntance() : ConsoleMobile
		{
			return _instance ||= new ConsoleMobile( new ConsoleSingletonEnforcer());
		}

		protected static function generateIndent( indent : int ) : String
		{
			var str : String = "";

			for ( var i : int = 0; i < indent; i++ )
			{
				// Add 2 spaces for indent
				str += "  ";
			}
			return str;
		}

		public var showStackTrace : Boolean = true;

		public var verbosity : int = 0;

		protected var _consoleHistory : Array = [];

		protected var _currentCommandManager : ConsoleCommandManager = null;

		protected var _dirtyConsole : Boolean = true;

		protected var _height : uint = 150;

		protected var _historyIndex : uint = 0;

		protected var _input : TextField;

		protected var _maxLength : uint = 200000;

		protected var _messageQueue : Array = [];

		protected var _outputBitmap : Bitmap;

		protected var _truncating : Boolean = false;

		protected var _width : uint = 500;

		protected var bottomLineIndex : int = int.MAX_VALUE;

		protected var glyphCache : GlyphCache = new GlyphCache();

		protected var keyBindings : Vector.<KeyBindingEntry> = new Vector.<KeyBindingEntry>();

		protected var logCache : Array = [];

		protected var tabCompletionCurrentEnd : int = 0;

		protected var tabCompletionCurrentOffset : int = 0;

		protected var tabCompletionCurrentStart : int = 0;

		protected var tabCompletionPrefix : String = "";

		private var _initalized : Boolean;

		private var debugCommandMap : Vector.<DebugCommand>;

		private var debugTextField : TextField;

		private var ownerStage : Stage;

		private var pressPosition : Point = new Point();

		private var pressedTime : int;

		private var testPosition : Point = new Point();

		private var timer : Timer;

		public function ConsoleMobile( enforcer : ConsoleSingletonEnforcer ) : void
		{
			if ( !enforcer )
				throw new Error( "Cannot instantiate a singleton class. Use static getInstance instead." );

		}

		public function activate() : void
		{
			layout();
			_input.text = "";
			addListeners();
			wait( 5, function() : void
			{
				ownerStage.focus = _input;
			});
		}

		public function addLogMessage( level : String, loggerName : String, message : String ) : void
		{
			var color : String = LogColor.getColor( level );

			// Cut down on the logger level if verbosity requests.
			if ( verbosity < 2 )
			{
				var dotIdx : int = loggerName.lastIndexOf( "::" );

				if ( dotIdx != -1 )
					loggerName = loggerName.substr( dotIdx + 2 );
			}
			// Split message by newline and add to the list.
			var messages : Array = message.split( "\n" );

			for each ( var msg : String in messages )
			{
				var text : String = (( verbosity > 0 ) ? level + ": " : "" ) + loggerName + " - " + msg;
				logCache.push({ "color": parseInt( color.substr( 1 ), 16 ), "text": text });
			}
			_dirtyConsole = true;
		}

		public function closeConsole() : void
		{
			deactivate();
			this.stage.removeChild( this );
		}

		public function get currentCommandManager() : ConsoleCommandManager
		{
			return _currentCommandManager;
		}

		public function deactivate() : void
		{
			removeListeners();
			ownerStage.focus = ownerStage;
		}

		public function destroy() : void
		{
			removeListeners();

			timer.removeEventListener( TimerEvent.TIMER_COMPLETE, handleOnTick );
			timer.stop();
			timer = null;

			if ( debugCommandMap )
				while ( debugCommandMap.length > 0 )
					debugCommandMap.pop().destroy();

			ownerStage = null;
		}

		public function getScreenHeightInLines() : int
		{
			var roundedHeight : int = _outputBitmap.bitmapData.height;
			return Math.floor( roundedHeight / glyphCache.getLineHeight());
		}

		public function initialize( stage : Stage ) : void
		{

			if ( _initalized )
				return;

			_initalized = true;

			name = "Console";
			this.ownerStage = stage;

			addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
			addEventListener( Event.REMOVED_FROM_STAGE, onRemovedFromStage );

			if ( stage && stage.autoOrients )
			{
				stage.addEventListener( StageOrientationEvent.ORIENTATION_CHANGE, onOrientationChange );
			}

			Logger.registerListener( this );
			Logger.startup( stage );
			timer = new Timer( 1000 );
			timer.addEventListener( TimerEvent.TIMER, handleOnTick );
			timer.start();

			// Set up the default console command manager.
			_currentCommandManager = new ConsoleCommandManager();
			// Set up some handy helper commands.
			_currentCommandManager.init();
			_currentCommandManager.registerCommand( "exit", toggleConsole, "Hides the console." );

			/*_currentCommandManager.registerCommand( "cd", changeDirectory, ".. to go up to parent, otherwise index or name to change to subgroup." );
			_currentCommandManager.registerCommand( "ls", listDirectory, "Show the SmashGroups in the current SmashGroup." );*/
			//_currentCommandManager.registerCommand( "tree", tree, "Dump all objects in current group or below." );
			//_currentCommandManager.registerCommand( "fps", showFps, "Toggle FPS/Memory display." );
			//_currentCommandManager.registerCommand( "profilerOn", profilerOn, "Turn profiler on." );
			//_currentCommandManager.registerCommand( "profilerOff", profilerOff, "Turn profiler off and dump results." );

			//stage.addEventListener( MouseEvent.MOUSE_DOWN, handleMouseDown );

			debugTextField = new TextField();

			debugTextField.textColor = 0xFF6600;
			debugTextField.text = "Debug Console";
			debugTextField.selectable = false;
			debugTextField.mouseEnabled = true;
			debugTextField.multiline = false;
			debugTextField.height = 20;
			debugTextField.x = 10;
			debugTextField.y = 20;

			var myformat : TextFormat = new TextFormat();
			myformat.color = 0xFF6600;
			myformat.underline = true;

			debugTextField.setTextFormat( myformat );
			debugTextField.addEventListener( MouseEvent.CLICK, handleTextClick );

			this.ownerStage.addChild( debugTextField );
		}

		public function onTick() : void
		{
			if ( ownerStage.stage )
			{
				testPosition.x = ownerStage.stage.mouseX;
				testPosition.y = ownerStage.stage.mouseY;
			}

			if ( pressedTime != 0 && pressedTime <= timer.currentCount && Point.distance( pressPosition, testPosition ) < 10 )
			{
				//toggleConsole();
				pressedTime = 0;
			}

			for ( var i : int = 0; i < keyBindings.length; i++ )
			{
				const kbe : KeyBindingEntry = keyBindings[ i ];
				/*if ( keyboardManager.wasKeyJustPressed( kbe.key.keyCode ) && kbe.isDown == false )
				{
					if ( kbe.downCommand )
						processLine( kbe.downCommand );
					kbe.isDown = true;
				}
				else if ( keyboardManager.wasKeyJustReleased( kbe.key.keyCode ) && kbe.isDown == true )
				{
					if ( kbe.upCommand )
						processLine( kbe.upCommand );
					kbe.isDown = false;
				}*/
			}

			// Don't draw if we are clean or invisible.
			if ( _dirtyConsole == false || parent == null )
				return;
			_dirtyConsole = false;
			// Figure our visible range.
			var lineHeight : int = getScreenHeightInLines() - 1;
			var startLine : int = 0;
			var endLine : int = 0;

			if ( bottomLineIndex == int.MAX_VALUE )
				startLine = LadyDebugUtil.clamp( logCache.length - lineHeight, 0, int.MAX_VALUE );
			else
				startLine = LadyDebugUtil.clamp( bottomLineIndex - lineHeight, 0, int.MAX_VALUE );
			endLine = LadyDebugUtil.clamp( startLine + lineHeight, 0, logCache.length - 1 );
			startLine--;
			// Wipe it.
			var bd : BitmapData = _outputBitmap.bitmapData;
			bd.fillRect( bd.rect, 0x0 );

			// Draw lines.
			for ( i = endLine; i >= startLine; i-- )
			{
				// Skip empty.
				if ( !logCache[ i ])
					continue;
				glyphCache.drawLineToBitmap( logCache[ i ].text, 0, _outputBitmap.height - ( endLine + 1 - i ) * glyphCache.getLineHeight() - 6, logCache[ i ].color, _outputBitmap.bitmapData );
			}
		}

		public function openConsole() : void
		{
			ownerStage.addChild( this );
			activate();
		}

		/**
		 * Take a line of console input and process it, executing any command.
		 * @param line String to parse for command.
		 */
		public function processLine( line : String ) : void
		{
			if ( !_currentCommandManager )
			{
				Logger.warn( this, "processLine", "No active ConsoleCommandManager, cannot process command '" + line + "'" );
				return;
			}
			// Match Tokens, this allows for text to be split by spaces excluding spaces between quotes.
			// TODO Allow escaping of quotes
			var pattern : RegExp = /[^\s"']+|"[^"]*"|'[^']*'/g;
			var args : Array = [];
			var test : Object = {};

			while ( test )
			{
				test = pattern.exec( line );

				if ( test )
				{
					var str : String = test[ 0 ];
					str = LadyDebugUtil.trim( str, "'" );
					str = LadyDebugUtil.trim( str, "\"" );
					args.push( str ); // If no more matches can be found, test will be null	
				}
			}

			// Look up the command.
			if ( args.length == 0 )
				return;
			var potentialCommand : ConsoleCommand = _currentCommandManager.commands[ args[ 0 ].toString().toLowerCase()];

			if ( !potentialCommand )
			{
				Logger.warn( ConsoleMobile, "processLine", "No such command '" + args[ 0 ].toString() + "'!" );
				return;
			}

			// Now call the command.
			try
			{
				potentialCommand.callback.apply( null, args.slice( 1 ));
			}
			catch ( e : Error )
			{
				if ( e is ArgumentError )
				{
					Logger.error( this, args[ 0 ], "Argument count mismatch." );
					return;
				}
				var errorStr : String = "Error: " + e.toString();

				if ( showStackTrace )
				{
					errorStr += " - " + e.getStackTrace();
				}
				Logger.error( this, args[ 0 ], errorStr );
			}
		}

		public function registerDebugCommand( command : DebugCommand ) : void
		{
			debugCommandMap ||= new Vector.<DebugCommand>();

			// save from GC
			debugCommandMap.push( command );

			currentCommandManager.registerCommand( command.name, command.execute, command.docs );
		}

		public function registerKeyBinding( keyName : String, downCommand : String, upCommand : String ) : void
		{
			// Parse the key.
		/*var key : KeyboardKey = KeyboardKey.stringToKey( keyName );

		if ( key == null || key == KeyboardKey.INVALID )
			throw new Error( "Couldn't identify key '" + key + "'!" );

		const kbe : KeyBindingEntry = new KeyBindingEntry();
		kbe.key = key;
		kbe.downCommand = downCommand;
		kbe.upCommand = upCommand;

		keyBindings.push( kbe );*/
		}

		public function get restrict() : String
		{
			return _input.restrict;
		}

		public function set restrict( value : String ) : void
		{
			_input.restrict = value;
		}

		public function toggleConsole() : void
		{
			if ( this.stage )
			{
				closeConsole();
			}
			else
			{
				openConsole();
			}
		}

		protected function addListeners() : void
		{
			_input.addEventListener( KeyboardEvent.KEY_DOWN, onInputKeyDown, false, 1, true );

			if ( this.parent )
				this.parent.addEventListener( Event.ADDED, onTop, false, 0, true );
		}

		protected function createInputField() : TextField
		{
			_input = new TextField();
			_input.type = TextFieldType.INPUT;
			_input.border = true;
			_input.borderColor = 0xCCCCCC;
			_input.multiline = false;
			_input.wordWrap = false;
			_input.condenseWhite = false;
			var format : TextFormat = _input.getTextFormat();
			format.font = "_typewriter";
			format.size = 11;
			format.color = 0xFFFFFF;
			_input.setTextFormat( format );
			_input.defaultTextFormat = format;
			_input.restrict = "^`"; // Tilde's are not allowed in the input since they close the window
			_input.name = "ConsoleInput";
			return _input;
		}

		protected function handleMouseDown( event : MouseEvent ) : void
		{
			ownerStage.addEventListener( MouseEvent.MOUSE_UP, handleMouseUp );

			pressPosition.x = event.stageX;
			pressPosition.y = event.stageY;

			pressedTime = timer.currentCount + ( this.stage ) ? 5 : 6;
		}

		protected function handleMouseUp( event : MouseEvent ) : void
		{
			pressedTime = 0;

			ownerStage.removeEventListener( MouseEvent.MOUSE_UP, handleMouseUp );
		}

		protected function handleOnTick( event : TimerEvent ) : void
		{
			onTick();
		}

		protected function handleTextClick( event : MouseEvent ) : void
		{
			toggleConsole();
		}

		protected function layout() : void
		{
			if ( !_input )
				createInputField();
			resize();
			_outputBitmap.name = "ConsoleOutput";
			addEventListener( MouseEvent.CLICK, onBitmapClick );
			addEventListener( MouseEvent.DOUBLE_CLICK, onBitmapDoubleClick );
			addChild( _outputBitmap );
			addChild( _input );
			graphics.clear();
			graphics.beginFill( 0x111111, .95 );
			graphics.drawRect( 0, 0, _width + 1, _height );
			graphics.endFill();
			// Necessary for click listeners.
			mouseEnabled = true;
			doubleClickEnabled = true;
			_dirtyConsole = true;
		}

		protected function onAddedToStage( e : Event ) : void
		{
			_outputBitmap = new Bitmap( new BitmapData( ownerStage.stageWidth, ownerStage.stageHeight, false, 0x0 ));
			layout();
			addListeners();
		}

		protected function onBitmapClick( me : MouseEvent ) : void
		{
			// Give focus to input.
			if ( ownerStage )
				ownerStage.focus = _input;
		}

		protected function onBitmapDoubleClick( me : MouseEvent = null ) : void
		{
			// Put everything into a monster string.
			var logString : String = "";

			for ( var i : int = 0; i < logCache.length; i++ )
				logString += logCache[ i ].text + "\n";
			// Copy content.
			System.setClipboard( logString );
			Logger.print( this, "Copied console contents to clipboard." );
		}

		/**
		 * Wipe the displayed console output.
		 */
		protected function onClearCommand() : void
		{
			logCache = [];
			bottomLineIndex = -1;
			_dirtyConsole = true;
		}

		protected function onInputKeyDown( event : KeyboardEvent ) : void
		{
			// If this was a non-tab input, clear tab completion state.
			if ( event.keyCode != Keyboard.TAB && event.keyCode != Keyboard.SHIFT )
			{
				tabCompletionPrefix = _input.text;
				tabCompletionCurrentStart = -1;
				tabCompletionCurrentOffset = 0;
			}

			if ( event.keyCode == Keyboard.ENTER )
			{
				// Execute an entered command.
				if ( _input.text.length <= 0 )
				{
					// display a blank line
					addLogMessage( "CMD", ">", _input.text );
					return;
				}
				// If Enter was pressed, process the command
				processCommand();
			}
			else if ( event.keyCode == Keyboard.UP )
			{
				// Go to previous command.
				if ( _historyIndex > 0 )
				{
					setHistory( _consoleHistory[ --_historyIndex ]);
				}
				else if ( _consoleHistory.length > 0 )
				{
					setHistory( _consoleHistory[ 0 ]);
				}
				event.preventDefault();
			}
			else if ( event.keyCode == Keyboard.DOWN )
			{
				// Go to next command.
				if ( _historyIndex < _consoleHistory.length - 1 )
				{
					setHistory( _consoleHistory[ ++_historyIndex ]);
				}
				else if ( _historyIndex == _consoleHistory.length - 1 )
				{
					_input.text = "";
				}
				event.preventDefault();
			}
			else if ( event.keyCode == Keyboard.PAGE_UP )
			{
				// Page the console view up.
				if ( bottomLineIndex == int.MAX_VALUE )
					bottomLineIndex = logCache.length - 1;
				bottomLineIndex -= getScreenHeightInLines() - 2;

				if ( bottomLineIndex < 0 )
					bottomLineIndex = 0;
			}
			else if ( event.keyCode == Keyboard.PAGE_DOWN )
			{
				// Page the console view down.
				if ( bottomLineIndex != int.MAX_VALUE )
				{
					bottomLineIndex += getScreenHeightInLines() - 2;

					if ( bottomLineIndex + getScreenHeightInLines() >= logCache.length )
						bottomLineIndex = int.MAX_VALUE;
				}
			}
			else if ( event.keyCode == Keyboard.TAB )
			{
				// We are doing tab searching.
				var list : Vector.<ConsoleCommand> = _currentCommandManager.getCommandList();
				// Is this the first step?
				var isFirst : Boolean = false;

				if ( tabCompletionCurrentStart == -1 )
				{
					tabCompletionPrefix = _input.text.toLowerCase();
					tabCompletionCurrentStart = int.MAX_VALUE;
					tabCompletionCurrentEnd = -1;

					for ( var i : int = 0; i < list.length; i++ )
					{
						// If we found a prefix match...
						const potentialPrefix : String = list[ i ].name.substr( 0, tabCompletionPrefix.length );

						if ( potentialPrefix.toLowerCase() != tabCompletionPrefix )
							continue;

						// Note it.
						if ( i < tabCompletionCurrentStart )
							tabCompletionCurrentStart = i;

						if ( i > tabCompletionCurrentEnd )
							tabCompletionCurrentEnd = i;
						isFirst = true;
					}
					tabCompletionCurrentOffset = tabCompletionCurrentStart;
				}

				// If there is a match, tab complete.
				if ( tabCompletionCurrentEnd != -1 )
				{
					// Update offset if appropriate.
					if ( !isFirst )
					{
						if ( event.shiftKey )
							tabCompletionCurrentOffset--;
						else
							tabCompletionCurrentOffset++;

						// Wrap the offset.
						if ( tabCompletionCurrentOffset < tabCompletionCurrentStart )
						{
							tabCompletionCurrentOffset = tabCompletionCurrentEnd;
						}
						else if ( tabCompletionCurrentOffset > tabCompletionCurrentEnd )
						{
							tabCompletionCurrentOffset = tabCompletionCurrentStart;
						}
					}
					// Get the match.
					var potentialMatch : String = list[ tabCompletionCurrentOffset ].name;
					// Update the text with the current completion, caret at the end.
					_input.text = potentialMatch;
					_input.setSelection( potentialMatch.length + 1, potentialMatch.length + 1 );
				}
				// Make sure we keep focus. TODO: This is not ideal, it still flickers the yellow box.
				var oldfr : * = ownerStage.stageFocusRect;
				ownerStage.stageFocusRect = false;
				/*timeManager.callLater( function() : void
				{
					stage.focus = _input;
					stage.stageFocusRect = oldfr;
				});*/
			}
			// KeyboardKey.TILDE.keyCode 
			else if ( event.keyCode == KeyboardKey.ESCAPE.keyCode )
			{
				// Hide the console window, have to check here due to 
				// propagation stop at end of function.
				parent.removeChild( this );
				deactivate();
			}
			_dirtyConsole = true;
			// Keep console input from propagating up to the stage and messing up the game.
			event.stopImmediatePropagation();
		}

		protected function onOrientationChange( event : Event ) : void
		{
			layout();
		}

		protected function onRemovedFromStage( e : Event ) : void
		{
		}

		protected function processCommand() : void
		{
			addLogMessage( "CMD", ">", _input.text );
			processLine( _input.text );
			_consoleHistory.push( _input.text );
			_historyIndex = _consoleHistory.length;
			_input.text = "";
			_dirtyConsole = true;
		}

		protected function removeListeners() : void
		{
			_input.removeEventListener( KeyboardEvent.KEY_DOWN, onInputKeyDown );

			if ( this.parent )
				this.parent.removeEventListener( Event.ADDED, onTop );
		}

		protected function resize() : void
		{

			if ( !_outputBitmap )
				return;

			_outputBitmap.x = 5;
			_outputBitmap.y = 0;
			_input.x = 5;

			if ( ownerStage )
			{
				_width = ownerStage.fullScreenWidth - 1;
				_height = ( ownerStage.fullScreenHeight / 3 ) * 2;
			}
			// Resize display surface.
			_outputBitmap.bitmapData.dispose();
			_outputBitmap.bitmapData = new BitmapData( _width - 10, _height - 30, false, 0x0 );
			_input.height = 18;
			_input.width = _width - 10;
			_input.y = _outputBitmap.height + 7;
			_dirtyConsole = true;
		}

		protected function setHistory( old : String ) : void
		{
		/*_input.text = old;
		timeManager.callLater( function() : void
		{
			_input.setSelection( _input.length, _input.length );
		});*/
		}

		private function onTop( event : Event ) : void
		{
			if ( event.target.parent == event.currentTarget )
				DisplayObjectContainer( event.currentTarget ).addChild( DisplayObject( this ));
		}
	}
}

class ConsoleSingletonEnforcer
{
}

class KeyBindingEntry
{

	public var downCommand : String;

	//public var key : KeyboardKey;
	public var isDown : Boolean;

	public var upCommand : String;
}
