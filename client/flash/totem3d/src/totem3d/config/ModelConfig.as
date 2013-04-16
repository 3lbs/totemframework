package totem3d.config
{
	import flare.basic.Viewer3D;
	import flare.physics.core.PhysicsSphere;
	import flare.physics.core.PhysicsSystemManager;
	import flare.primitives.Box;
	import flare.primitives.Cube;
	
	public class ModelConfig
	{

		public static const MODEL_TYPE_MD5_MESH : String = "md5mesh";

		public static const MODEL_TYPE_MD5_ANIMATION : String = "md5anim";

		public static const MODEL_TYPE_COLLADA : String = "collada";

		public static const MODEL_TYPE_3DS : String = "3ds";

		public static const MODEL_TYPE_AWD : String = "awd";

		public static const MODEL_TYPE_MD2 : String = "md2";
		
		public static const MODEL_TYPE_OBJ : String = "obj";
		
		public static const MODEL_INFO_FILE : String = "mdi";
		
		public static const allowableTextureExt : Array = [ "png", "jpeg", "jpg" ];
		
		
		//Initialize the physics manager
		//By default physics engine use grid clasification(When exists lot of objects, the performance is increased)
		private var physics = PhysicsSystemManager.getInstance();	
		
		private var test : PhysicsSphere;
		
		private var viewer3d : Viewer3D;
		
		private var cube : Cube;
		
		private var box  : Box;

	}
}

