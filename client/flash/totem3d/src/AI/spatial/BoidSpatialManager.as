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
	
	import totem.totem_internal;
	import totem.components.spatial.ISpatial2D;
	import totem.events.RemovableEventDispatcher;
	
	import totem3d.components.spatial.ISpatial3D;

	public class BoidSpatialManager extends RemovableEventDispatcher
	{

		private var boidObjectList : BoidIterator = new BoidIterator();

		public function BoidSpatialManager()
		{

		}

		override public function destroy() : void
		{
			super.destroy();

			boidObjectList.destroy();
			boidObjectList = null;
		}

		public function getDistanceToNearestEntity( prop : Object, type : String, boidComponent : Boid2DComponent ) : Number
		{
			//var dist : Number = boidComponent.neighborDistance * boidComponent.neighborDistance;

			//var boidList : Vector.<Boid2DComponent> = boidCategories[ boidComponent.type ];

			var dist : Number = Number.POSITIVE_INFINITY;

			var xSep : Number;
			var ySep : Number;
			var entityDist : Number;
			var neighborComponent : ISpatial3D;

			while ( boidObjectList.hasNext())
			{
				neighborComponent = boidObjectList.next();

				if ( neighborComponent.getProperty( prop ) == type )
				{
					// lets inline this with no sq root.  as fast as it gets
					xSep = boidComponent.z - neighborComponent.z;
					ySep = boidComponent.x - neighborComponent.x;
					entityDist = Math.sqrt( ySep * ySep + xSep * xSep );

					if ( entityDist < dist )
					{
						dist = entityDist;
					}
				}
			}

			boidObjectList.reset();

			return ( dist == Number.POSITIVE_INFINITY ) ? 0 : dist;
		}

		/**
		 *
		 * @param list
		 * @param boidComponent
		 *
		 */
		public function getEntitiesOfSameType( list : Vector.<Boid2DComponent>, boidComponent : Boid2DComponent ) : void
		{
			// serach distance to be considered a neighbor
			var dist : Number = boidComponent.neighborDistance * boidComponent.neighborDistance;

			//var boidList : Vector.<Boid2DComponent> = boidCategories[ boidComponent.type ];

			var xSep : Number;
			var ySep : Number;
			var entityDist : Number;
			var neighborComponent : ISpatial3D;

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
			// serach distance to be considered a neighbor
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

		public function getNearestEntityOfType( prop : Object, type : String, boidComponent : Boid2DComponent ) : ISpatial3D
		{
			var dist : Number = Number.POSITIVE_INFINITY;

			var xSep : Number;
			var ySep : Number;
			var entityDist : Number;
			var neighborComponent : ISpatial3D;
			var result : ISpatial3D;

			while ( boidObjectList.hasNext())
			{
				neighborComponent = boidObjectList.next();

				if ( neighborComponent.getProperty( prop ) == type )
				{
					// lets inline this with no sq root.  as fast as it gets
					xSep = boidComponent.z - neighborComponent.z;
					ySep = boidComponent.x - neighborComponent.x;
					entityDist = Math.sqrt( ySep * ySep + xSep * xSep );

					if ( entityDist < dist )
					{
						result = neighborComponent;
						dist = entityDist;
					}
				}
			}

			boidObjectList.reset();

			return result;

		}

		public function getSpatialList() : BoidIterator
		{
			return boidObjectList;
		}

		public function hasItem( item : Boid2DComponent ) : Boolean
		{
			return boidObjectList.hasItem( item );
		}

		totem_internal function addSpatialObject( object : ISpatial3D ) : void
		{
			boidObjectList.add( object );
		}
		
		totem_internal function removeSpatialObject( object:ISpatial3D):void
		{
			boidObjectList.removeItem( object );			
		}
	}
}

