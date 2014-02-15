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

package totem.components.effects
{

	import starling.extensions.PDParticleSystem;

	import totem.core.TotemComponent;

	public class ParticleEffectComponent extends TotemComponent
	{
		private var mParticleSystem : PDParticleSystem;

		public function ParticleEffectComponent( name : String = null )
		{
			super( name );
		}

		override protected function onAdd() : void
		{
			super.onAdd();

			// create particle system
		/*mParticleSystem = new PDParticleSystem(psConfig, psTexture);
		mParticleSystem.emitterX = 320;
		mParticleSystem.emitterY = 240;

		// add it to the stage and the juggler
		addChild(mParticleSystem);
		Starling.juggler.add(mParticleSystem);

		// start emitting particles
		mParticleSystem.start();

		// stop emitting particles
		mParticleSystem.stop();*/
		}
	}
}
