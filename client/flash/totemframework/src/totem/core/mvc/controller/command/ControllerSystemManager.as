package totem.core.mvc.controller.command
{
	import totem.core.System;
	import totem.core.mvc.TotemContext;

	public class ControllerSystemManager extends System
	{

		/** @private */
		private var _instance : TotemContext;

		public function ControllerSystemManager( instance : TotemContext )
		{
			super();

			_instance = instance;
			initialize();
		}
	}
}
