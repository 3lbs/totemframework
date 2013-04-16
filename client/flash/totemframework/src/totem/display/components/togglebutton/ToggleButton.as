package totem.display.components.togglebutton
{

	import flash.display.MovieClip;

	public class ToggleButton extends MobileMovieClipButton implements IToggleButton
	{
		private var _data : Object;

		public function ToggleButton( mc : MovieClip)
		{
			super( mc );
		}

		public function set data( value : Object ) : void
		{
			_data = value;
		}

		public function get data() : Object
		{
			return _data;
		}
		
		override public function destroy () : void
		{
			super.destroy();
			
			_data = null;
		}
	}
}
