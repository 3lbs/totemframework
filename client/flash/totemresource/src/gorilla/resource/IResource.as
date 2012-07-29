package gorilla.resource
{
	public interface IResource
	{
		function get data () : *;
		
		function completeCallback ( func : Function ) : void;
		
		function failedCallback ( func : Function ) : void;
	}
}