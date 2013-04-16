package totem.display.layout
{

	import flash.display.DisplayObjectContainer;

	import avmplus.getQualifiedClassName;

	public class ScreenComposite extends TContainer implements IScreenComposite
	{

		/** @var Parent container */
		public var parentNode : IScreenComposite;

		public var depth : Number = 0;

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

				removeChild( screen );

				screen.onRemove();

				// Update remaining screens
				sortScreens();
				updateDisplay();
			}
			else
			{
				for ( var layer : int = 0; layer < screens.length; layer++ )
				{
					screens[ layer ].removeScreen( screen );
				}
			}

			return screen;
		}

		public function removeAllScreens() : void
		{
			while ( screens.length > 0 )
			{
				var screen : ScreenComposite = screens.pop();
				removeChild( screen );
				screen.onRemove();
			}

			updateDisplay();
		}

		public function hasScreen( screen : ScreenComposite ) : Boolean
		{
			return ( screens.indexOf( screen ) > -1 );
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

		public function getScreenByName( n : String ) : ScreenComposite
		{
			var s : ScreenComposite;

			for ( var i : int = 0; i < screens.length; ++i )
			{
				if ( screens[ i ].name == n )
				{
					return screens[ i ];
				}
				s = screens[ i ].getScreenByName( n );

				if ( s )
				{
					return s;
				}
			}
			return null;
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

		public function onRegister() : void
		{

		}

		public function onRemove() : void
		{
			destroy();
		}

		override public function destroy() : void
		{
			super.destroy();

			while ( screens.length > 0 )
				screens.pop().destroy();

		}
	}
}
