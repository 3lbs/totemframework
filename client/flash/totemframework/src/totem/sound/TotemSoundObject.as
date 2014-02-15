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

package totem.sound
{

	import flash.geom.Rectangle;
	
	import totem.core.TotemDestroyable;
	import totem.math.Vector2D;
	import totem.utils.EaseFuncUtil;

	/**
	 * sound object in a CitrusSoundSpace
	 */
	public class TotemSoundObject extends TotemDestroyable
	{

		public static var panAdjust : Function = EaseFuncUtil.easeInCubic;

		public static var volAdjust : Function = EaseFuncUtil.easeOutQuad;

		/**
		 * radius or this sound object. this determines at what distance will the sound start to get heard.
		 */
		public var radius : Number = 600;

		protected var _camVec : Vector2D = new Vector2D();

		//protected var _citrusObject : ISpriteView;

		protected var _enabled : Boolean = true;

		protected var _rect : Rectangle = new Rectangle();

		protected var _sounds : Vector.<TotemSoundInstance> = new Vector.<TotemSoundInstance>();

		protected var _space : TotemSpatialSound;

		protected var _volume : Number = 1;

		public function TotemSoundObject()
		{

			super( "" );

			/*_ce = CitrusEngine.getInstance();
			_space = _ce.state.getFirstObjectByType( CitrusSoundSpace ) as CitrusSoundSpace;*/

			/*if ( !_space )
				throw new Error( "[CitrusSoundObject] for " + citrusObject[ "name" ] + " couldn't find a CitrusSoundSpace." );*/

			//_citrusObject = citrusObject;
			_space.add( this );
		}

		public function get activeSoundInstances() : Vector.<TotemSoundInstance>
		{
			return _sounds.slice();
		}

		public function adjustPanning( value : Number ) : Number
		{
			if ( value <= -1 )
				return -1;
			else if ( value >= 1 )
				return 1;

			if ( value < 0 )
				return -panAdjust( -value, 0, 1, 1 );
			else if ( value > 0 )
				return panAdjust( value, 0, 1, 1 );
			return value;
		}

		public function adjustVolume( value : Number ) : Number
		{
			if ( value <= 0 )
				return 0;
			else if ( value >= 1 )
				return 1;

			return volAdjust( value, 0, 1, 1 );
		}

		public function get camVec() : Vector2D
		{
			return _camVec;
		}

		/*public function get citrusObject() : ISpriteView
		{
			return _citrusObject;
		}*/

		override public function destroy() : void
		{
			super.destroy();

			_space.remove( this );

			var soundInstance : TotemSoundInstance;

			for each ( soundInstance in _sounds )
				soundInstance.stop( true );

			_sounds.length = 0;
			_camVec = null;
			_space = null;
		}

		override public function initialize() : void
		{
			super.initialize();

		}

		/**
		 * pause a sound through this sound object
		 * @param	sound sound id (String) or CitrusSound
		 * @return
		 */
		public function pause( sound : * ) : void
		{
			var citrusSound : TotemSound;
			var soundInstance : TotemSoundInstance;

			if ( sound is String )
				citrusSound = soundPlayer.getSound( sound );
			else if ( sound is TotemSound )
				citrusSound = sound;

			if ( citrusSound )
				citrusSound.pause();
		}

		public function pauseAll() : void
		{
			var soundInstance : TotemSoundInstance;

			for each ( soundInstance in _sounds )
				soundInstance.pause();
		}

		/**
		 * play a sound through this sound object
		 * @param	sound sound id (String) or CitrusSound
		 * @return
		 */
		public function play( sound : * ) : TotemSoundInstance
		{
			var citrusSound : TotemSound;
			var soundInstance : TotemSoundInstance;

			if ( sound is String )
				citrusSound = soundPlayer.getSound( sound );
			else if ( sound is TotemSound )
				citrusSound = sound;

			if ( citrusSound != null )
			{
				soundInstance = citrusSound.createInstance( false, true );

				if ( soundInstance )
				{
					soundInstance.addEventListener( TotemSoundEvent.SOUND_START, onSoundStart );
					soundInstance.addEventListener( TotemSoundEvent.SOUND_END, onSoundEnd );
					soundInstance.play();
					updateSoundInstance( soundInstance, _camVec.length );
				}
			}

			return soundInstance;
		}

		public function get rect() : Rectangle
		{
			return _rect;
		}

		/**
		 * resume a sound through this sound object
		 * @param	sound sound id (String) or CitrusSound
		 * @return
		 */
		public function resume( sound : * ) : void
		{
			var citrusSound : TotemSound;
			var soundInstance : TotemSoundInstance;

			if ( sound is String )
				citrusSound = soundPlayer.getSound( sound );
			else if ( sound is TotemSound )
				citrusSound = sound;

			if ( citrusSound )
			{
				citrusSound.resume();
				updateSoundInstance( soundInstance, _camVec.length );
			}
		}

		public function resumeAll() : void
		{
			var soundInstance : TotemSoundInstance;

			for each ( soundInstance in _sounds )
				soundInstance.resume();
		}

		/**
		 * stop a sound through this sound object
		 * @param	sound sound id (String) or CitrusSound
		 * @return
		 */
		public function stop( sound : * ) : void
		{
			var citrusSound : TotemSound;
			var soundInstance : TotemSoundInstance;

			if ( sound is String )
				citrusSound = soundPlayer.getSound( sound );
			else if ( sound is TotemSound )
				citrusSound = sound;

			if ( citrusSound )
				citrusSound.stop();
		}

		public function stopAll() : void
		{
			var s : TotemSoundInstance;

			for each ( s in _sounds )
				s.stop();
		}

		public function get totalVolume() : Number
		{
			var soundInstance : TotemSoundInstance;
			var total : Number = 0;

			for each ( soundInstance in _sounds )
				total += soundInstance.leftPeak + soundInstance.rightPeak;

			if ( _sounds.length > 0 )
				total /= _sounds.length * 2;
			return total;
		}

		public function update() : void
		{
			if ( _enabled )
				updateSounds();
		}

		/**
		 * volume multiplier for this CitrusSoundObject
		 */
		public function get volume() : Number
		{
			return _volume;
		}

		public function set volume( value : Number ) : void
		{
			_volume = value;
		}

		protected function onSoundEnd( e : TotemSoundEvent ) : void
		{
			e.soundInstance.removeEventListener( TotemSoundEvent.SOUND_START, onSoundStart );
			e.soundInstance.removeEventListener( TotemSoundEvent.SOUND_END, onSoundEnd );
			e.soundInstance.removeSelfFromVector( _sounds );
		}

		protected function onSoundStart( e : TotemSoundEvent ) : void
		{
			_sounds.push( e.soundInstance );
		}

		protected function updateSoundInstance( soundInstance : TotemSoundInstance, distance : Number = 0 ) : void
		{
			var volume : Number = distance > radius ? 0 : 1 - distance / radius;
			soundInstance.volume = adjustVolume( volume ) * _volume;

			var panning : Number = ( Math.cos( _camVec.angle ) * distance ) / (( _rect.width / _rect.height ) * 0.5 );
			soundInstance.panning = adjustPanning( panning );
		}

		protected function updateSounds() : void
		{
			var distance : Number = _camVec.length;
			var soundInstance : TotemSoundInstance;

			for each ( soundInstance in _sounds )
			{
				if ( !soundInstance.isPlaying )
					return;
				updateSoundInstance( soundInstance, distance );
			}
		}
	}

}
