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

package AI.spatial
{

	import AI.boid.Boid2DComponent;

	import flash.utils.Dictionary;

	import totem.components.spatial.ISpatialObject;
	import totem.events.RemovableEventDispatcher;

	public class BoidSpatialManager extends RemovableEventDispatcher
	{

		private var boidCategories : Dictionary;

		private var boidObjectList : BoidIterator = new BoidIterator();

		public function BoidSpatialManager()
		{
			boidCategories = new Dictionary;
		}

		public function addSpatialObject( object : ISpatialObject ) : void
		{
			boidObjectList.add( object );
		}

		override public function destroy() : void
		{
			super.destroy();

			boidObjectList.destroy();
		}

		public function getCostToClosestItem( type : String, boidComponent : Boid2DComponent  ) : Number
		{
			return 0;
		}

		/**
		 *
		 * @param list
		 * @param boidComponent
		 *
		 */
		public function getEntitiesOfSameType( list : Vector.<Boid2DComponent>, boidComponent : Boid2DComponent ) : void
		{
			var dist : Number = boidComponent.neighborDistance * boidComponent.neighborDistance;

			//var boidList : Vector.<Boid2DComponent> = boidCategories[ boidComponent.type ];

			var xSep : Number;
			var ySep : Number;
			var entityDist : Number;
			var neighborComponent : ISpatialObject;

			while ( boidObjectList.hasNext())
			{
				neighborComponent = boidObjectList.next();
				// lets inline this with no sq root.  as fast as it gets
				xSep = boidComponent.y - neighborComponent.y;
				ySep = boidComponent.x - neighborComponent.x;
				entityDist = ySep * ySep + xSep * xSep;

				if ( entityDist < dist )
				{
					list.push( neighborComponent );
				}
			}

			boidObjectList.reset();
		}

		public function getFirstBoidOfType( type : String, boidComponent : Boid2DComponent ) : Boid2DComponent
		{
			var dist : Number = boidComponent.neighborDistance * boidComponent.neighborDistance;

			var closestBoid : Boid2DComponent = null

			var boidList : Vector.<Boid2DComponent>; // = boidCategories[ evade ];

			if ( boidList )
			{
				var smallestDist : Number = Number.POSITIVE_INFINITY;

				var xSep : Number;
				var ySep : Number;
				var entityDist : Number;
				var neighborComponent : Boid2DComponent;

				var l : int = boidList.length;

				for ( var i : int = 0; i < l; ++i )
				{
					neighborComponent = boidList[ i ];
					// lets inline this with no sq root.  as fast as it gets
					xSep = boidComponent.y - neighborComponent.y;
					ySep = boidComponent.x - neighborComponent.x;
					entityDist = ySep * ySep + xSep * xSep;

					if ( entityDist < dist && entityDist < smallestDist )
					{
						closestBoid = neighborComponent;
						smallestDist = entityDist;
					}
				}
			}

			return closestBoid;
		}

		public function getNearestEntityOfType( evade : String, boidComponent : Boid2DComponent ) : Vector.<Boid2DComponent>
		{
			return null;
		}

		public function getSpatialList() : BoidIterator
		{
			return boidObjectList;
		}

		public function hasItem( item : Boid2DComponent ) : Boolean
		{
			return boidCategories[ item.node ] != null;
		}

		public function insert( item : Boid2DComponent ) : Boolean
		{
			var list : Vector.<Boid2DComponent>;

			if ( !boidCategories[ item.node ])
			{
				boidCategories[ item.node ] = new Vector.<Boid2DComponent>();
			}

			list = boidCategories[ item.node ];
			var idx : int = list.indexOf( item );

			if ( idx < 0 )
			{
				list.push( item );
			}

			return true;
		}

		public function removeItem( item : Boid2DComponent ) : Boolean
		{
			if ( boidCategories[ item.node ])
			{
				var list : Vector.<Boid2DComponent> = boidCategories[ item.node ];
				var idx : int = list.indexOf( item );

				if ( idx > -1 )
				{
					list.splice( idx, 1 );
					return true;
				}
			}
			return false;
		}
	}
}

