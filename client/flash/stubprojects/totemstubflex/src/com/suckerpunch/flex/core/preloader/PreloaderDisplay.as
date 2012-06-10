//------------------------------------------------------------------------------
//
//   Copyright 2011 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package com.suckerpunch.flex.core.preloader
{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	
	/**
	 *
	 * @author eddie
	 */
	public class PreloaderDisplay extends Sprite
	{
		
		public static const NAME : String = "preloaderWindow";
		
		private var suckerPunchLogo : SuckerPunchPreloader;
		
		private var preloaderComponent : PreloaderComponent;
		
		/**
		 *
		 */
		public function PreloaderDisplay()
		{
			//super ( NAME );
		}
		/*
		override protected function initialize( eve : Event ) : void
		{
			super.initialize ( eve );
		
			suckerPunchLogo = new SuckerPunchPreloader ();
			addChild ( suckerPunchLogo );
		
			preloaderComponent = new PreloaderComponent();
			addChild( preloaderComponent );
		
			_textField = preloaderComponent.progressText;
		
		
		}
		*/
		
		private var _textField : TextField;
		
		/**
		 *
		 * @param value
		 */
		public function set loadingText( value : String ) : void
		{
			if ( _textField )
				_textField.text = value;
		}
		
		/**
		 *
		 * @return texfield for precentage display
		 */
		public function get loadingTextField() : TextField
		{
			return _textField;
		}
		
		/**
		 *
		 * @param value
		 */
		public function setDownloadRSLProgress( value : Number ) : void
		{
			trace( value );
		}
		
		/**
		 *
		 * @param value
		 */
		public function setInitAppProgress( value : Number ) : void
		{
		
		}
		
		/**
		 *
		 * @param value
		 */
		public function setMainProgress( value : Number ) : void
		{
		
		}
	
	/*override public function destroy():void
	{
		super.destroy();
	
		_textField = null;
		suckerPunchLogo = null;
		preloaderComponent = null;
	}*/
	}
}

