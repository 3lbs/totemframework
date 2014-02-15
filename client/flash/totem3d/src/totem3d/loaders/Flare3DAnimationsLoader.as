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

package totem3d.loaders
{

	import flare.core.Mesh3D;
	import flare.core.Pivot3D;
	import flare.utils.Pivot3DUtils;

	import totem.monitors.GroupRequiredMonitor;
	import totem.net.AppURL;

	import totem3d.components.Animator3DComponent;
	import totem3d.components.Mesh3DComponent;
	import totem3d.core.param.Animation3DParam;

	public class Flare3DAnimationsLoader extends GroupRequiredMonitor
	{
		private var _animationParams : Vector.<Animation3DParam>;

		private var component : Animator3DComponent;

		public function Flare3DAnimationsLoader( id : String = "", params : Vector.<Animation3DParam> = null )
		{
			super( id );

			_animationParams = params;
		}

		public function addComponent( comp : Animator3DComponent ) : void
		{
			component = comp;
		}

		public function get animationParams() : Vector.<Animation3DParam>
		{
			return _animationParams;
		}

		override public function start() : void
		{

			var meshComponent : Mesh3DComponent = component.getSibling( Mesh3DComponent ) as Mesh3DComponent;
			var mesh : Mesh3D = meshComponent.mesh as Mesh3D;

			var labels : Object = mesh.labels;

			for each ( var ani : Animation3DParam in _animationParams )
			{
				if ( hasLabel( ani.id, labels ))
					continue;

				var loader : Flare3DMonitor = new Flare3DMonitor( AppURL.ASSETS.getURL( ani.url ), ani.id );
				addDispatcher( loader );
			}

			super.start();
		}

		override protected function finished() : void
		{
			// TODO Auto-generated method stub

			var animationList : Vector.<Animation3DParam> = animationParams;

			var animationLoader : Flare3DMonitor;

			var meshComponent : Mesh3DComponent = component.getSibling( Mesh3DComponent ) as Mesh3DComponent;
			var mesh : Mesh3D = meshComponent.mesh as Mesh3D;

			for each ( var param : Animation3DParam in animationList )
			{
				animationLoader = getItemByID( param.id ) as Flare3DMonitor;

				if ( animationLoader )
				{
					Pivot3DUtils.appendAnimation( mesh, animationLoader.loader, animationLoader.id );
				}
					//animationDictionary[ param.id ] = param;
			}

			mesh.frameSpeed = .3;
			mesh.animationEnabled = true;
			mesh.gotoAndPlay( "ants_wave", 0, Pivot3D.ANIMATION_STOP_MODE );

			super.finished();
		}

		private function hasLabel( id : String, labels : Object ) : Boolean
		{
			for ( var key : String in labels )
			{
				if ( key == id )
					return true;
			}

			return false;
		}
	}
}
