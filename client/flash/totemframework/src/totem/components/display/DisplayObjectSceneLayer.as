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

package totem.components.display
{

	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;

	import totem.display.layout.starling.TStarlingSprite;

	/**
	 * Layer within a DisplayObjectScene which manages a list of
	 * DisplayObjectRenderers. The layer is responsible for keeping
	 * itself sorted. This is also a good site for custom render
	 * effects, parallaxing, etc.
	 */
	public class DisplayObjectSceneLayer extends TStarlingSprite
	{
		/**
		 * Default sort function, which orders by zindex.
		 */
		public static function defaultSortFunction( a : IDisplay2DRenderer, b : IDisplay2DRenderer ) : int
		{
			return a.zIndex - b.zIndex;
		}

		public var depth : Number = 0;

		/**
		 * Array.sort() compatible function used to determine draw order.
		 */
		public var drawOrderFunction : Function;

		public var parentSprite : Sprite;

		/**
		 * All the renderers in this layer.
		 */
		public var rendererList : Vector.<IDisplay2DRenderer> = new Vector.<IDisplay2DRenderer>();

		public var update : Boolean;

		/**
		 * Set to true when we need to resort the layer.
		 */
		internal var needSort : Boolean = false;

		public function DisplayObjectSceneLayer( name : String, layer : Number = 0 )
		{
			super();

			drawOrderFunction = defaultSortFunction;

			depth = layer;

			this.name = name;

			touchable = false;

			addEventListener( Event.ADDED_TO_STAGE, handleAddToStage );
		}

		public function add( dor : IDisplay2DRenderer ) : void
		{
			var idx : int = rendererList.indexOf( dor );

			if ( idx != -1 )
				throw new Error( "Already added!" );

			rendererList.push( dor );
			addChild( dor.displayObject );
			needSort = true;
			onRender();
		}

		override public function destroy() : void
		{
			super.destroy();

			rendererList.length = 0;
			rendererList = null;

			parentSprite = null;
		}

		/**
		 * Indicates this layer is dirty and needs to resort.
		 */
		public function markDirty() : void
		{
			needSort = true;
		}

		public function onRender() : void
		{
			if ( needSort || update )
			{
				updateOrder();
				needSort = false;
			}
		}

		public function remove( dor : IDisplay2DRenderer ) : void
		{
			var idx : int = rendererList.indexOf( dor );

			if ( idx == -1 )
				return;
			rendererList.splice( idx, 1 );
			removeChild( dor.displayObject );
		}

		public function updateOrder() : void
		{
			// Get our renderers in order.
			// TODO: A bubble sort might be more efficient in cases where
			// things don't change order much.
			rendererList.sort( drawOrderFunction );

			// Apply the order.
			//var updated : int = 0;

			var i : int = 0;
			var l : int = rendererList.length;
			var d : DisplayObject;

			for ( ; i < l; ++i )
			{
				d = rendererList[ i ].displayObject;

				if ( getChildAt( i ) == d )
					continue;

				//updated++;
				setChildIndex( d, i );

			}

			// This is useful if you suspect you're changing order too much.

			//trace("Reordered " + updated + " items," + " ,layer: " + name );
		}

		protected function handleAddToStage( eve : Event ) : void
		{
			removeEventListener( Event.ADDED_TO_STAGE, handleAddToStage );
		}

		private function sortFunction( objx : IDisplay2DRenderer, objy : IDisplay2DRenderer ) : Number
		{
			if ( objx.zIndex > objy.zIndex )
			{
				return 1;
			}
			else if ( objx.zIndex < objy.zIndex )
			{
				return -1;
			}
			return 0;
		}
	}
}
