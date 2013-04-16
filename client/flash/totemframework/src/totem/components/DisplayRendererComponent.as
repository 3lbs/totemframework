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
	
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	import totem.core.TotemComponent;

	public class DisplayRendererComponent extends TotemComponent implements IDisplayRenderer
	{
		public static const DISPLAY_UPDATE_EVENT : String = "DisplayUpdateEvent";

		public var displayUpdate : ISignal = new Signal( DisplayRendererComponent );

		//995-8111

		public function DisplayRendererComponent( name : String = null )
		{
			super( name );
		}

		public function rotateX( value : Number, local : Boolean = true, pivotPoint : Vector3D = null  ) : void
		{

		}

		public function rotateY( value : Number, local : Boolean = true, pivotPoint : Vector3D = null  ) : void
		{

		}

		public function rotateZ( value : Number, local : Boolean = true, pivotPoint : Vector3D = null  ) : void
		{

		}

		public function setPosition( x : Number, y : Number, z : Number ) : void
		{

		}

		public function setRotation( x : Number, y : Number, z : Number ) : void
		{

		}

		public function setScale( _scaleX : Number, _scaleY : Number, _scaleZ : Number ) : void
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
			
			displayUpdate.removeAll();
			displayUpdate = null;
		}
	}
}
