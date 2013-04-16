package totem.loaders.starling
{

	import flash.display.Stage;
	import flash.display.Stage3D;
	import flash.geom.Rectangle;

	import starling.core.Starling;
	import starling.events.Event;

	import totem.monitors.AbstractMonitorProxy;

	public class StarlingEngineBuilder extends AbstractMonitorProxy
	{

		public static const NAME : String = "StarlingBuilder";

		private var rootClass : Class;

		private var stage : Stage;

		private var viewPort : Rectangle;

		private var stage3D : Stage3D;

		public var starling : Starling;

		public function StarlingEngineBuilder( rootClass : Class, stage : flash.display.Stage, viewPort : Rectangle = null, stage3D : Stage3D = null, renderMode : String = "auto", profile : String = "baselineConstrained" )
		{
			super( NAME );

			this.stage = stage;
			this.stage3D = stage3D;
			this.rootClass = rootClass;
			this.viewPort = viewPort;
		}

		override public function start() : void
		{
			starling = new Starling( rootClass, stage, viewPort, stage3D ) as Starling;
			starling.addEventListener( starling.events.Event.ROOT_CREATED, handleRootCreated );
		}

		private function handleRootCreated( event : Event ) : void
		{
			starling.removeEventListener( starling.events.Event.ROOT_CREATED, handleRootCreated );
			finished();
		}

		override public function destroy() : void
		{
			super.destroy();

			stage3D = null;
			viewPort = null;
			stage = null;
			rootClass = null;
			
			starling = null;
		}
	}
}
