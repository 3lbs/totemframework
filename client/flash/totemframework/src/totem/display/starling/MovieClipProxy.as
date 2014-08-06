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

package totem.display.starling
{

	import starling.animation.IAnimatable;

	import totem.core.Destroyable;
	import totem.core.time.ITicked;
	import totem.core.time.TimeManager;

	public class MovieClipProxy extends Destroyable implements ITicked
	{

		internal static var disposed : Vector.<MovieClipProxy> = new Vector.<MovieClipProxy>();

		public static function create( animator : IAnimatable ) : MovieClipProxy
		{
			if ( disposed.length == 0 )
			{
				return new MovieClipProxy( animator );
			}
			return disposed.pop().reset( animator );
		}

		public static function destroy() : void
		{
			disposed.length = 0;
			disposed = null;
		}

		public static function grow( value : int ) : void
		{
			while ( value-- )
			{
				disposed.push( new MovieClipProxy());
			}
		}

		private var animator : IAnimatable;

		public function MovieClipProxy( animator : IAnimatable = null )
		{
			this.animator = animator;
		}

		public function get asset() : IAnimatable
		{
			return animator;
		}

		override public function destroy() : void
		{
			this.animator = null;

			super.destroy();
		}

		public function dispose() : MovieClipProxy
		{
			
			animator = null;
			
			var idx : int = disposed.indexOf( this );

			if ( idx > -1 )
				return this;

			disposed.push( this );

			return this;
		}

		public function onTick() : void
		{
			animator.advanceTime( TimeManager.TICK_RATE );
		}

		private function reset( animator : IAnimatable ) : MovieClipProxy
		{

			this.animator = animator;

			return this;
		}
	}
}
