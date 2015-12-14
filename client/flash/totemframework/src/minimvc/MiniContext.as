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

package minimvc
{

	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;

	import totem.core.IDestroyable;
	import totem.events.RemovableEventDispatcher;

	public class MiniContext extends RemovableEventDispatcher
	{
		protected var controller : MiniController;

		protected var mediator : MiniMediatorMap;

		private var _mainStage : DisplayObjectContainer;

		private var _models : Dictionary = new Dictionary();

		public function MiniContext( stage : DisplayObjectContainer )
		{
			super();

			_mainStage = stage;

			setupApplication();

			setup();
			intialize();
		}

		override public function destroy() : void
		{

			controller.destroy();
			controller = null;

			mediator.destroy();
			mediator = null;

			for ( var clazz : Class in _models )
			{
				if ( _models[ clazz ] is IDestroyable )
				{
					IDestroyable( _models[ clazz ]).destroy();
				}

				if ( _models[ clazz ].hasOwnProperty( "context" ))
					_models[ clazz ].context = null;

				_models[ clazz ] = null;
				delete _models[ clazz ];
			}

			_models = null;
			_mainStage = null;

			super.destroy();
		}

		public function get mainStage() : DisplayObjectContainer
		{
			return _mainStage;
		}

		public function retriveModel( clazz : Class ) : *
		{
			return _models[ clazz ];
		}

		protected function intialize() : void
		{

		}

		protected function registerModel( clazz : Class, instance : Object ) : void
		{
			if ( _models[ clazz ])
			{
				return;
			}

			if ( instance.hasOwnProperty( "context" ))
				instance.context = this;

			_models[ clazz ] = instance;
		}

		protected function setup() : void
		{

		}

		private function setupApplication() : void
		{

			controller = new MiniController( this );

			mediator = new MiniMediatorMap( this );

		}
	}
}
