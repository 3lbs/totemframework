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

package totem3d.components
{

	import flare.core.Mesh3D;
	import flare.core.Texture3D;
	import flare.materials.Shader3D;
	import flare.materials.filters.TextureMapFilter;

	import flash.display.BitmapData;
	import flash.events.Event;

	import org.casalib.util.StringUtil;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import totem.core.TotemComponent;

	import totem3d.loaders.IShader3DBuilder;

	public class TextureMaterialComponent extends TotemComponent
	{
		public static const NAME : String = "TextureComponent";

		[Inject]
		public var meshComponent : Mesh3DComponent;

		public var onUpdateMaterial : ISignal = new Signal( TextureMaterialComponent );

		protected var _shader : Shader3D;

		private var _materialName : String;

		private var _textureBitmapData : BitmapData;

		private var loader : IShader3DBuilder;

		private var repeat : Boolean = true;

		private var smooth : Boolean = false;

		public function TextureMaterialComponent()
		{
			super();
		}

		public function get canApplyMaterial() : Boolean
		{
			return meshComponent.meshStatus == Mesh3DComponent.LOADED;
		}

		public function materialLoader( l : IShader3DBuilder ) : void
		{
			loader = l;
			loader.addEventListener( Event.COMPLETE, handleMaterialComplete );
		}

		public function get materialName() : String
		{
			return _materialName;
		}

		public function set materialName( value : String ) : void
		{
			_materialName = value;
		}

		public function get shader3D() : Shader3D
		{
			return _shader;
		}

		public function set shader3D( mat : Shader3D ) : void
		{
			if ( mat == _shader )
				return;

			if ( canApplyMaterial && mat )
			{
				var mesh : Mesh3D = meshComponent.mesh;
				mesh.setMaterial( mat );

				if ( _shader )
				{
					_shader.dispose();
				}
			}

			_shader = mat;
			onUpdateMaterial.dispatch( this );
		}

		public function get textureBitmapData() : BitmapData
		{
			return _textureBitmapData;
		}

		public function set textureBitmapData( value : BitmapData ) : void
		{

			if ( _textureBitmapData == value )
				return;

			_textureBitmapData = value;

			var texture3D : Texture3D = new Texture3D( _textureBitmapData );

			var bitmapFilter : TextureMapFilter = new TextureMapFilter( texture3D );

			var newShader : Shader3D = new Shader3D( "mat_" + StringUtil.createRandomIdentifier( 4 ), null, true );
			newShader.filters.push( bitmapFilter );
			newShader.build()

			shader3D = newShader;
		}

		public function updateMaterialMethod() : void
		{
		}

		override protected function onAdd() : void
		{
			super.onAdd();

			meshComponent.meshUpdate.add( handleMeshUpdate );
		}

		override protected function onRemove() : void
		{
			super.onRemove();

			if ( _shader )
			{
				_shader = null;
			}

			meshComponent = null;

			onUpdateMaterial.removeAll();
			onUpdateMaterial = null;

		}

		private function handleMaterialComplete( eve : Event ) : void
		{
			shader3D = loader.shader3D;
			loader.removeEventListener( Event.COMPLETE, handleMaterialComplete );
			loader = null;
		}

		private function handleMeshUpdate( component : Mesh3DComponent ) : void
		{
			shader3D = _shader;
		}
	}
}

