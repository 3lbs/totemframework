package totem.utils{		import flash.display.DisplayObject;	import flash.display.Stage;	import flash.display.StageAlign;	import flash.display.StageScaleMode;	import flash.events.Event;		/**	 * @author epologee.com � 2009	 */	public class StageSettings	{		public static const NO_SCALE_TOP_LEFT : String = "no scale, top left alignment";				public static const NO_SCALE_CENTER : String = "no_scale_center";				public static const NO_SCALE_TOP_CENTER : String = "no_scale_top_center";				public static const NO_BORDER_CENTER : String = "no_border_center";				public static const SCALE_TOP_LEFT : String = "scale to fit, top left alignment";				public static const SCALE_CENTER : String = "scale to fit, center alignment";				//		public static const SHOW_DEFAULT_CONTEXT_MENU : Boolean = false;				public static const STAGE_FOCUS_RECT : Boolean = false;				//		private var _stage : Stage;				private var _mode : String;				public function StageSettings( inStageContainer : DisplayObject, inMode : String = null )		{			_mode = inMode ? inMode : NO_SCALE_TOP_LEFT;						if ( inStageContainer.stage )			{				_stage = inStageContainer.stage;				setStageProperties ();			}			else			{				inStageContainer.addEventListener ( Event.ADDED_TO_STAGE, handleAddedToStage );			}		}				public static function apply( inStageContainer : DisplayObject, inMode : String = null ) : void		{			new StageSettings ( inStageContainer, inMode );		}				private function handleAddedToStage( event : Event ) : void		{			_stage = DisplayObject ( event.target ).stage;			setStageProperties ();		}				private function setStageProperties() : void		{			switch ( _mode )			{				default:				case NO_SCALE_TOP_LEFT:					_stage.scaleMode = StageScaleMode.NO_SCALE;					_stage.align = StageAlign.TOP_LEFT;					break;				case NO_SCALE_TOP_CENTER:					_stage.scaleMode = StageScaleMode.NO_SCALE;					_stage.align = "T";					break;				case NO_SCALE_CENTER:					_stage.scaleMode = StageScaleMode.NO_SCALE;					_stage.align = "";					break;				case NO_BORDER_CENTER:					_stage.scaleMode = StageScaleMode.NO_BORDER;					_stage.align = "";					break;				case SCALE_TOP_LEFT:					_stage.scaleMode = StageScaleMode.SHOW_ALL;					_stage.align = StageAlign.TOP_LEFT;					break;				case SCALE_CENTER:					_stage.scaleMode = StageScaleMode.SHOW_ALL;					_stage.align = "";					break;			}						_stage.showDefaultContextMenu = SHOW_DEFAULT_CONTEXT_MENU;			_stage.stageFocusRect = STAGE_FOCUS_RECT;		}	}}