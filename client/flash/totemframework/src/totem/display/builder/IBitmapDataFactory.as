package totem.display.builder
{
	import flash.display.BitmapData;

	public interface IBitmapDataFactory
	{
		function get bitmapData () : BitmapData;
		
		function destroy() : void
	}
}