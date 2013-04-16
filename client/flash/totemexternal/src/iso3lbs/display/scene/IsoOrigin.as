/*

as3isolib - An open-source ActionScript 3.0 Isometric Library developed to assist
in creating isometrically projected content (such as games and graphics)
targeted for the Flash player platform

http://code.google.com/p/as3isolib/

Copyright (c) 2006 - 3000 J.W.Opitz, All Rights Reserved.

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

*/
package iso3lbs.display.scene
{

	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Vector3D;
	
	import iso3lbs.core.iso3lbs_internal;
	import iso3lbs.display.primitive.IsoPrimitive;
	import iso3lbs.enum.IsoOrientation;
	import iso3lbs.geom.IsoMath;
	import iso3lbs.graphics.IFill;
	import iso3lbs.graphics.IStroke;
	import iso3lbs.graphics.SolidColorFill;
	import iso3lbs.graphics.Stroke;
	import iso3lbs.utils.IsoDrawingUtil;
	
	import starling.display.Image;
	import starling.textures.Texture;

	use namespace iso3lbs_internal;

	/**
	 * IsoOrigin is a visual class that depicts the origin pt (typically at 0, 0, 0) with multicolored axis lines.
	 */
	public class IsoOrigin extends IsoPrimitive
	{
		/**
		 * @inheritDoc
		 */
		override protected function drawGeometry() : void
		{
			var pt0 : Vector3D = IsoMath.isoToScreen( new Vector3D( -1 * axisLength, 0, 0 ));
			var ptM : Vector3D;
			var pt1 : Vector3D = IsoMath.isoToScreen( new Vector3D( axisLength, 0, 0 ));

			
			var sprite : Sprite = new Sprite();
			var g : Graphics = sprite.graphics;
			g.clear();

			//draw x-axis
			var stroke : IStroke = IStroke( strokes[ 0 ]);
			var fill : IFill = IFill( fills[ 0 ]);

			stroke.apply( g );
			g.moveTo( pt0.x, pt0.y );
			g.lineTo( pt1.x, pt1.y );

			g.lineStyle( 0, 0, 0 );
			g.moveTo( pt0.x, pt0.y );
			fill.begin( g );
			IsoDrawingUtil.drawIsoArrow( g, new Vector3D( -1 * axisLength, 0 ), 180, arrowLength, arrowWidth );
			fill.end( g );

			g.moveTo( pt1.x, pt1.y );
			fill.begin( g );
			IsoDrawingUtil.drawIsoArrow( g, new Vector3D( axisLength, 0 ), 0, arrowLength, arrowWidth );
			fill.end( g );

			//draw y-axis
			stroke = IStroke( strokes[ 1 ]);
			fill = IFill( fills[ 1 ]);

			pt0 = IsoMath.isoToScreen( new Vector3D( 0, -1 * axisLength, 0 ));
			pt1 = IsoMath.isoToScreen( new Vector3D( 0, axisLength, 0 ));

			stroke.apply( g );
			g.moveTo( pt0.x, pt0.y );
			g.lineTo( pt1.x, pt1.y );

			g.lineStyle( 0, 0, 0 );
			g.moveTo( pt0.x, pt0.y );
			fill.begin( g )
			IsoDrawingUtil.drawIsoArrow( g, new Vector3D( 0, -1 * axisLength ), 270, arrowLength, arrowWidth );
			fill.end( g );

			g.moveTo( pt1.x, pt1.y );
			fill.begin( g );
			IsoDrawingUtil.drawIsoArrow( g, new Vector3D( 0, axisLength ), 90, arrowLength, arrowWidth );
			fill.end( g );

			//draw z-axis
			stroke = IStroke( strokes[ 2 ]);
			fill = IFill( fills[ 2 ]);

			pt0 = IsoMath.isoToScreen( new Vector3D( 0, 0, -1 * axisLength ));
			pt1 = IsoMath.isoToScreen( new Vector3D( 0, 0, axisLength ));

			stroke.apply( g );
			g.moveTo( pt0.x, pt0.y );
			g.lineTo( pt1.x, pt1.y );

			g.lineStyle( 0, 0, 0 );
			g.moveTo( pt0.x, pt0.y );
			fill.begin( g )
			IsoDrawingUtil.drawIsoArrow( g, new Vector3D( 0, 0, axisLength ), 90, arrowLength, arrowWidth, IsoOrientation.XZ );
			fill.end( g );

			g.moveTo( pt1.x, pt1.y );
			fill.begin( g );
			IsoDrawingUtil.drawIsoArrow( g, new Vector3D( 0, 0, -1 * axisLength ), 270, arrowLength, arrowWidth, IsoOrientation.YZ );
			fill.end( g );
			
			var bd : BitmapData = new BitmapData( sprite.width, sprite.height);
			bd.draw( sprite );
			
			var image: Image = new Image( Texture.fromBitmapData( bd ) ); 
			mainContainer.addChild( image );
		}

		/**
		 * The length of each axis (not including the arrows).
		 */
		public var axisLength : Number = 100;

		/**
		 * The arrow length for each arrow found on each axis.
		 */
		public var arrowLength : Number = 20;

		/**
		 * The arrow width for each arrow found on each axis.
		 * This is the total width of the arrow at the base.
		 */
		public var arrowWidth : Number = 3;

		/**
		 * Constructor
		 */
		public function IsoOrigin( descriptor : Object = null )
		{
			super( descriptor );

			if ( !descriptor || !descriptor.hasOwnProperty( "strokes" ))
			{
				strokes = [ new Stroke( 0, 0xFF0000, 0.75 ), new Stroke( 0, 0x00FF00, 0.75 ), new Stroke( 0, 0x0000FF, 0.75 )];
			}

			if ( !descriptor || !descriptor.hasOwnProperty( "fills" ))
			{
				fills = [ new SolidColorFill( 0xFF0000, 0.75 ), new SolidColorFill( 0x00FF00, 0.75 ), new SolidColorFill( 0x0000FF, 0.75 )]
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function set width( value : Number ) : void
		{
			super.width = 0;
		}

		/**
		 * @inheritDoc
		 */
		override public function set length( value : Number ) : void
		{
			super.length = 0;
		}

		/**
		 * @inheritDoc
		 */
		override public function set height( value : Number ) : void
		{
			super.height = 0;
		}
	}
}