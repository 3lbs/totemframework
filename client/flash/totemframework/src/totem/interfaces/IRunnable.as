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

package totem.interfaces
{

	/**
		@author Aaron Clinger
		@author Mike Creighton
		@version 02/19/08
	*/
	public interface IRunnable
	{

		/**
			Begins the process.
		*/
		function start() : void;

		/**
			Stops the process.
		*/
		function stop() : void;
	}
}
