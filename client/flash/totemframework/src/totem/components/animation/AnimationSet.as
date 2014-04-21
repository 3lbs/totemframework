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

	import flash.utils.Dictionary;

	import totem.core.Destroyable;
	import totem.core.params.animation.AnimationDataParam;

	public class AnimationSet extends Destroyable
	{

		private var _animations : Dictionary = new Dictionary();

		private var animationStates : Dictionary = new Dictionary();

		public function AnimationSet()
		{
			super();
		}

		public function addAnimationData( data : AnimationDataParam ) : void
		{

			_animations[ data.name ] = data;

			for each ( var state : String in data.states )
			{
				if ( !state )
					continue;

				if ( !animationStates[ state ])
				{
					animationStates[ state ] = new Vector.<AnimationDataParam>();
				}

				animationStates[ state ].push( data );

			}
		}

		public function getAnimationData( name : String ) : AnimationDataParam
		{
			if ( !_animations[ name ])
			{
				throw new Error( "doesnt have animation" );
			}

			return _animations[ name ];
		}

		public function getAnimationState( state : String, name : String ) : AnimationDataParam
		{
			var animations : Vector.<AnimationDataParam> = animationStates[ state ];

			var l : int = animations.length;

			for ( var i = 0; i < l; ++i )
			{
				if ( animations[ i ].state == state )
				{
					return animations[ i ];
				}
			}

			return null;
		}

		public function getAnimationsForState( state : String ) : Vector.<AnimationDataParam>
		{
			return animationStates[ state ];
		}

		public function getRandomAnimationForState( state : String ) : AnimationDataParam
		{
			var animations : Vector.<AnimationDataParam> = animationStates[ state ];
			return animations[ Math.floor( Math.random() * animations.length )];
		}
	}
}
