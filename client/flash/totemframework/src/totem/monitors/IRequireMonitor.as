package totem.monitors
{

	public interface IRequireMonitor extends IMonitor
	{
		function requires(... args):void;

		function canStart():Boolean;

	}
}

