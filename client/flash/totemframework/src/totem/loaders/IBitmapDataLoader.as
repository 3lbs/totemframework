package totem.loaders
{
	import flash.display.BitmapData;

	public interface IBitmapDataLoader
	{
		function get bitmapData () : BitmapData;
		
		function destroy() : void
	}
}