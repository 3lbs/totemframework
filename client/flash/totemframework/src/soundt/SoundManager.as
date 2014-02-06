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

package soundt
{

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	import ladydebug.Logger;
	
	import totem.monitors.promise.wait;

	/**
	* Copyright © 2013. aswebcreations.com. All Rights Reserved.
	* @playerversion Flash 10, Flash 11
	* @langversion 3.0
	* @version 4.1.1.0
	*/
	/**
	* The SoundManager class is a singleton class that provides extensive sound management for streaming sounds.
	* All of the SoundManager methods are static.
	* @example
	* <listing>
	* SoundManager.addSound("testplay", "assets/all.mp3");
	* SoundManager.play("testplay");
	*
	* //or
	* SoundManager.SOUNDXML = mysoundxml;
	* SoundManager.BASEPATH = "myassetfolder/";
	* SoundManager.play("testplay");
	*
	* </listing>
	*
	* @playerversion Flash 10
	* @langversion 3.0
	*/
	public class SoundManager extends EventDispatcher
	{
		/**
		 * A base path to prepend to all loading sound when the SoundSmanager uses the SOUNDXML.
		 */
		public static var BASEPATH : String = '';

		/**
		 * If true all error are thrown, if false only SoundManagerEvent.SOUNDMANAGER_ERROR are dispatched.
		 */
		public static var DEBUGMODE : Boolean = true;

		/**
		 * A global SoundLoaderContext to apply by default to all external sounds (if sounds do not provide their own).
		 */
		public static var SOUNDCONTEXT : SoundLoaderContext = null;

		/**
		 * A global xml data that the SoundManager uses to fall back to when it's unable to find a sound.
		 */
		public static var SOUNDXML : XML;

		/**
		 * SoundManager version.
		 */
		public static const VERSION : String = "4.1.4";

		private static var instance : SoundManager;

		private static var isInstance : Boolean;

		/**
		 * Destroy the SoundManager instance and all its references. The next use of the SoundManager will create a new instance.
		 */
		public static function GC() : void
		{
			getInstance().stopAll();
			getInstance().GC();
			instance = null;
			SOUNDXML = null;
			BASEPATH = '';
		}

		/**
		 * Register a library Sound class with the SoundManager.
		 * @param	name. The name of this SoundGroup.
		 * @param	classref. The library Sound Class to register (an instance of that class will be created when first playing the sound).
		 * @param	volume. A default volume that will be applied to this sound.
		 * @param	loop. Whether this sound will autoloop.
		 * @param	overlap. Whether this SoundGroup can overlap itself.
		 * @param	overwrite. Whether this SoundGroup can overwrite itself.
		 * @return SoundGroup. The SoundGroup this sound belongs to.
		 */
		public static function addClass( name : String, classref : Class, volume : Number = 1, loop : Boolean = false, overlap : Boolean = true, overwrite : Boolean = false ) : SoundGroup
		{
			return getInstance().addClass( name, classref, volume, loop, overlap, overwrite );
		}

		/**
		 * Registers an event listener object with the Soundmanager instance so that the listener receives notification of a SoundManagerEvent.
		 * @param	type
		 * @param	listener
		 * @param	useCapture
		 * @param	priority
		 * @param	useWeakReference
		 */
		public static function addEventListener( type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = false ) : void
		{
			SoundManager.getInstance().addEventListener( type, listener, useCapture, priority, useWeakReference );
		}

		/**
		 * Register a external sound with the SoundManager.
		 * @param	name. The name of this SoundGroup.
		 * @param	url. The url where to load this sound.
		 * @param	volume. A default volume that will be applied to this sound.
		 * @param	loop. Whether this sound will autoloop.
		 * @param	overlap. Whether this SoundGroup can overlap itself.
		 * @param	overwrite. Whether this SoundGroup can overwrite itself.
		 * @param	autoloading. Whether to start loading this sound now or the first time it is played.
		 * @param	loadercontext. A SoundLoaderContext to apply to this sound.
		 * @return SoundGroup. The SoundGroup this sound belongs to.
		 */
		public static function addSound( name : String, url : String, volume : Number = 1, loop : Boolean = false, overlap : Boolean = true, overwrite : Boolean = false, autoloading : Boolean = false, loadercontext : SoundLoaderContext = null ) : SoundGroup
		{
			return getInstance().addSound( name, url, volume, loop, overlap, overwrite, autoloading, loadercontext );
		}

		/**
		 * Play and Fade this Sound.
		 * @param	value. The SoundGroup to play.
		 * @param	duration. The duration in seconds of the fadeIn effect.
		 * @param	finalvolume. The volume to fade to.
		 * @param	initialvolume. A new volume to overwrite the Sound default volume (overwrite occurs only for this SoundChannel).
		 * @param	position. The position in milliseconds at which to play the sound.
		 * @return SoundChannel. The created SoundChannel instance if successful.
		 */
		public static function fade( value : String, duration : Number = 1, finalvolume : Number = 1, autostop : Boolean = false ) : void
		{
			return getInstance().fade( value, duration, finalvolume, autostop );
		}

		/**
		 * Return one channel currently playing from this SoundGroup (use only if this SoundGroup has only one Sound playing).
		 * @param	name. The name of the SoundGroup.
		 * @return SoundChannel. A SoundChannel if currently playing.
		 */
		public static function getChannel( name : String ) : SoundChannel
		{
			return getInstance().getChannel( name );
		}

		/**
		 * Return a Vector.&#60;SoundChannel&#62; of all SoundChannel currently playing from that SoundGroup.
		 * @param	name. The SoundGroup.
		 * @return Vector.&#60;SoundChannel&#62;. A Vector.&#60;SoundChannel&#62; instance.
		 */
		public static function getChannels( name : String ) : Vector.<SoundChannel>
		{
			return getInstance().getChannels( name );
		}

		/**
		 * Return the SoundGroup with that name.
		 * @param	value. The name of the SoundGroup to return.
		 * @return SoundGroup. A SoundGroup instance.
		 */
		public static function getSoundGroup( value : String ) : SoundGroup
		{
			return getInstance().getSoundGroup( value );
		}

		/**
		 * Returns true if that SoundGroup is muted, false otherwise. If no value is passed return true if all sounds are muted, false otherwise.
		 * @param	value. The SoundGroup name.
		 * @return Boolean.
		 */
		public static function isMuted( value : String = null ) : Boolean
		{
			return getInstance().isMuted( value );
		}

		/**
		 * Return true if this SoundGroup is paused, false otherwise. If no value is passed return true if all SoundGroup are paused, false otherwise.
		 * @param	value. The SoundGroup to check or null for all SoundGroup.
		 * @return Boolean.
		 */
		public static function isPaused( value : String = null ) : Boolean
		{
			return getInstance().isPaused( value );
		}

		/**
		 * Start looping that SoundGroup.
		 * @param	value. The SoundGroup to play.
		 * @param	loops. The number of loops.
		 * @param	volume. A new volume to overwrite the Sound default volume (overwrite occurs only for this SoundChannel).
		 * @param	delay. The delay after which the sound should play.
		 * @return SoundChannel. The created SoundChannel instance if successful.
		 */
		public static function loop( value : String, loops : int, volume : Number = NaN, delay : Number = 0 ) : SoundChannel
		{
			return getInstance().loop( value, loops, volume, delay );
		}

		/**
		 * @private
		 */
		public static function get masterVolume() : Number
		{
			return getInstance().category.volume;
		}

		/**
		 * Set the global volume for the SoundManager SoundCategory instance. All SoundGroup that belong to this SoundCategory instance (default) will update their global volume.
		 * <listing>
		 * SoundManager.masterVolume = 0.8;
		 * </listing>
		 */
		public static function set masterVolume( value : Number ) : void
		{
			if ( value < 0 )
			{
				value = 0;
			}

			if ( value > 1 )
			{
				value = 1;
			}
			getInstance().category.volume = value;

			for ( var j : * in getInstance().channels )
			{
				var channelobject : SoundChannelObject = getInstance().channels[ j ];
				var sound : SoundObject = channelobject.sound;

				if ( !sound.group.category )
				{
					sound.group.category = getInstance().category;
				}

				if ( sound.group.category == getInstance().category )
				{
					channelobject.volume = sound.volume * getInstance().category.volume;
					var channel : SoundChannel = j as SoundChannel;
					var volume : Number = channel.soundTransform.volume;
					channel.soundTransform = new SoundTransform( channelobject.volume );
				}
			}
		}

		/**
		 * Mute this SoundGroup if it's playing.
		 * @param	value. The name of the SoundGroup to mute.
		 */
		public static function mute( value : String ) : void
		{
			return getInstance().mute( value );
		}

		/**
		 * Mute all SoundGroup that are playing.
		 */
		public static function muteAll( execptions : Array = null ) : void
		{
			return getInstance().muteAll( execptions );
		}

		/**
		 * Pause this SoundGroup.
		 * @param	value. The SoundGroup to pause.
		 */
		public static function pause( value : String ) : void
		{
			return getInstance().pause( value );
		}

		/**
		 * Pause all SoundGroup that are playing.
		 */
		public static function pauseAll( execptions : Array = null ) : void
		{
			return getInstance().pauseAll( execptions );
		}

		/**
		 * Start playing that SoundGroup.
		 * @param	value. The SoundGroup to play.
		 * @param	volume. A new volume to overwrite the Sound default volume (overwrite occurs only for this SoundChannel).
		 * @return SoundChannel. The created SoundChannel instance if successful.
		 */
		public static function play( value : String, volume : Number = NaN, delay : Number = 0 ) : SoundChannel
		{
			return getInstance().play( value, volume, delay );
		}

		/**
		 * Start playing this SoundGroup at this specified position (if possible).
		 * @param	value. The SoundGroup to play.
		 * @param	position. The position in milliseconds at which to play the sound.
		 * @param	volume. A new volume to overwrite the Sound default volume (overwrite occurs only for this SoundChannel).
		 * @return SoundChannel. The created SoundChannel instance if successful.
		 */
		public static function playAt( value : String, position : Number = 0, volume : Number = NaN ) : SoundChannel
		{
			return getInstance().playAt( value, position, volume );
		}

		/**
		 * Destroy the SoundManager internal sound references but keep in memory the SoundManager instance, its category, SOUNDCONTEXT, SOUNDXML, and BASEPATH.
		 */
		public static function purge() : void
		{
			getInstance().stopAll();
			getInstance().purge();
		}

		/**
		 * Resume this SoundGroup (If this SoundGroup is not playing equal a call to play())
		 * @param	value. The SoundGroup to resume.
		 */
		public static function resume( value : String ) : void
		{
			return getInstance().resume( value );
		}

		/**
		 * Resume all SoundGroup that were paused. Will affect only sounds that were paused.
		 */
		public static function resumeAll() : void
		{
			return getInstance().resumeAll();
		}

		/**
		 * Set global volume to all SoundGroup belonging to this SoundCategory.
		 * @param	name. The name of the SoundCategory.
		 * @param	value. The global volume for that category.
		 */
		public static function setCategoryVolume( name : String, value : Number ) : void
		{
			getInstance().setCategoryVolume( name, value );
		}

		/**
		 * Only for playing SoundGroup. Set the volume of this playing SoundGroup. No effect if SoundGroup is not playing.
		 * @param	name. The name of the SoundGroup.
		 * @param	volume. The volume to set this SoundGroup at.
		 */
		public static function setVolume( name : String, volume : Number ) : void
		{
			return getInstance().setVolume( name, volume );
		}

		/**
		 * Stop this SoundGroup.
		 * @param	value. The SoundGroup to stop.
		 */
		public static function stop( value : String ) : void
		{
			getInstance().stop( value );
		}

		/**
		 * Stop all SoundGroup currently playing.
		 */
		public static function stopAll( execptions : Array = null ) : void
		{
			return getInstance().stopAll( execptions );
		}

		/**
		 * Unmute this SoundGroup if it's muted.
		 * @param	value. The name of the SoundGroup to unmute.
		 */
		public static function unmute( value : String ) : void
		{
			return getInstance().unmute( value );
		}

		/**
		 * Unmute all SoundGroup that were muted.
		 */
		public static function unmuteAll() : void
		{
			return getInstance().unmuteAll();
		}

		/**
		 * @private
		 * @param	array
		 */
		internal static function checkSound( value : String ) : Boolean
		{
			var isSequenceValid : Boolean = true;
			var group : SoundGroup = getInstance().soundgroups[ value ];

			if ( group )
			{
				if ( !group.isSequenceCompatible())
				{
					isSequenceValid = false;
				}
			}
			else
			{
				if ( !checkXML( value ))
				{
					isSequenceValid = false;
				}
			}
			return isSequenceValid;
		}

		/**
		 * @private
		 * @param	context .(Optional) a SoundLoaderContext to apply by default on all loading sounds (overrided by each soundloadercontext in each sound if any).
		 * @return The current SoundManager instance.
		 */

		internal static function getInstance( context : SoundLoaderContext = null ) : SoundManager
		{
			if ( instance )
			{
				return instance;
			}
			isInstance = true;
			var ac : SoundManager = new SoundManager( context );
			isInstance = false;
			instance = ac;
			return ac;
		}

		/**
		 * @private
		 * @param	message
		 * @param	soundname
		 */
		internal static function throwError( message : String, soundname : String = null ) : void
		{
			if ( DEBUGMODE )
			{
				throw new Error( message );
			}
			else
			{
				var event : SoundManagerEvent = new SoundManagerEvent( SoundManagerEvent.SOUNDMANAGER_ERROR );
				event.error = message;
				event.soundname = soundname;
				instance.dispatchEvent( event );
			}
		}

		private static function checkXML( value : String ) : Boolean
		{
			var isSequenceValid : Boolean = true;

			if ( SOUNDXML )
			{
				try
				{
					var sounddata : XMLList = SOUNDXML.*.( NAME == value );

					if ( sounddata )
					{
						for ( var i : int = 0; i < sounddata.length(); i++ )
						{
							if ( sounddata[ i ].@loop == "true" )
							{
								isSequenceValid = false;
							}
						}
					}
					else
					{
						return false;
					}
				}
				catch ( e : Error )
				{
					return false;
				}
			}
			return isSequenceValid;
		}

		private var _isMuted : Boolean;

		private var _isPaused : Boolean;

		private var category : SoundCategory;

		private var channels : Dictionary;

		private var playingsounds : Object;

		private var soundgroups : Object;

		/**
		  * @private
		  *
		  */
		public function SoundManager( context : SoundLoaderContext )
		{
			if ( !isInstance )
			{
				throw new Error( "The SoundManager Class is a singleton class. You can't directly instantiate an instance of it. Use instead the getInstance() method." );
			}
			soundgroups = {};
			playingsounds = {};
			channels = new Dictionary();
			category = new SoundCategory( "" );
		}

		/**
		 * @private
		 */
		internal function GC() : void
		{
			SOUNDCONTEXT = null;
			instance = null;
			SOUNDXML = null;
			BASEPATH = null;
			category = null;
			playingsounds = null;
			channels = null;

			for ( var i : String in soundgroups )
			{
				var group : SoundGroup = soundgroups[ i ];
				group.GC();
			}
		}

		/**
		 * @private
		 * @param	name
		 * @param	classref
		 * @param	volume
		 * @param	loop
		 * @param	overlap
		 * @param	overwrite
		 * @return
		 */
		internal function addClass( name : String, classref : Class, volume : Number = 1, loop : Boolean = false, overlap : Boolean = false, overwrite : Boolean = false ) : SoundGroup
		{
			if ( !name || name == '' )
			{
				throwError( " name is empty or null. This sound cannot be registered. name: " + name, name );
				return null;
			}

			if ( !classref )
			{
				throwError( "Class is null. This sound cannot be registered. Class: " + classref, name );
				return null;
			}
			var group : SoundGroup;

			if ( soundgroups[ name ])
			{
				group = soundgroups[ name ] as SoundGroup;
			}
			else
			{
				group = new SoundGroup( name );
				group.category = category;
				group.loop = loop;
				group.volume = volume;
				group.overlap = overlap;
				group.overwrite = overwrite;
				soundgroups[ name ] = group;
			}

			if ( group.hasClass( classref ))
			{
				throwError( "This class is already registered with this SoundGroup instance: " + classref, name );
				return null;
			}
			var sound : SoundObject = new SoundObject( name );
			sound.classref = classref;
			sound.volume = volume;
			sound.group = group;
			group.addSound( sound );
			return group;
		}

		/**
		 * @private
		 * @param	name
		 * @param	url
		 * @param	volume
		 * @param	loop
		 * @param	overlap
		 * @param	overwrite
		 * @param	autoloading
		 * @param	loadercontext
		 * @return
		 */
		internal function addSound( name : String, url : String, volume : Number = 1, loop : Boolean = false, overlap : Boolean = false, overwrite : Boolean = false, autoloading : Boolean = false, loadercontext : SoundLoaderContext = null ) : SoundGroup
		{
			if ( !name || name == '' )
			{
				throwError( " name is empty or null. This sound cannot be registered. name: " + name, name );
				return null;
			}

			if ( !url || url == '' )
			{
				throwError( " url is empty or null. This sound cannot be registered. url: " + url, name );
				return null;
			}
			var context : SoundLoaderContext = loadercontext;

			if ( !context )
			{
				context = SOUNDCONTEXT;
			}
			var group : SoundGroup;

			if ( soundgroups[ name ])
			{
				group = soundgroups[ name ] as SoundGroup;
			}
			else
			{
				group = new SoundGroup( name );
				group.category = category;
				group.loop = loop;
				group.overlap = overlap;
				group.overwrite = overwrite;
				group.volume = volume;
				soundgroups[ name ] = group;
			}

			if ( group.hasUrl( url ))
			{
				throwError( "This url is already registered with this SoundGroup instance: " + url, name );
				return null;
			}
			var sound : SoundObject = new SoundObject( name );
			sound.url = url;
			sound.volume = volume;
			sound.autoload = autoloading;
			sound.loadcontext = loadercontext;
			sound.group = group;
			group.addSound( sound );
			return group;
		}

		/**
		 * @private
		 * @param	value
		 * @param	position
		 * @param	duration
		 * @param	volume
		 * @return
		 */
		internal function fade( value : String, duration : Number = 1, finalvolume : Number = 1, autostop : Boolean = false ) : void
		{
			var group : SoundGroup = soundgroups[ value ] as SoundGroup;

			if ( !group )
			{
				return;
			}
			group.isFading = true;
			var channels : Vector.<SoundChannel> = getChannels( value );

			if ( !channels.length )
			{
				return;
			}

			for ( var i : int = 0; i < channels.length; i++ )
			{
				var channelobject : SoundChannelObject = this.channels[ channels[ i ]];
				var sound : SoundObject = channelobject.sound;
				fadeInSound( sound.channel, finalvolume, duration, group, autostop );
			}
		}

		/**
		 * @private
		 * @param
		 * @return
		 */
		internal function getChannel( name : String ) : SoundChannel
		{
			for ( var j : * in channels )
			{
				var channelobject : SoundChannelObject = channels[ j ];
				var sound : SoundObject = channelobject.sound;

				if ( sound.group.groupname == name )
				{
					var channel : SoundChannel = j as SoundChannel;
					return channel;
				}
			}
			return null
		}

		/**
		 * @private
		 * @param	name
		 * @return
		 */
		internal function getChannels( name : String ) : Vector.<SoundChannel>
		{
			var copychannels : Vector.<SoundChannel> = new Vector.<SoundChannel>();

			for ( var j : * in channels )
			{
				var channelobject : SoundChannelObject = channels[ j ];
				var sound : SoundObject = channelobject.sound;

				if ( sound.group.groupname == name )
				{
					var channel : SoundChannel = j as SoundChannel;
					copychannels.push( channel );
				}
			}
			return copychannels;
		}

		/**
		 * @private
		 * @param	value
		 * @return
		 */
		internal function getSoundGroup( value : String ) : SoundGroup
		{
			return soundgroups[ value ];
		}

		/**
		 * @private
		 */
		internal function isMuted( value : String = null ) : Boolean
		{
			for ( var j : * in channels )
			{
				var channelobject : SoundChannelObject = channels[ j ];
				var sound : SoundObject = channelobject.sound;

				if ( !value && !sound.isMuted )
				{
					return false;
				}
				else if ( value && sound.group.groupname == value )
				{
					return sound.isMuted;
				}
			}
			return true;
		}

		/**
		 * @private
		 * @param	value
		 * @return
		 */
		internal function isPaused( value : String = null ) : Boolean
		{
			for ( var j : * in channels )
			{
				var channelobject : SoundChannelObject = channels[ j ];
				var sound : SoundObject = channelobject.sound;

				if ( !value && !sound.isPaused )
				{
					return false;
				}

				if ( value && sound.group.groupname == value )
				{
					return channelobject.isPaused;
				}
			}
			return true;
		}

		internal function loop( value : String, loops : int, volume : Number, delay : Number ) : SoundChannel
		{
			return this.playAt( value, 0, volume, delay, loops );
		}

		/**
		 * @private
		 *
		 */
		internal function mute( value : String ) : void
		{
			for ( var j : * in channels )
			{
				var channelobject : SoundChannelObject = channels[ j ];
				var sound : SoundObject = channelobject.sound;
				sound.isMuted = true;

				if ( sound.group.groupname == value )
				{
					channelobject.isMuted = true;
					var transform : SoundTransform = new SoundTransform( 0 );
					j.soundTransform = transform;
				}
			}
		}

		/**
		 * @private
		 *
		 */
		internal function muteAll( execptions : Array ) : void
		{
			for ( var j : * in channels )
			{
				var channelobject : SoundChannelObject = channels[ j ];
				var sound : SoundObject = channelobject.sound;

				if ( isExecption( sound.name, execptions ))
				{
					continue;
				}
				sound.isMuted = true;
				channelobject.isMuted = true;
				var transform : SoundTransform = new SoundTransform( 0 );
				j.soundTransform = transform;
			}
		}

		/**
		 * @private
		 * @param	value
		 */
		internal function pause( value : String ) : void
		{
			for ( var j : * in channels )
			{
				var channelobject : SoundChannelObject = channels[ j ];
				var sound : SoundObject = channelobject.sound;

				if ( sound.group.groupname == value )
				{
					sound.isPaused = true;
					sound.isPlaying = false;
					channelobject.position = j.position;
					channelobject.isPaused = true;
					j.removeEventListener( Event.SOUND_COMPLETE, checkChannelState );
					j.stop();
				}
			}
		}

		/**
		 * @private
		 */
		internal function pauseAll( execptions : Array ) : void
		{
			for ( var j : * in channels )
			{
				var channelobject : SoundChannelObject = channels[ j ];
				var sound : SoundObject = channelobject.sound;

				if ( isExecption( sound.name, execptions ))
				{
					continue;
				}
				sound.isPaused = true;
				sound.isPlaying = false;
				channelobject.position = j.position;
				channelobject.isPaused = true;
				j.removeEventListener( Event.SOUND_COMPLETE, checkChannelState );
				j.stop();
			}
		}

		/**
		 * @private
		 * @param	value
		 * @param	volume
		 * @return
		 */
		internal function play( value : String, volume : Number = NaN, delay : Number = 0 ) : SoundChannel
		{
			return this.playAt( value, 0, volume, delay );
		}

		/**
		 * @private
		 * @param	value
		 * @param	position
		 * @param	volume
		 * @return
		 */
		internal function playAt( value : String, position : Number = 0, volume : Number = NaN, delay : Number = 0, loops : int = 0 ) : SoundChannel
		{
			if ( delay > 0 )
			{
				//DelayTimer.add( delay, playAt, [ value, position, volume, 0, loops ], this, value );
				
				wait( delay, playAt, value, position, volume, 0, loops );
				return null;
			}
			var soundgroup : SoundGroup = soundgroups[ value ] as SoundGroup;

			if ( !soundgroup )
			{
				var event : SoundManagerEvent = new SoundManagerEvent( SoundManagerEvent.SOUNDMANAGER_ERROR );
				event.soundname = value;
				event.error = "The sound " + value + " is not registered with this SoundManager.";
				event.position = position;
				event.volume = volume || 1;
				dispatchEvent( event );

				if ( SOUNDXML )
				{
					try
					{
						var sounddata : XMLList = SOUNDXML.*.( NAME == value );

						if ( sounddata )
						{
							for ( var i : int = 0; i < sounddata.length(); i++ )
							{
								var autoload : Boolean;
								var looping : Boolean;
								var overlap : Boolean = true;
								var overwrite : Boolean;
								var dyvolume : Number = 1;

								if ( sounddata[ i ].@loop == "true" )
								{
									looping = true;
								}

								if ( sounddata[ i ].@overlap == "false" )
								{
									overlap = false;
								}

								if ( sounddata[ i ].@overwrite == "true" )
								{
									overwrite = true;
								}

								if ( sounddata[ i ].@autoloading == "true" )
								{
									autoload = true;
								}

								if ( !isNaN( Number( sounddata[ i ].@volume )) && Number( sounddata[ i ].@volume ) >= 0 && Number( sounddata[ i ].@volume ) <= 1 )
								{
									dyvolume = Number( sounddata[ i ].@volume );
								}

								try
								{
									var classref : Class = getDefinitionByName( sounddata[ i ].PATH ) as Class;
									addClass( sounddata[ i ].NAME, classref, dyvolume, looping, overlap, overwrite );
								}
								catch ( e : Error )
								{
									addSound( sounddata[ i ].NAME, BASEPATH + sounddata[ i ].PATH, dyvolume, looping, overlap, overwrite, autoload, SOUNDCONTEXT );
								}
							}
							return playAt( value, position, volume, delay, loops );
						}
					}
					catch ( e : Error )
					{
						throwError( "Could not find " + value + " in SOUNDXML. Playing aborted.", value );
					}
				}
				else
				{
					throwError( "Could not find " + value + ". Playing aborted.", value );
				}
				return null;
			}
			var sound : SoundObject = soundgroup.getSound();

			if ( !soundgroup.category )
			{
				soundgroup.category = category;
			}
			var soundvolume : Number = soundgroup.getVolume( soundgroup.volume );

			if ( !isNaN( volume ))
			{
				soundvolume = soundgroup.getVolume( volume );
				sound.volume = volume;
			}

			if ( position < 0 || isNaN( position ))
			{
				position = 0;
			}
			return setChannel( sound, position, soundvolume, soundgroup, false, 0, NaN, loops );
		}

		/**
		 * @private
		 */
		internal function purge() : void
		{
			for ( var i : String in soundgroups )
			{
				var group : SoundGroup = soundgroups[ i ];
				group.GC();
			}
			soundgroups = {};
			playingsounds = {};
			channels = new Dictionary();
		}

		/**
		 * @private
		 * @param	value
		 */
		internal function resume( value : String ) : void
		{
			var channel : SoundChannel;

			for ( var j : * in channels )
			{
				var channelobject : SoundChannelObject = channels[ j ];
				var sound : SoundObject = channelobject.sound;

				if ( sound.group.groupname == value && sound.isPaused )
				{
					sound.isPaused = false;
					delete channels[ j ];
					delete playingsounds[ sound.name ];
					channel = setChannel( sound, channelobject.position, channelobject.volume, sound.group );
				}
			}

			if ( !channel )
			{
				play( value );
			}
		}

		/**
		 * @private
		 */
		internal function resumeAll() : void
		{
			for ( var j : * in channels )
			{
				var channelobject : SoundChannelObject = channels[ j ];
				var sound : SoundObject = channelobject.sound;
				sound.isPaused = false;
				delete channels[ j ];
				delete playingsounds[ sound.name ];
				setChannel( sound, channelobject.position, channelobject.volume, sound.group );
			}
		}

		/**
		 * @private
		 * @param	name
		 * @param	value
		 */
		internal function setCategoryVolume( name : String, value : Number ) : void
		{
			if ( value < 0 )
			{
				value = 0;
			}

			if ( value > 1 )
			{
				value = 1;
			}

			for ( var j : * in channels )
			{
				var channelobject : SoundChannelObject = channels[ j ];
				var sound : SoundObject = channelobject.sound;

				if ( sound.group.category.name == name )
				{
					sound.group.category.volume = value;
					channelobject.volume = sound.volume * sound.group.category.volume;
					var channel : SoundChannel = j as SoundChannel;
					var volume : Number = channel.soundTransform.volume;
					channel.soundTransform = new SoundTransform( channelobject.volume );
				}
			}
		}

		/**
		 * @private
		 * @param	name
		 * @param	volume
		 */
		internal function setVolume( name : String, volume : Number ) : void
		{
			for ( var j : * in channels )
			{
				var channelobject : SoundChannelObject = channels[ j ];
				var sound : SoundObject = channelobject.sound;

				if ( sound.group.groupname == name )
				{
					if ( !sound.group.category )
					{
						sound.group.category = category;
					}
					channelobject.volume = sound.group.getVolume( volume );
					sound.volume = volume;
					var channel : SoundChannel = j as SoundChannel;
					var trnasform : SoundTransform = channel.soundTransform;
					trnasform.volume = channelobject.volume;
					channel.soundTransform = trnasform;
				}
			}
			return;
		}

		/**
		 * @private
		 * @param	value
		 */
		internal function stop( value : String ) : void
		{
			for ( var j : * in channels )
			{
				var channelobject : SoundChannelObject = channels[ j ];
				var sound : SoundObject = channelobject.sound;
				sound.isPlaying = false;

				if ( sound.group.groupname == value )
				{
					sound.channel.removeEventListener( Event.SOUND_COMPLETE, checkChannelState );
					sound.channel.stop();
					delete channels[ j ];
					delete playingsounds[ sound.group.groupname ];
				}
			}
			getSoundGroup( value ).stop();
			//DelayTimer.stop( value );
		}

		/**
		 * @private
		 */
		internal function stopAll( execptions : Array = null ) : void
		{
			if ( !execptions )
			{
				SoundMixer.stopAll();
			}

			for ( var j : * in channels )
			{
				var channel : SoundChannel = j as SoundChannel;

				if ( !channel )
				{
					delete channels[ j ];
					delete playingsounds[ sound.name ];
					continue;
				}
				var channelobject : SoundChannelObject = channels[ j ];
				var sound : SoundObject = channelobject.sound;

				if ( isExecption( sound.name, execptions ))
				{
					continue;
				}
				channel.removeEventListener( Event.SOUND_COMPLETE, checkChannelState );
				channel.stop();
				sound.group.stop();
				sound.isPlaying = false;
				sound.isPaused = false;
				sound.isMuted = false;
				delete channels[ j ];
				delete playingsounds[ sound.name ];
			}
			//DelayTimer.stopAll();
		}

		/**
		* @private
		*
		*/
		internal function unmute( value : String ) : void
		{
			for ( var j : * in channels )
			{
				var channelobject : SoundChannelObject = channels[ j ];
				var sound : SoundObject = channelobject.sound;

				if ( sound.group.groupname == value && sound.isMuted )
				{
					sound.isMuted = false;
					channelobject.isMuted = false;
					var transform : SoundTransform = new SoundTransform( channelobject.volume );
					j.soundTransform = transform;
				}
			}
		}

		/**
		 * @private
		 *
		 */
		internal function unmuteAll() : void
		{
			for ( var j : * in channels )
			{
				var channelobject : SoundChannelObject = channels[ j ];
				var sound : SoundObject = channelobject.sound;

				if ( sound.isMuted )
				{
					sound.isMuted = false;
					channelobject.isMuted = false;
					var transform : SoundTransform = new SoundTransform( channelobject.volume );
					j.soundTransform = transform;
				}
			}
		}

		/**
		 * @private
		 * @param	e
		 */
		private function checkChannelState( e : Event ) : void
		{
			var channel : SoundChannel = e.currentTarget as SoundChannel;

			if ( !channel )
			{
				return;
			}
			channel.removeEventListener( Event.SOUND_COMPLETE, checkChannelState );
			var channelobject : SoundChannelObject = channels[ channel ];
			var group : SoundGroup = channelobject.sound.group;
			delete playingsounds[ channelobject.sound.group.groupname ];
			delete channels[ channel ];

			if ( channelobject.isAutoLooping )
			{
				return;
			}

			if ( channelobject.sound.group.loop )
			{
				if ( VolumeTween.isFading( channel ))
				{
					var property : VolumeProperty = VolumeTween.getProperty( channel, true, group );

					if ( property.currentStep == property.steps )
					{
						var fadeevent : SoundManagerEvent = new SoundManagerEvent( SoundManagerEvent.SOUNDMANAGER_END_FADE );
						fadeevent.soundGroup = group;
						dispatchEvent( fadeevent );
						group.isFading = false;
						channelobject.volume = property.finalvolume;

						if ( property.autostop )
						{
							return;
						}
						setChannel( channelobject.sound, 0, group.getVolume( channelobject.volume ), channelobject.sound.group );
						return;
					}
					var duration : Number = (( property.duration / property.delay ) - property.currentStep ) * property.delay * 0.001;
					fadeInSound( setChannel( channelobject.sound, 0, property.transform.volume, channelobject.sound.group ), property.finalvolume, duration, group, property.autostop );
					return;
				}
				setChannel( channelobject.sound, 0, group.getVolume( channelobject.volume ), channelobject.sound.group );
				return;
			}
		}

		/**
		 * @private
		 * @param	channel
		 * @param	volume
		 * @param	duration
		 */
		private function fadeInSound( channel : SoundChannel, volume : Number, duration : Number, group : SoundGroup, autostop : Boolean ) : void
		{
			VolumeTween.to( channel, duration, volume, autostop, group );
		}

		private function isExecption( name : String, execptions : Array ) : Boolean
		{
			if ( execptions )
			{
				for ( var i : int = 0; i < execptions.length; i++ )
				{
					if ( execptions[ i ] == name )
					{
						return true;
					}
				}
			}
			return false;
		}

		/**
		 * @private
		 * @param	sound
		 * @param	position
		 * @param	volume
		 * @param	group
		 * @param	fadein
		 * @param	duration
		 * @return
		 */
		private function setChannel( sound : SoundObject, position : Number, volume : Number, group : SoundGroup, fadein : Boolean = false, duration : Number = 0, fadevolume : Number = NaN, loops : int = 0 ) : SoundChannel
		{
			if ( playingsounds[ group.groupname ] == true )
			{
				if ( !group.overlap && !group.overwrite )
				{
					return null;
				}
				else if ( group.overwrite )
				{
					stop( group.groupname );
				}
			}

			if ( loops > 0 )
			{
				var channel : SoundChannel = sound.play( position, loops );
			}
			else
			{
				channel = sound.play( position );
			}

			if ( !channel )
			{
				throwError( "Unable to play this sound: " + group.groupname, group.groupname );
				return null;
			}
			var transform : SoundTransform;

			if ( fadein && !sound.isPaused && !sound.isMuted )
			{
				transform = new SoundTransform( volume );
				channel.soundTransform = transform;
				fadeInSound( channel, fadevolume, duration, group, false );
			}
			else
			{
				transform = new SoundTransform( volume );
				channel.soundTransform = transform;
			}
			playingsounds[ group.groupname ] = true;
			channels[ channel ] = new SoundChannelObject( sound, position, volume );

			if ( loops > 0 )
			{
				channels[ channel ].isAutoLooping = true;
			}

			if ( sound.isPaused )
			{
				channel.stop();
				channels[ channel ].isPaused = true;
			}

			if ( sound.isMuted )
			{
				channels[ channel ].isMuted = true;
				transform = new SoundTransform( 0 );
				channel.soundTransform = transform;
			}
			channel.addEventListener( Event.SOUND_COMPLETE, checkChannelState );
			sound.isPlaying = true;

			if ( DEBUGMODE )
			{
				Logger.info( this, "setChannel", "SoundManager playing: " + group.groupname )
			}
			return channel;
		}
	}
}
