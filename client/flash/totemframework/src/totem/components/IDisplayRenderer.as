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

package totem.components
{
	import flash.geom.Vector3D;

	public interface IDisplayRenderer
	{

		function rotateX( value : Number, local : Boolean = true, pivotPoint : Vector3D = null  ) : void

		function rotateY( value : Number, local : Boolean = true, pivotPoint : Vector3D = null  ) : void

		function rotateZ( value : Number, local : Boolean = true, pivotPoint : Vector3D = null  ) : void

		function setPosition( x : Number, y : Number, z : Number ) : void;

		function setRotation( x : Number, y : Number, z : Number ) : void;

		function setScale( _scaleX : Number, _scaleY : Number, _scaleZ : Number ) : void;

		function translateX( value : Number ) : void

		function translateY( value : Number ) : void

		function translateZ( value : Number ) : void
	}
}
