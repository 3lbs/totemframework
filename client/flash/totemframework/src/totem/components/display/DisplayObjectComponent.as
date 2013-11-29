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
//.
3.
//------------------------------------------------------------------------------

package totem.components.display
{

	import flash.geom.Vector3D;
	
	import mx.binding.utils.ChangeWatcher;
	
	import totem.core.TotemComponent;
	import totem.math.Vector2D;

	public class DisplayObjectComponent extends TotemComponent implements IDisplay2DRenderer
	{

		public function DisplayObjectComponent( name : String = null )
		{
			super( name );
			
		}

		public function set position( value : Vector2D ) : void
		{
			
		}
		public function rotateX( value : Number, local : Boolean = true, pivotPoint : Vector3D = null ) : void
		{

		}

		public function rotateY( value : Number, local : Boolean = true, pivotPoint : Vector3D = null ) : void
		{

		}

		public function rotateZ( value : Number, local : Boolean = true, pivotPoint : Vector3D = null ) : void
		{

		}

		public function setPosition( x : Number, y : Number ) : void
		{

		}

		public function setRotation( value : Number ) : void
		{

		}

		public function setScale( _scaleX : Number, _scaleY : Number ) : void
		{

		}

		public function translateX( value : Number ) : void
		{

		}

		public function translateY( value : Number ) : void
		{

		}

		public function translateZ( value : Number ) : void
		{

		}

		override protected function onRemove() : void
		{
			super.onRemove();

		}
	}
}
