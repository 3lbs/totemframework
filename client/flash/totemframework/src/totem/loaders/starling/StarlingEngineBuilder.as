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

package totem.loaders.starling
{

	import flash.display.Stage;
	import flash.display.Stage3D;
	import flash.geom.Rectangle;

	import org.casalib.util.StageReference;

	import starling.core.Starling;
	import starling.events.Event;

	import totem.loaders.stage3d.Stage3DPromise;
	import totem.loaders.stage3d.Stage3DProxy;
	import totem.monitors.AbstractMonitorProxy;
	import totem.utils.MobileUtil;

	public class StarlingEngineBuilder extends AbstractMonitorProxy
	{

		public static const NAME : String = "StarlingBuilder";

		public var stage3Dproxy : Stage3DProxy;

		public var starlingEngine : Starling;

		private var rootClass : Class;

		private var stage : Stage;

		private var stage3D : Stage3D;

		private var viewPort : Rectangle;

		public function StarlingEngineBuilder( rootClass : Class = null, stage : flash.display.Stage = null, viewPort : Rectangle = null, stage3D : Stage3D = null, renderMode : String = "auto", profile : String = "baseline" )
		{
			super( NAME );

			if ( !stage )
				stage = StageReference.getStage();

			this.stage = stage;
			this.stage3D = stage3D;

			if ( !rootClass )
				rootClass = RootClass;

			this.rootClass = rootClass;

			if ( !viewPort )
				viewPort = MobileUtil.isIOS() || MobileUtil.isAndroid() ? new Rectangle( 0, 0, stage.fullScreenWidth, stage.fullScreenHeight ) : new Rectangle( 0, 0, stage.stageWidth, stage.stageHeight );

			this.viewPort = viewPort;
		}

		override public function destroy() : void
		{
			super.destroy();

			stage3D = null;
			viewPort = null;
			stage = null;
			rootClass = null;

			starlingEngine = null;
			
			stage3Dproxy = null;
		}

		override public function start() : void
		{

			var stage3DPromise : Stage3DPromise = new Stage3DPromise( stage );
			stage3DPromise.completes( handleStageLoaded );

			Starling.handleLostContext = false;

			if ( MobileUtil.isAndroid())
				Starling.handleLostContext = false;
		}

		private function handleRootCreated( event : Event ) : void
		{
			starlingEngine.removeEventListener( starling.events.Event.ROOT_CREATED, handleRootCreated );
			finished();
		}

		private function handleStageLoaded( stage3D : Stage3DProxy ) : void
		{

			stage3Dproxy = stage3D;
			starlingEngine = new Starling( rootClass, stage, viewPort, stage3Dproxy.stage3D, "auto", "baseline" ) as Starling;
			starlingEngine.enableErrorChecking = true;
			starlingEngine.addEventListener( starling.events.Event.ROOT_CREATED, handleRootCreated );
		}
	}
}

import starling.display.Sprite;
import starling.events.Event;

/**
 * RootClass is the root of Starling, it is never destroyed and only accessed through <code>_starling.stage</code>.
 */
internal class RootClass extends Sprite
{

	public function RootClass()
	{
	}
}
