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

	import totem.utils.objectpool.IObjectPoolHelper;

	public class Mesh3DPoolHelper implements IObjectPoolHelper
	{
		public function Mesh3DPoolHelper()
		{
			super();
		}

		public function dispose( item : * ) : void
		{

		}

		public function retire( item : * ) : void
		{
			var mesh : Mesh3D = item as Mesh3D;

			if ( mesh.inView && mesh.scene )
			{
				mesh.scene.removeChild( mesh );
			}

			if ( mesh.isPlaying )
				mesh.stop();

			mesh.currentFrame = 0;

			mesh.scaleX = 1;
			mesh.scaleY = 1;
			mesh.scaleZ = 1;

			mesh.x = 0;
			mesh.y = 0;
			mesh.z = 0;

			mesh.rotateX( 0 );
			mesh.rotateY( 0 );
			mesh.rotateZ( 0 );

		}
	}
}
