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

package totem3d.utils.meshpool
{

	import flare.core.Mesh3D;

	import totem.core.Destroyable;
	import totem.utils.objectpool.IObjectPoolFactory;

	public class Mesh3DPoolFactory extends Destroyable implements IObjectPoolFactory
	{

		private var first : Boolean;

		private var mesh : Mesh3D;

		public function Mesh3DPoolFactory( m : Mesh3D )
		{
			mesh = m;
		}

		public function create() : *
		{
			if ( !first )
			{
				first = true;
				return mesh;
			}
			return mesh.clone();
		}

		override public function destroy() : void
		{
			super.destroy();

			mesh.dispose();
			mesh = null;
		}
	}
}
