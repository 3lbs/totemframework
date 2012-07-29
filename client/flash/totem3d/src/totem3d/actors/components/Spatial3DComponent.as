package totem3d.actors.components
{
	import flash.geom.Vector3D;
	
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	import totem.core.TotemComponent;
	
	import totem3d.core.ISpatialObject;

	public class Spatial3DComponent extends TotemComponent implements ISpatialObject
	{

		private var _position : Vector3D = new Vector3D();

		private var _scale : Number = 1;

		private var _x : Number = 0;

		private var _y : Number = 0;

		private var _z : Number = 0;
		
		public var spatialManager : ISpatialManager;
		
		public var onUpdateSpatial : ISignal = new Signal( Vector3D );

		public function Spatial3DComponent()
		{
			super();
		}

		override protected function onAdd() : void
		{
			super.onAdd();
			
			// add to spatial manager
			
			if ( spatialManager )
				spatialManager.addSpatialObject( this );
		}

		/**
		 *
		 * @return Mesh Position
		 */
		public function get position() : Vector3D
		{
			_position.x = x;
			_position.y = y;
			_position.z = z;

			return _position;
		}

		/**
		 *
		 * @param value
		 */
		public function set position( value : Vector3D ) : void
		{
			updatePosition( value );
			onUpdateSpatial.dispatch( this );
		}

		public function updatePosition( value : Vector3D ) : void
		{
			if ( !value.equals( _position ))
			{
				_x = value.x;
				_y = value.y;
				_z = value.z;
			}
		}

		/**
		 *
		 * @return
		 */
		public function get scale() : Number
		{
			return _scale;
		}

		/**
		 *
		 * @param value
		 */
		public function set scale( value : Number ) : void
		{
			_scale = value;
			//onUpdateSpatial.dispatch( position );
		}

		/**
		 *
		 * @return
		 */
		public function get x() : Number
		{
			return _x;
		}

		/**
		 *
		 * @param value
		 */
		public function set x( value : Number ) : void
		{
			_x = value;
			onUpdateSpatial.dispatch( position );
		}

		/**
		 *
		 * @return
		 */
		public function get y() : Number
		{
			return _y;
		}

		/**
		 *
		 * @param value
		 */
		public function set y( value : Number ) : void
		{
			_y = value;
			onUpdateSpatial.dispatch( position );
		}

		/**
		 *
		 * @return
		 */
		public function get z() : Number
		{
			return _z;
		}

		/**
		 *
		 * @param value
		 */
		public function set z( value : Number ) : void
		{
			_z = value;
			onUpdateSpatial.dispatch( position );
		}
	}
}

