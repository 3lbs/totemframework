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

	import totem.monitors.RequiredProxy;

	public class AppStartupLoader extends RequiredProxy
	{
		public function AppStartupLoader( id : String = "" )
		{
			super( id );
		}
		
		override protected function finished():void
		{
			super.finished();
		}
	}
}
