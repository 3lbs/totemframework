//------------------------------------------------------------------------------
//
//   Copyright 2012 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package totem.display
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.FullScreenEvent;
	import flash.geom.Point;
	
	import totem.utils.StageSettings;
	/**
	 *
	 * @author eddie
	 */
	public class StageProxy extends EventDispatcher
	{
		
		
		/**
		 *
		 * @param inTimeline
		 * @param inScaleMode
		 */
		public function StageProxy( inTimeline : DisplayObjectContainer, inScaleMode : String = null )
		{
			
			_timeline = inTimeline;
			
			if ( inScaleMode )
			{
				StageSettings.apply ( _timeline, StageSettings.NO_SCALE_TOP_LEFT );
			}
			
			if ( _timeline.stage )
			{
				addListeners ();
			}
			else
			{
				_timeline.addEventListener ( Event.ADDED_TO_STAGE, addListeners );
			}
		
		}
		
		private var _dimensions : Point = new Point ();
		
		private var _fullscreen : Boolean;
		
		private var _timeline : DisplayObjectContainer;
		
		/**
		 *
		 * @return
		 */
		public function get dimensions() : Point
		{
			return _dimensions;
		}
		
		/**
		 *
		 * @return
		 */
		public function get frameRate() : Number
		{
			return _timeline.stage.frameRate;
		}
		
		/**
		 *
		 * @param framerate
		 */
		public function set frameRate( framerate : Number ) : void
		{
			_timeline.stage.frameRate = framerate;
		}
		
		/**
		 *
		 * @return
		 */
		public function get fullscreen() : Boolean
		{
			return _fullscreen;
		}
		
		
		/**
		 *
		 * @param inValue
		 */
		public function set fullscreen( inValue : Boolean ) : void
		{
			if ( inValue )
			{
				try
				{
					_timeline.stage.displayState = "fullScreenInteractive";
				}
				catch ( e : Error )
				{
					try
					{
						_timeline.stage.displayState = StageDisplayState.FULL_SCREEN;
					}
					catch ( e : Error )
					{
						//Logger.error ( this, "fullscreen", e.message );
						
						return;
					}
				}
			}
			else
			{
				try
				{
					_timeline.stage.displayState = StageDisplayState.NORMAL;
				}
				catch ( e : Error )
				{
					//Logger.error ( this, "fullscreen", e.message );
					return;
				}
			}
			
			_fullscreen = inValue;
		}
		
		/**
		 *
		 */
		public function ping() : void
		{
			if ( _timeline.stage )
			{
				handleStageResize ();
				return;
			}
		}
		
		/**
		 *
		 * @return
		 */
		public function get stage() : Stage
		{
			return _timeline.stage;
		}
		
		/**
		 *
		 * @return
		 */
		public function get timeline() : DisplayObjectContainer
		{
			return _timeline;
		}
		
		private function addListeners( event : Event = null ) : void
		{
			_timeline.stage.addEventListener ( FullScreenEvent.FULL_SCREEN, handleStageResize );
			_timeline.stage.addEventListener ( Event.RESIZE, handleStageResize );
			_dimensions.x = _timeline.stage.stageWidth;
			_dimensions.y = _timeline.stage.stageHeight;
			
			frameRate = 24;
		}
		
		private function handleStageResize( event : Event = null ) : void
		{
			_dimensions.x = _timeline.stage.stageWidth;
			_dimensions.y = _timeline.stage.stageHeight;
			//dispatchEvent(RESIZE, _dimensions);
		}
	}
}

