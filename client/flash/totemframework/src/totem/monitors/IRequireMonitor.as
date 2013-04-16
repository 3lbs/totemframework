package totem.monitors
{

	public interface IRequireMonitor extends IStartMonitor
	{
		function requires(... args):void;

		function canStart():Boolean;

	}
}

