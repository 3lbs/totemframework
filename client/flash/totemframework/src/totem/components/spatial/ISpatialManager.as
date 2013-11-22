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

package totem.components.spatial
{

	import totem.core.IDestroyable;

	public interface ISpatialManager extends IDestroyable
	{
		function addSpatialObject( object : ISpatial2D ) : void;

		function getCostToClosestItem( type : String ) : Number;

		function removeSpatialObject( object : ISpatial2D ) : void;
	}
}
