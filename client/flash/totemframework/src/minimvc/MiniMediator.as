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

package minimvc
{

	import totem.core.Destroyable;

	public class MiniMediator extends Destroyable
	{

		private var _context : MiniContext;

		private var _viewComponet : Object;

		public function MiniMediator()
		{
			super();
		}

		public function initialize() : void
		{
		}

		public function get instance() : MiniContext
		{
			return _context;
		}

		public function set instance( value : MiniContext ) : void
		{
			_context = value;
		}

		public function get viewComponent() : Object
		{
			return _viewComponet;
		}

		public function set viewComponent( value : Object ) : void
		{
			_viewComponet = value;
		}
	}
}
