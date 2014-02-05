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

package totem.components.display
{

	import totem.math.Vector2D;

	public interface IDisplay2DRenderer
	{

		function get alpha() : Number;

		function set alpha( value : Number ) : void;

		function get layerIndex() : int

		function set layerIndex( value : int ) : void;

		function get position() : Vector2D;

		function set position( value : Vector2D ) : void;

		function setPosition( x : Number, y : Number ) : void;

		function setRotation( value : Number ) : void;

		function setScale( _scaleX : Number, _scaleY : Number ) : void;

		function translateX( value : Number ) : void;

		function translateY( value : Number ) : void;

		function get zIndex() : int;

		function set zIndex( value : int ) : void;
	}
}
