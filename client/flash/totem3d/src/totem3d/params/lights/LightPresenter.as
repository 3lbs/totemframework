package totem3d.params.lights
{
	import away3d.containers.ObjectContainer3D;
	import away3d.lights.DirectionalLight;
	import away3d.lights.LightBase;
	import away3d.lights.PointLight;
	import away3d.primitives.WireframeCylinder;
	import away3d.primitives.WireframePrimitiveBase;
	import away3d.primitives.WireframeSphere;
	
	import flash.geom.Vector3D;
	
	import org.casalib.events.RemovableEventDispatcher;

	[Bindable]
	public class LightPresenter extends RemovableEventDispatcher
	{

		public var light : LightBase;

		public var type : String;

		private var _lightParams : LightParams;

		private var _lookAtPosition : Vector3D = new Vector3D( 0, 0, 0 );

		public var canBeDeleted : Boolean = false;

		private var _isLightOn : Boolean = true;

		private var offColor : int = 0;

		private var lightColor : int;

		private var _debugLight : ObjectContainer3D;

		private var pointDebugLight : WireframePrimitiveBase;

		private var directionDebugLight : WireframePrimitiveBase;

		private var _ambientColor : uint = 1;

		private var _ambientStrength : Number;

		public function LightPresenter( params : LightParams )
		{
			lightParams = params || new LightParams();
			buildLight( lightParams.type );
		}

		private function buildLight( type : String ) : void
		{

			this.type = type;

			var lightClass : Class = ( getLightEnum() == LightEnum.DIRECTION_LIGHT ) ? DirectionalLight : PointLight;
			var tempLight : LightBase = new lightClass();

			var sphere : WireframeSphere = new WireframeSphere( 30, 4, 4 );
			pointDebugLight = sphere;

			var cone : WireframeCylinder = new WireframeCylinder();
			directionDebugLight = cone;

			setLight( tempLight );
		}

		public function getLightEnum() : LightEnum
		{
			return LightEnum.getEnumByType( type );
		}

		public function setLightEnum( lightEnum : LightEnum ) : void
		{
			type = lightEnum.type;
		}

		public function setLight( light : LightBase ) : LightBase
		{

			this.light = light;

			if ( light is PointLight )
			{
				debugLight = pointDebugLight;
			}
			else
			{
				debugLight = directionDebugLight;
			}

			light.color = lightColor = lightParams.color;

			setDebugColor( lightColor );

			debugLight.position = light.position = lightParams.position;

			if ( light is DirectionalLight )
			{

				light.ambient = lightParams.ambient;
				light.ambientColor = lightParams.ambientColor;
				light.lookAt( lightParams.lookAtPosition );
			}


			return light;
		}

		private function destroyLight() : void
		{
			_debugLight.dispose();
			_debugLight = null;

			lightParams = null;
		}

		public function setParams( params : LightParams ) : void
		{
			lightParams = params;
		}

		public function get lookAtPosition() : Vector3D
		{
			return lightParams.lookAtPosition;
		}

		public function set lookAtPosition( value : Vector3D ) : void
		{
			if ( light is DirectionalLight )
			{
				light.lookAt( value );
				lightParams.lookAtPosition = value;

				_debugLight.lookAt( value );
			}
		}

		public function get castsShadows() : Boolean
		{
			return light.castsShadows;
		}

		public function set castsShadows( value : Boolean ) : void
		{
			light.castsShadows = value;
		}

		public function get color() : uint
		{
			if ( _isLightOn )
			{
				return light.color;
			}

			return lightColor;
		}

		public function set color( value : uint ) : void
		{
			if ( _isLightOn )
			{
				light.color = lightParams.color = value;
			}
			setDebugColor( value );
		}

		public function get position() : Vector3D
		{
			return lightParams.position;
		}

		public function set position( value : Vector3D ) : void
		{
			light.position = value;
			lightParams.position = debugLight.position = light.position;
		}

		override public function destroy() : void
		{
			super.destroy();

			destroyLight();

			light.dispose();
			light = null;
		}

		public function get isLightOn() : Boolean
		{
			return _isLightOn;
		}

		public function set isLightOn( value : Boolean ) : void
		{
			if ( value )
			{
				light.color = lightColor;

			}
			else
			{
				lightColor = light.color;
				light.color = 0;
			}

			debugLight.visible = value;
			_isLightOn = value;
		}

		public function get debugLight() : ObjectContainer3D
		{
			return _debugLight;
		}

		public function set debugLight( value : ObjectContainer3D ) : void
		{
			_debugLight = value;
		}

		public function get lightParams() : LightParams
		{
			return _lightParams;
		}

		public function set lightParams( value : LightParams ) : void
		{
			_lightParams = value;
		}

		public function get falloff() : Number
		{
			return lightParams.falloff;
		}

		public function set falloff( value : Number ) : void
		{
			if ( light is PointLight )
			{
				PointLight( light ).fallOff = value;
			}
			lightParams.falloff = value;
		}

		public function get radius() : Number
		{
			return lightParams.radius;
		}

		public function set radius( value : Number ) : void
		{
			if ( light is PointLight )
			{
				PointLight( light ).radius;
			}
			lightParams.radius = value;
		}

		public function get ambientColor() : uint
		{
			return lightParams.ambientColor;
		}

		public function set ambientColor( value : uint ) : void
		{
			lightParams.ambientColor = value;

			if ( light is DirectionalLight )
			{
				DirectionalLight( light ).ambientColor = value;
			}
		}

		public function get ambientStrength() : Number
		{
			return lightParams.ambient;
		}

		public function set ambientStrength( value : Number ) : void
		{
			lightParams.ambient = value;

			if ( light is DirectionalLight )
			{
				DirectionalLight( light ).ambient = value;
			}
		}

		public function setDebugColor( value : uint ) : void
		{
			pointDebugLight.color = directionDebugLight.color = value;
		}
	}
}

