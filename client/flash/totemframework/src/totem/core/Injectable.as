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

package totem.core
{

	import org.swiftsuspenders.Injector;

	public class Injectable extends Destroyable
	{

		protected var initialzed : Boolean;

		private var injector_ : Injector;

		override public function destroy() : void
		{
			super.destroy();

			injector_.teardown();
			injector_ = null;

		}

		public function getInjector() : Injector
		{
			return injector_;
		}

		public function initialize() : void
		{
			initialzed = true;
		}

		public function setInjector( injector : Injector ) : void
		{
			injector_ = injector;
		}
	}
}
