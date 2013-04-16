package totem.core.task.util
{

	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	import totem.core.task.ResultTask;
	import totem.core.task.enum.TaskState;

	public class XmlLoaderTask extends ResultTask
	{


		private var _filename : String;

		private var _loader : URLLoader;

		private var _xml : XML;

		public function XmlLoaderTask( filename : String )
		{
			_filename = filename;
			setSuspendable( false );
			setSkippable( false );
		}

		protected override function doStart() : void
		{
			_loader = new URLLoader();
			_loader.addEventListener( Event.COMPLETE, onComplete );
			_loader.addEventListener( IOErrorEvent.IO_ERROR, onErrorEvent );
			_loader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onErrorEvent );
			_loader.dataFormat = URLLoaderDataFormat.TEXT;
			_loader.load( new URLRequest( _filename ));
		}

		protected override function doCancel() : void
		{
			_loader.close();
			_xml = null;
		}

		private function onComplete( evt : Event ) : void
		{
			if ( state != TaskState.ACTIVE )
				return;
			var str : String = _loader.data;

			try
			{
				var xml : XML = new XML( str );
			}
			catch ( e : Error )
			{
				var msg : String = "XML Parser error: " + e.message;
				onError( msg );
				return;
			}
			_xml = xml;
			setResult( _xml );
		}

		private function onErrorEvent( evt : ErrorEvent ) : void
		{
			onError( evt.text );
		}

		private function onError( message : String ) : void
		{
			var str : String = "Error loading " + _filename + ": " + message;
			error( message );
		}

		public function get xml() : XML
		{
			return _xml;
		}

		public override function toString() : String
		{
			return "[XMLLoader for file: " + _filename + "]";
		}

	}

}
