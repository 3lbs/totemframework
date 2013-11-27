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

package totem.components.motion
{

	import totem.core.time.TimeManager;

	public class MotionComponent extends Moving2DComponent
	{

		public var steering : IMotion;

		public function MotionComponent( data : MovingParam, name : String = "" )
		{
			super( data, name );
		}

		override public function onTick() : void
		{
			canDispatch = false;

			setInitialValues( TimeManager.TICK_RATE );

			// might move the regulator to here

			steering && calculateSteering();

			calculateFinalVelocity();

			updateHeading();

			updatePosition();

			canDispatch = true;
			// update assets
			
			dirtyPosition = true;
			
			dispatchUpdate();
			//updateChildren( a_timePassed );
		}
		
		override protected function updatePosition():void
		{
			super.updatePosition();
		}

		public function setMotion( motion : IMotion ) : IMotion
		{
			steering = motion;
			steering.setComponent( this );
			return motion;
		}

		protected function calculateSteering() : void
		{
			acc = steering.calculate();
			velocity.x += acc.x;
			velocity.y += acc.y;
			
			trace( "test = " + TimeManager.TICK_RATE_MS );
		}
	}
}
