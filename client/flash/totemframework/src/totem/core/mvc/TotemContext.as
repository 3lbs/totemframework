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

package totem.core.mvc
{

	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.IEventDispatcher;
	
	import org.swiftsuspenders.Injector;
	
	import totem.totem_internal;
	import totem.core.TotemGroup;
	import totem.events.RemovableEventDispatcher;
	import totem.monitors.progress.IProgressMonitor;
	import totem.monitors.progress.ProgressMonitor;

	use namespace totem_internal;

	public class TotemContext extends TotemGroup implements ITotemContext
	{

		totem_internal var _contextEventDispatcher : RemovableEventDispatcher = new RemovableEventDispatcher();

		protected var _mainClass : DisplayObjectContainer;

		protected var _stage : Stage;

		protected var _progressMonitor : ProgressMonitor;

		public function TotemContext( name : String, mainclass : DisplayObjectContainer, group : TotemGroup )
		{
			super( name );

			_mainClass = mainclass;

			setup( group );
		}

		override public function destroy() : void
		{
			super.destroy();
			
			_mainClass = null;
			_stage = null;
			_contextEventDispatcher = null;
		}

		public function get contextEventDispatcher() : IEventDispatcher
		{
			return _contextEventDispatcher;
		}

		public function get mainClass() : DisplayObjectContainer
		{
			return _mainClass;
		}

		public function get progressMonitor() : IProgressMonitor
		{
			return _progressMonitor;
		}

		private function setup( group : TotemGroup ) : void
		{

			owningGroup = group;

			//inject child injector
			var childInjector : Injector = group.getInjector().createChildInjector();
			childInjector.map( ITotemContext ).toValue( this );
			setInjector( childInjector );

			group.injectInto( this );

			//setInjector( injector );
			injector.map( Injector ).toValue( injector );
			//injector.injectInto( this );

			injector.map( ITotemContext, getName()).toValue( this );

			if ( _mainClass )
			{
				if ( !injector.satisfies( DisplayObjectContainer ))
					injector.map( DisplayObjectContainer ).toValue( _mainClass );
			}

			if ( _mainClass.stage )
			{
				_stage = _mainClass.stage;
				initializeApplication();
			}
		}

		public function get stage() : Stage
		{
			return _stage;
		}

		protected function start() : void
		{

		}

		protected function initializeApplication() : void
		{
			initialize();
			start();
		}
	}
}
