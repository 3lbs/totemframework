package iso3lbs.geom.transformations
{

	import flash.geom.Vector3D;

	/**
	 * @private
	 */
	public class DimetricTransformation implements IAxonometricTransformation
	{
		public function DimetricTransformation()
		{
		}

		public function screenToSpace( screenPt : Vector3D ) : Vector3D
		{
			return null;
		}

		public function spaceToScreen( spacePt : Vector3D ) : Vector3D
		{
			/* if (bAxonometricAxesProjection)
			{
				spacePt.x = spacePt.x * axialProjection;
				spacePt.y = spacePt.y * axialProjection;
			} */

			var z : Number = spacePt.z;
			var y : Number = spacePt.y / 4 - spacePt.z;
			var x : Number = spacePt.x - spacePt.y / 2;

			return new Vector3D( x, y, z );
		}

	}
}