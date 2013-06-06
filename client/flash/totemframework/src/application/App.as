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

package application
{

	[Bindable]
	[Table( name = 'apps' )]
	public class App
	{

		public var appProps : Object = new Object();

		[Id]
		[Column( name = 'app_id' )]
		public var id : int;

		public var launches : int;

		[Column( name = "name" )]
		public var name : String = "3lbsapp";

		public var paidUser : Boolean;

		public var playMusic : Boolean = true;

		[Column( name = "play_sfx" )]
		public var playSFX : Boolean = true;

		public var sendNotification : Boolean;

		public function App()
		{
		}

		internal function getAppProp( key : String ) : *
		{
			return appProps[ key ];
		}

		internal function setAppProp( key : String, value : * ) : *
		{
			return appProps[ key ] = value;
		}
	}
}
