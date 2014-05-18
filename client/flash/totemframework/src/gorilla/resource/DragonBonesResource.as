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

package gorilla.resource
{

	import dragonBones.factorys.StarlingFactory;

	import flash.events.Event;
	import flash.utils.ByteArray;


	public class DragonBonesResource extends DataResource
	{
		private var _factory : StarlingFactory;

		public function DragonBonesResource()
		{
			super();
		}

		public function get factory() : StarlingFactory
		{
			return _factory;
		}

		override public function initialize( data : * ) : void
		{
			if ( !( data is ByteArray ))
				throw new Error( "DataResource can only handle ByteArrays." );

			_factory = new StarlingFactory();
			_factory.addEventListener( Event.COMPLETE, textureCompleteHandler );
			_factory.parseData( data );

		}

		override protected function onContentReady( content : * ) : Boolean
		{
			return _factory != null;
		}

		protected function textureCompleteHandler( event : Event ) : void
		{
			onLoadComplete();
		}
	}
}
