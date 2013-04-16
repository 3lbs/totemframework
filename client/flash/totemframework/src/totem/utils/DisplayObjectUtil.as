package totem.utils
{
	/**
	 * uk.soulwire.utils.display.DisplayUtils
	 *
	 * @version v1.0
	 * @since May 26, 2009
	 *
	 * @author Justin Windle
	 * @see http://blog.soulwire.co.uk
	 *
	 * About DisplayUtils
	 *
	 * DisplayUtils is a set of static utility methods for dealing
	 * with DisplayObjects
	 *
	 * Licensed under a Creative Commons Attribution 3.0 License
	 * http://creativecommons.org/licenses/by/3.0/
	 */

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.PixelSnapping;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	public class DisplayObjectUtil
	{

		/**
		 * Fits a DisplayObject into a rectangular area with several options for scale
		 * and alignment. This method will return the Matrix required to duplicate the
		 * transformation and can optionally apply this matrix to the DisplayObject.
		 *
		 * @param displayObject
		 *
		 * The DisplayObject that needs to be fitted into the Rectangle.
		 *
		 * @param rectangle
		 *
		 * A Rectangle object representing the space which the DisplayObject should fit into.
		 *
		 * @param fillRect
		 *
		 * Whether the DisplayObject should fill the entire Rectangle or just fit within it.
		 * If true, the DisplayObject will be cropped if its aspect ratio differs to that of
		 * the target Rectangle.
		 *
		 * @param align
		 *
		 * The alignment of the DisplayObject within the target Rectangle. Use a constant from
		 * the DisplayUtils class.
		 *
		 * @param applyTransform
		 *
		 * Whether to apply the generated transformation matrix to the DisplayObject. By setting this
		 * to false you can leave the DisplayObject as it is but store the returned Matrix for to use
		 * either with a DisplayObject's transform property or with, for example, BitmapData.draw()
		 */

		public static function fitIntoRect(displayObject:DisplayObject, rectangle:Rectangle, fillRect:Boolean=true, align:String="C", applyTransform:Boolean=true, imageRectSize:Boolean=false):Matrix
		{
			var matrix:Matrix=new Matrix();

			var srw:Number=displayObject.width;
			var srh:Number=displayObject.height;

			if (displayObject.scrollRect)
			{
				srw=displayObject.scrollRect.width;
				srh=displayObject.scrollRect.height;
			}

			var wD:Number=srw / displayObject.scaleX;
			var hD:Number=srh / displayObject.scaleY;

			var wR:Number=rectangle.width;
			var hR:Number=rectangle.height;

			var sX:Number=wR / wD;
			var sY:Number=hR / hD;

			var rD:Number=wD / hD;
			var rR:Number=wR / hR;

			var sH:Number=fillRect ? sY : sX;
			var sV:Number=fillRect ? sX : sY;

			var s:Number=rD >= rR ? sH : sV;
			var w:Number=wD * s;
			var h:Number=hD * s;

			var tX:Number=0.0;
			var tY:Number=0.0;

			switch (align)
			{
				case Alignment.LEFT:
				case Alignment.TOP_LEFT:
				case Alignment.BOTTOM_LEFT:
					tX=0.0;
					break;

				case Alignment.RIGHT:
				case Alignment.TOP_RIGHT:
				case Alignment.BOTTOM_RIGHT:
					tX=w - wR;
					break;

				default:
					tX=0.5 * (w - wR);
			}

			switch (align)
			{
				case Alignment.TOP:
				case Alignment.TOP_LEFT:
				case Alignment.TOP_RIGHT:
					tY=0.0;
					break;

				case Alignment.BOTTOM:
				case Alignment.BOTTOM_LEFT:
				case Alignment.BOTTOM_RIGHT:
					tY=h - hR;
					break;

				default:
					tY=0.5 * (h - hR);
			}

			matrix.scale(s, s);
			matrix.translate(rectangle.left - tX, rectangle.top - tY);

			if (applyTransform)
			{
				displayObject.transform.matrix=matrix;
			}

			return matrix;
		}


		public static function alignInRect(displayObject:DisplayObject, rectangle:Rectangle, fillRect:Boolean=true, align:String="C", applyTransform:Boolean=true):Matrix
		{
			var matrix:Matrix=new Matrix();

			var w:Number=displayObject.width;
			var h:Number=displayObject.height;

			var wR:Number=rectangle.width;
			var hR:Number=rectangle.height;

			var tX:Number=0.0;
			var tY:Number=0.0;

			// X coordinate
			switch (align)
			{
				case Alignment.BOTTOM_LEFT:
				case Alignment.TOP_LEFT:
				case Alignment.LEFT:
					tX=0.0;
					break;
				case Alignment.TOP_RIGHT:
				case Alignment.RIGHT:
				case Alignment.BOTTOM_RIGHT:
					tX=Math.abs(wR - w);
					break;
				case Alignment.CENTER:
				case Alignment.BOTTOM_CENTER:
				case Alignment.TOP_CENTER:
					tX=0.5 * Math.abs(wR - w);
					break;
				default:
			}

			// Y coordinate
			switch (align)
			{
				case Alignment.TOP:
				case Alignment.TOP_LEFT:
				case Alignment.TOP_RIGHT:
				case Alignment.RIGHT:
					tY=0.0;
					break;
				case Alignment.BOTTOM:
				case Alignment.BOTTOM_LEFT:
				case Alignment.BOTTOM_RIGHT:
				case Alignment.BOTTOM_CENTER:
					tY=Math.abs(hR - h);
					break;
				case Alignment.CENTER:
					tY=0.5 * Math.abs(hR - h);
					break;
				default:
			}

			matrix.scale(displayObject.scaleX, displayObject.scaleY);
			matrix.translate(rectangle.left + tX, rectangle.top + tY);

			if (applyTransform)
			{
				displayObject.transform.matrix=matrix;
			}

			return matrix;
		}

		public static function clone(a_displayObject:DisplayObject):Bitmap
		{
			var dispRect:Rectangle=a_displayObject.getRect(a_displayObject.stage);

			var bitmapData:BitmapData=new BitmapData(dispRect.width, dispRect.height, true, 0x000000);

			var matrixOffset:Matrix=a_displayObject.transform.matrix;
			matrixOffset.tx=a_displayObject.x - dispRect.x;
			matrixOffset.ty=a_displayObject.y - dispRect.y;

			bitmapData.draw(a_displayObject, matrixOffset);

			var clone:Bitmap=new Bitmap(bitmapData, PixelSnapping.AUTO, true);

			return clone;
		}

		/**
		 * Removes the given DisplayObject from its parent.
		 *
		 * @param	a_displayObject		DisplayObject to remove
		 */
		public static function removeFromParent(a_displayObject:DisplayObject):void
		{
			if (a_displayObject.parent)
			{
				a_displayObject.parent.removeChild(a_displayObject);
			}
		}

		public static function cloneDisplayObject(source:DisplayObject):DisplayObject
		{
			var exampleType:Class=Object(source).constructor;
			return new exampleType();
		}

		public static function getVisibleBounds(source:DisplayObject):Rectangle
		{
			//var matrix:Matrix = new Matrix()
			//matrix.tx = -source.getBounds(null).x;
			//matrix.ty = -source.getBounds(null).y;

			var data:BitmapData=new BitmapData(source.width, source.height, true, 0x00000000);
			data.draw(source);
			var bounds:Rectangle=data.getColorBoundsRect(0xFFFFFFFF, 0x000000, false);
			data.dispose();
			return bounds;
		}
	}
}

