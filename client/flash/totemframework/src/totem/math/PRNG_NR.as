package totem.math
{

	

	public class PRNG_NR
	{

		private var _st : int;

		private var _en : int;

		private var _len : int;

		private var _numPos : uint;

		private var _randNums : Array;

		private var _seed : uint;

		private var randGen:PM_PRNG;

		public function PRNG_NR( st : int, en : int, seed : uint = 1 )
		{
			_st = st;
			_en = en;
			_seed = seed;

			_len = _en - _st + 1;
			shuffle();
		}

		public function get seed():uint
		{
			return _seed;
		}

		public function set seed(value:uint):void
		{
			_seed = value;
		}

		public function getNum() : Number
		{
			// if passed last item:
			if ( _numPos == _len )
				shuffle();

			var result : Number = _randNums[ _numPos ];
			_numPos++;
			return result;
		}

		private function shuffle() : void
		{
			_numPos = 0;
			_randNums = [];
			//_nums = [];

			// Creating Numbers Array:
			var i : int;

			for ( i = 0; i < _len; i++ )
			{
				_randNums[ i ] = _st + i;
			}

			// Creating shuffled Numbers Array:
			i = 0;

			randGen = new PM_PRNG( _seed );

			_randNums = randomize( _randNums );

			trace( _randNums );
		}

		private function randomize( inArray : Array ) : Array
		{
			var t : Array = new Array();
			var r : Array = inArray.sort( _sortRandom, Array.RETURNINDEXEDARRAY );
			var i : int = -1;

			while ( ++i < inArray.length )
				t.push( inArray[ r[ i ]]);

			return t;
		}

		private function _sortRandom( a : *, b : * ) : int
		{
			return randGen.nextIntRange( 0, 1 ) ? 1 : -1;
		}

		public function get len() : int
		{
			return _len;
		}

		public function destroy() : void
		{
			_randNums.length = 0;
		}
	}

}
