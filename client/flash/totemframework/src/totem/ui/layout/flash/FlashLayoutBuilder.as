//------------------------------------------------------------------------------
//
//     _______ __ __           
//    |   _   |  |  |--.-----. 
//    |___|   |  |  _  |__ --| 
//     _(__   |__|_____|_____| 
//    |:  1   |                
//    |::.. . |                
//    `-------'      
//                       
//   3lbs Copyright 2013 
//   For more information see http://www.3lbs.com 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package totem.ui.layout.flash
{

	import starling.display.Button;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.HAlign;
	import starling.utils.VAlign;

	public class FlashLayoutBuilder
	{
		public function FlashLayoutBuilder()
		{
		}

		public function build( parent : DisplayObjectContainer, layoutList : Vector.<LayoutObject>, atlas : TextureAtlas ) : void
		{

			var n : int;

			var layout : LayoutObject;
			var sprite : Sprite;

			for ( n = 0; n < layoutList.length; ++n )
			{
				var display : DisplayObjectContainer;
				layout = layoutList[ n ];

				switch ( layout.type )
				{
					case "sprite":
						display = new Sprite();
						display.touchable = false;

						Sprite( display ).flatten();
						display.addChild( new Image( atlas.getTextures( layout.textureName )[ 0 ]));
						break;
					case "movieclip":
						display = new Sprite();
						display.touchable = false;
						display.addChild( new MovieClip( atlas.getTextures( layout.textureName )));
						break;
					case "button":
						var textures : Vector.<Texture> = atlas.getTextures( layout.textureName );

						if ( textures.length > 2 )
						{
							//display = new SToggleButton( textures );
						}
						else
						{
							display = new Button( textures[ 0 ], "something", textures[ 1 ]);
						}
						break;
					case "text":

						display = new TextField( layout.width, layout.height, layout.text, layout.typeFace, layout.fontSize, int( layout.fillColor ), layout.bold );
						//mTextField = new TextField(mTextBounds.width, mTextBounds.height, "");
						TextField( display ).vAlign = VAlign.CENTER;
						TextField( display ).hAlign = HAlign.CENTER;
						display.touchable = false;
						TextField( display ).autoScale = true;

						break;
				}

				if ( display )
				{
					display.x = layout.x;
					display.y = layout.y;
					display.scaleX = layout.scaleX;
					display.scaleY = layout.scaleY;
					display.name = layout.name;

					sprite = new Sprite();
					sprite.addChild( display );

					parent.addChild( display );
				}

				if ( display && layout.children && layout.children.length > 0 )
				{
					build( sprite, layout.children, atlas );
				}

			}

		}
	}
}
