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

package totem.core.task
{

	import org.casalib.util.NumberUtil;

	public class RandomSequenceTask extends SequenceTask
	{
		public function RandomSequenceTask( name : String = null )
		{
			setName(( name == null ) ? "[RandomSequentialTaskGroup]" : name );
			super( name );
		}

		protected function _sortRandom( a : *, b : * ) : int
		{
			return NumberUtil.randomIntegerWithinRange( 0, 1 ) ? 1 : -1;
		}

		override protected function doStart() : void
		{
			allTasks.sort( _sortRandom, Array.RETURNINDEXEDARRAY );
			super.doStart();
		}
	}
}