package totem.core.deconstruct
{

	import totem.core.TotemGroup;
	import totem.monitors.AbstractMonitorProxy;

	public class TotemEntityDeconstructMonitor extends AbstractMonitorProxy
	{
		private var group : TotemGroup;

		public function TotemEntityDeconstructMonitor( group : TotemGroup )
		{
			this.group = group;
		}
		
		override public function start():void
		{
			super.start();
			
			group.destroy();
			finished ();
		}
	}
}
