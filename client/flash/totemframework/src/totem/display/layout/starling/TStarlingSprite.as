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

package totem.display.layout.starling
{

	import starling.display.Sprite;

	import totem.core.IDestroyable;

	public class TStarlingSprite extends Sprite implements IDestroyable
	{

		protected var _isDestroyed : Boolean;

		private var _enabled : Boolean;

		public function TStarlingSprite()
		{
			super();
			
			touchable = false;
		}

		/**
		 * @return	Array of all of the sprite's children
		 */
		public function get children() : Array
		{
			var children : Array = new Array();

			for ( var i : int = 0; i < numChildren; i++ )
			{
				children.push( getChildAt( i ));
			}
			return children;
		}

		/**
		 {@inheritDoc}

		 Calling <code>destroy()</code> on a CASA display object also removes it from its current parent.
		 */
		public function destroy() : void
		{
			dispose();
		}

		public function get destroyed() : Boolean
		{
			return _isDestroyed;
		}

		override public function dispose() : void
		{
			super.dispose();

			this._isDestroyed = true;

			removeChildren();

			if ( this.parent != null )
				this.parent.removeChild( this );
		}

		/**
		 * @return	Whether or not this sprite is enabled
		 */
		public function get enabled() : Boolean
		{
			return _enabled;
		}

		public function set enabled( a_enabled : Boolean ) : void
		{
			_enabled = a_enabled;
		}

		/**
		 Removes and optionally destroys children of the <code>CasaSprite</code> then destroys itself.

		 @param destroyChildren: If a child implements {@link IDestroyable} call its {@link IDestroyable#destroy destroy} method <code>true</code>, or don't destroy <code>false</code>; defaults to <code>false</code>.
		 @param recursive: Call this method with the same arguments on all of the children's children (all the way down the display list) <code>true</code>, or leave the children's children <code>false</code>; defaults to <code>false</code>.
		 */
		public function removeChildrenAndDestroy( destroyChildren : Boolean = false, recursive : Boolean = false ) : void
		{
			removeChildren();
			this.destroy();
		}
	}
}

