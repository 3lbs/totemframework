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

package totem.display.layout
{

	import flash.display.DisplayObjectContainer;

	public class ScreenComposite extends TContainer
	{

		public var depth : Number = 0;

		/** @var Parent container */
		public var parentNode : ScreenComposite;

		protected var screens : Vector.<ScreenComposite> = new Vector.<ScreenComposite>();

		public function ScreenComposite()
		{
			super();
		}

		public function addScreen( screen : ScreenComposite ) : void
		{
			if ( hasScreen( screen ))
			{
				return;
			}

			screen.parentNode = this;

			screens.push( screen );

			addChild( screen );

			sortScreens();

			if ( screen.contentHeight == 0 )
			{
				screen.contentHeight = contentHeight;
			}

			if ( screen.contentWidth == 0 )
			{
				screen.contentWidth = contentWidth;
			}

			updateDisplay();

			screen.onRegister();
		}

		override public function destroy() : void
		{

			while ( screens.length > 0 )
				screens.pop().destroy();

			if ( parentNode )
				parentNode.removeScreen( this );

			parentNode = null;

			super.destroy();
		}

		public function getScreenByName( value : String ) : ScreenComposite
		{
			var s : ScreenComposite;

			for ( var i : int = 0; i < screens.length; ++i )
			{
				if ( screens[ i ].name == value )
				{
					return screens[ i ];
				}
				s = screens[ i ].getScreenByName( value );

				if ( s )
				{
					return s;
				}
			}
			return null;
		}

		public function hasScreen( screen : ScreenComposite ) : Boolean
		{
			return ( screens.indexOf( screen ) > -1 );
		}

		public function onRegister() : void
		{
		}

		public function onRemove() : void
		{

		}

		public function removeAllScreens() : void
		{
			while ( screens.length > 0 )
			{
				var screen : ScreenComposite = screens.pop();
				removeChild( screen );
				screen.onRemove();

				screen.destroy();
			}

			updateDisplay();
		}

		public function removeFromParent() : void
		{
			if ( parentNode && this.parent )
			{
				parentNode.removeScreen( this );
			}
		}

		/**
		 * Removes a given child ScreenComposite, if it exists.
		 *
		 * @param	a_screen	ScreenComposite to remove
		 */
		public function removeScreen( screen : ScreenComposite ) : ScreenComposite
		{
			var idx : int = screens.indexOf( screen );

			if ( idx > -1 )
			{
				screens.splice( idx, 1 );

				if ( screen.parent )
					screen.parent.removeChild( screen );

				screen.onRemove();

				// Update remaining screens
				sortScreens();
				updateDisplay();
			}
			else
			{
				// go through the child screens
				for ( var layer : int = 0; layer < screens.length; layer++ )
				{
					screens[ layer ].removeScreen( screen );
				}
			}

			return screen;
		}

		public function sortScreens() : void
		{
			screens.sort( sortFunction );

			var layerIndex : int = 0;

			for ( var layer : int = 0; layer < screens.length; layer++ )
			{
				var screen : DisplayObjectContainer = screens[ layer ] as DisplayObjectContainer;
				setChildIndex( screen, layerIndex );
				layerIndex++;
			}
		}

		override public function updateDisplay() : void
		{
			super.updateDisplay();

			for ( var i : int = 0; i < screens.length; ++i )
			{
				var screen : ScreenComposite = screens[ i ] as ScreenComposite;
				screen.updateDisplay();
			}
		}

		private function sortFunction( objx : ScreenComposite, objy : ScreenComposite ) : Number
		{
			if ( objx.depth > objy.depth )
			{
				return 1;
			}
			else if ( objx.depth < objy.depth )
			{
				return -1;
			}
			return 0;
		}
	}
}
