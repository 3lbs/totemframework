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
//   3lbs Copyright 2014 
//   For more information see http://www.3lbs.com 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package totem.core.input
{

	import flash.display.Stage;
	
	import org.gestouch.core.Gestouch;
	import org.gestouch.core.GestureState;
	import org.gestouch.events.GestureEvent;
	import org.gestouch.extensions.starling.StarlingDisplayListAdapter;
	import org.gestouch.extensions.starling.StarlingTouchHitTester;
	import org.gestouch.gestures.Gesture;
	import org.gestouch.gestures.PanGesture;
	import org.gestouch.gestures.TapGesture;
	import org.gestouch.gestures.ZoomGesture;
	import org.gestouch.input.NativeInputAdapter;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;

	public class GestouchInputMonitor extends BaseInputMonitor implements IInputMonitor
	{

		private var _enabled : Boolean = true;

		private var panGesture : PanGesture;

		private var singleTapGesture : TapGesture;

		private var zoomGesture : ZoomGesture;

		public function GestouchInputMonitor( target : Stage, starling : Starling, view : DisplayObject )
		{
			super( target );

			Gestouch.inputAdapter ||= new NativeInputAdapter( target );
			Gestouch.addDisplayListAdapter( DisplayObject, new StarlingDisplayListAdapter());
			Gestouch.addTouchHitTester( new StarlingTouchHitTester( starling ), -1 );

			singleTapGesture = new TapGesture( view.stage );
			singleTapGesture.addEventListener( GestureEvent.GESTURE_RECOGNIZED, onGesture );

			zoomGesture = new ZoomGesture( view.stage );
			zoomGesture.addEventListener( org.gestouch.events.GestureEvent.GESTURE_BEGAN, onZoom );
			zoomGesture.addEventListener( org.gestouch.events.GestureEvent.GESTURE_CHANGED, onZoom );

			zoomGesture.slop;
			trace( zoomGesture.slop );

			panGesture = new PanGesture( view.stage );
			panGesture.minNumTouchesRequired = 1;
			panGesture.maxNumTouchesRequired = 2;
			panGesture.addEventListener( org.gestouch.events.GestureEvent.GESTURE_BEGAN, onPan );
			panGesture.addEventListener( org.gestouch.events.GestureEvent.GESTURE_CHANGED, onPan );

			trace( panGesture.slop );
			//panGesture.requireGestureToFail( zoomGesture );

			singleTapGesture.requireGestureToFail( panGesture );
			singleTapGesture.requireGestureToFail( zoomGesture );

			panGesture.gesturesShouldRecognizeSimultaneouslyCallback = gesturesShouldRecognizeSimultaneouslyCallback;
			zoomGesture.gesturesShouldRecognizeSimultaneouslyCallback = gesturesShouldRecognizeSimultaneouslyCallback;

		}

		protected function onPan( event : GestureEvent ) : void
		{
			var gesture : PanGesture = event.target as PanGesture;

			trace( "pan", gesture.offsetX, gesture.offsetY );

			_observers.handlePan( gesture.offsetX, gesture.offsetY );

			trace( event.newState.toString());

			if ( event.newState == GestureState.FAILED )
			{
				//panGesture.reset();

				trace( "we didnt do this" );
			}

		}

		protected function onZoom( event : GestureEvent ) : void
		{
			var gesture : ZoomGesture = event.target as ZoomGesture;

			trace( "zoom", gesture.scaleX, gesture.scaleY );

			if ( event.newState == GestureState.BEGAN )
			{
				//panGesture.reset();
				//_observers.handleTouchZoom( 1, 1 );
			}

		}

		private function gesturesShouldRecognizeSimultaneouslyCallback( gesture : Gesture, otherGesture : Gesture ) : Boolean
		{
			if (( gesture == panGesture && otherGesture == zoomGesture ) || ( gesture == zoomGesture && otherGesture == panGesture ))
				return true; // or if (gesture.target == otherGesture.target) return true; if you like it more

			// Default behavior
			return false;
		}

		private function onGesture( event : org.gestouch.events.GestureEvent ) : void
		{
			var gesture : TapGesture = event.target as TapGesture;

			if ( gesture == singleTapGesture )
			{
				_observers.handleSingleTouch( singleTapGesture.location.x, singleTapGesture.location.y );
			}
		}
	}
}
