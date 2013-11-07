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

package totem.core
{

	import flash.display.DisplayObjectContainer;
	import flash.display3D.Context3D;
	import flash.events.Event;

	import starling.core.Starling;
	import starling.display.Sprite;

	import totem.core.mvc.modular.mvcs.TotemModuleContext;
	import totem.core.time.ITicked;
	import totem.core.time.TimeManager;
	import totem.loaders.stage3d.Stage3DProxy;
	import totem.loaders.starling.StarlingEngineBuilder;

	public class TotemStarlingContext extends TotemModuleContext implements ITicked
	{

		public var stage3DProxy : Stage3DProxy;

		public var starlingEngine : Starling;

		public var starlingStage : Sprite;

		private var _paused : Boolean;

		private var context3D : Context3D;

		public function TotemStarlingContext( name : String, mainclass : DisplayObjectContainer, group : TotemGroup, context3D : Context3D = null )
		{
			super( name, mainclass, group );

			this.context3D = context3D;
		}

		override public function destroy() : void
		{
			super.destroy();

			starlingStage = null;

			starlingEngine.dispose();
			starlingEngine = null;

		}

		public function onTick() : void
		{
			if ( paused )
				return;

			stage3DProxy.clear();

			starlingEngine.nextFrame();

			stage3DProxy.present();
		}

		public function get paused() : Boolean
		{
			return _paused;
		}

		public function set paused( value : Boolean ) : void
		{
			_paused = value;
		}

		protected function handleStageInitComplete( event : Event ) : void
		{
			var starlingEngineBuilder : StarlingEngineBuilder = event.target as StarlingEngineBuilder;

			starlingEngine = starlingEngineBuilder.starlingEngine;
			starlingEngine.antiAliasing = 1;
			starlingEngine.enableErrorChecking = true;
			starlingStage = starlingEngine.root as Sprite;
			//starlingEngine.start();

			paused = true;
			stage3DProxy = starlingEngineBuilder.stage3Dproxy;

			starlingEngineBuilder.destroy();
			
			initialize();

			var timeManager : TimeManager = new TimeManager();
			timeManager.stage = stage;
			registerManager( TimeManager, timeManager );
			timeManager.addTickedObject( this );

			start();

		}

		override protected function initializeApplication() : void
		{
			var starlingEngineBulder : StarlingEngineBuilder = new StarlingEngineBuilder( null, this.stage, null );
			starlingEngineBulder.addEventListener( Event.COMPLETE, handleStageInitComplete );
			starlingEngineBulder.start();
		}
	}
}
