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

	import totem.core.time.TickedComponent;
	import totem.observer.NotifBroadcaster;

	public class AnimatorComponent extends TickedComponent implements IAnimator
	{

		public var _broadcaster : NotifBroadcaster = new NotifBroadcaster();

		public function AnimatorComponent( name : String )
		{
			super( name );
		}

		public function get broadcaster() : NotifBroadcaster
		{
			return _broadcaster;
		}

		public function pauseAnimation() : void
		{

		}

		public function playAnimation( animName : String, type : AnimatorEnum = null ) : void
		{

		}

		public function stopAnimation() : void
		{

		}

		override protected function onRemove() : void
		{
			super.onRemove();
			stopAnimation();
			broadcaster.destroy();
		}

		override protected function onRetire() : void
		{
			super.onRetire();
			stopAnimation();
		}
		
		override public function destroy () : void
		{
			super.destroy();
			stopAnimation();
			broadcaster.destroy();
		}
	}
}
