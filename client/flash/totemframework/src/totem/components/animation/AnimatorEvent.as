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

package totem.components.animation
{

	import flash.events.Event;
	
	import totem.animation.Animator;

	/**
	 * Event type used by the Animator class to indicate when certain playback events have happened.
	 */
	public class AnimatorEvent extends Event
	{

		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------

		/**
		 * This event is dispatched by an Animator when the animation completely finishes.
		 *
		 * @eventType ANIMATION_FINISHED_EVENT
		 */
		public static const ANIMATION_FINISHED_EVENT : String = "ANIMATION_FINISHED_EVENT";
		
		
		public static const ANIMATION_LOOPED_COMPLETE : String = "ANIMATION_LOOP_COMPLETE";

		/**
		 * This event is dispatched by an Animator when the animation has finished one iteration
		 * and is repeating.
		 *
		 * @eventType ANIMATION_REPEATED_EVENT
		 */
		public static const ANIMATION_REPEATED_EVENT : String = "ANIMATION_REPEATED_EVENT";

		/**
		 * This event is dispatched by an Animator when the animation is resumed after being manually
		 * stopped.
		 *
		 * @eventType ANIMATION_RESUMED_EVENT
		 */
		public static const ANIMATION_RESUMED_EVENT : String = "ANIMATION_RESUMED_EVENT";

		/**
		 * This event is dispatched by an Animator when the animation first starts.
		 *
		 * @eventType ANIMATION_STARTED_EVENT
		 */
		public static const ANIMATION_STARTED_EVENT : String = "ANIMATION_STARTED_EVENT";

		/**
		 * This event is dispatched by an Animator when the animation is manually stopped.
		 *
		 * @eventType ANIMATION_STOPPED_EVENT
		 */
		public static const ANIMATION_STOPPED_EVENT : String = "ANIMATION_STOPPED_EVENT";

		/**
		 * The Animator that triggered the event.
		 */
		public var animation : Animator = null;

		public function AnimatorEvent( type : String, animation : Animator, bubbles : Boolean = true, cancelable : Boolean = false )
		{
			animation = animation;
			super( type, bubbles, cancelable );
		}
	}
}

