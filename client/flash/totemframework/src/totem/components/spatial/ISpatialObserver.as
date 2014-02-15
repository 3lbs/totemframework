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

package totem.components.spatial
{

	public interface ISpatialObserver
	{
		function setPosition( x : Number, y : Number ) : void;

		function setRotation( _rotation : Number ) : void;

		function setScale( _scaleX : Number, _scaleY : Number ) : void;
	}
}
