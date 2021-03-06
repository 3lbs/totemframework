package iso3lbs.geom.transformations
{

	import flash.geom.Vector3D;

	/**
	 * @private
	 */
	public class IsometricTransformation implements IAxonometricTransformation
	{
		public function IsometricTransformation()
		{
			cosTheta = Math.cos( 30 * Math.PI / 180 );
			sinTheta = Math.sin( 30 * Math.PI / 180 );
		}

		private var cosTheta : Number;

		private var sinTheta : Number;

		//TODO jwopitz: Figure out the proper conversion - http://www.compuphase.com/axometr.htm

		/**
		 * @inheritDoc
		 */
		public function screenToSpace( screenPt : Vector3D ) : Vector3D
		{
			var z : Number = screenPt.z;
			var y : Number = screenPt.y - screenPt.x / ( 2 * cosTheta ) + screenPt.z;
			var x : Number = screenPt.x / ( 2 * cosTheta ) + screenPt.y + screenPt.z;

			/* if (bAxonometricAxesProjection)
			{
				x = x / axialProjection;
				y = y / axialProjection;
			} */

			return new Vector3D( x, y, z );
		}

		/**
		 * @inheritDoc
		 */
		public function spaceToScreen( spacePt : Vector3D ) : Vector3D
		{
			/* if (bAxonometricAxesProjection)
			{
				spacePt.x = spacePt.x * axialProjection;
				spacePt.y = spacePt.y * axialProjection;
			} */

			var z : Number = spacePt.z;
			var y : Number = ( spacePt.x + spacePt.y ) * sinTheta - spacePt.z;
			var x : Number = ( spacePt.x - spacePt.y ) * cosTheta;

			return new Vector3D( x, y, z );
		}

	}
}