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

package totem3d.components.spatial
{

	import totem.components.spatial.ISpatial2D;

	public interface ISpatial3D extends ISpatial2D
	{

		function get z() : Number;

		function set z( value : Number ) : void;
	}
}
