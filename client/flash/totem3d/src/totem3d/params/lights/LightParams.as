package totem3d.params.lights
{
	import flash.geom.Vector3D;

	public class LightParams
	{
		public function LightParams()
		{
		}

		public var type : String = LightEnum.DIRECTION_LIGHT.type;

		public var position : Vector3D = new Vector3D();

		public var color : uint = 0xFFFFFF;

		public var lookAtPosition : Vector3D = new Vector3D( 0, 10, 0 );

		public var radius : Number = 200;

		public var falloff : Number = 500;

		public var ambientColor : uint = 1;

		public var ambient : Number = 0xFFFFFF;

		public function getTypeEnum() : LightEnum
		{
			return null;
		}
	}
}

