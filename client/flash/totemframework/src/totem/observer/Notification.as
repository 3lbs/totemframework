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

package totem.observer
{

	import totem.core.Destroyable;
	import totem.data.type.Point2d;

	public class Notification extends Destroyable
	{

		internal static var disposed : Vector.<Notification> = new Vector.<Notification>();

		public static function create( type : String, data : Object = null ) : Notification
		{

			if ( disposed.length == 0 )
			{
				return new Notification( type, data );
			}
			else
			{
				return disposed.pop().reset( type, data ) as Notification;
			}
		}

		public var data : Object;

		public var type : String;

		public function Notification( type : String, data : Object = null )
		{
			this.type = type;
			this.data = data;
		}
		
		public static function grow( value : int ) : void
		{
			for ( var i : int = 0; i < value; ++i )
			{
				disposed.push( new Notification( "" ));
			}
		}

		public function clone() : Notification
		{
			return Notification.create( type, data );
		}

		public function dispose() : void
		{
			var a : Point2d;
			
			var idx : int = disposed.indexOf( this );
			if ( idx > -1 )
				return;
			
			disposed.push( this );
		}

		public function reset( type : String, data : Object = null ) : Notification
		{
			this.type = type;
			this.data = data;
			return this;
		}
	}
}
