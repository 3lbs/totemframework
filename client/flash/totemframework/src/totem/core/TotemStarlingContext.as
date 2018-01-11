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
//   3lbs Copyright 2014 
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
	import starling.events.Event;
	
	import totem.core.mvc.TotemContext;
	import totem.loaders.starling.StarlingEngineBuilder;
	import totem.monitors.promise.wait;

	public class TotemStarlingContext extends TotemContext // implements ITicked
	{

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

			stage.removeEventListener( flash.events.Event.ENTER_FRAME, onEnterFrame );
			starlingStage = null;

			starlingEngine.dispose();
			starlingEngine = null;

			super.destroy();
		}

		public function get paused() : Boolean
		{
			return _paused;
		}

		public function set paused( value : Boolean ) : void
		{
			_paused = value;

		/*if ( _paused )
		{
			starlingEngine.stop( true );
		}
		else
		{
			starlingEngine.start();
		}*/
		}

		protected function handleStageInitComplete( event : flash.events.Event ) : void
		{
			
			var starlingEngineBuilder : StarlingEngineBuilder = event.target as StarlingEngineBuilder;

			starlingEngine = starlingEngineBuilder.starlingEngine;
			starlingEngine.antiAliasing = 0;
			starlingEngine.simulateMultitouch = true;
			//starlingEngine.enableErrorChecking = true;

			context3D = starlingEngine.context;
			context3D.present();
			
			starlingStage = starlingEngine.root as Sprite;


			paused = true;

			
			starlingEngineBuilder.destroy();

			stage.addEventListener( flash.events.Event.ENTER_FRAME, onEnterFrame, false, 0, true );

			//Logger.info( this, "handleStageInitComplete", "would be great" );
			
			initialize();

			wait( 100, start );

		}

		override protected function initializeApplication() : void
		{
			
			Starling.multitouchEnabled = true;
			
			var starlingEngineBulder : StarlingEngineBuilder = new StarlingEngineBuilder( null, this.stage, null );
			starlingEngineBulder.addEventListener( flash.events.Event.COMPLETE, handleStageInitComplete );
			starlingEngineBulder.start();
		}

		private function handleRootCreated( event : starling.events.Event ) : void
		{
			starlingStage = starlingEngine.root as Sprite;
			starlingEngine.start();
			initialize();
			start();
		}

		private function onEnterFrame( event : flash.events.Event ) : void
		{
			//stage3DProxy.clear();
			//starlingEngine.context.clear();

			starlingEngine.render();
			
			/*if ( paused )
			{
				starlingEngine.render();
			}
			else
			{
				starlingEngine.nextFrame();
			}*/
			//starlingEngine.context.present();
			//stage3DProxy.present();
		}
	}
}

import starling.display.Sprite;

internal class RootClass extends Sprite
{

	public function RootClass()
	{
	}
}

