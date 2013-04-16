package totem.monitors.promise
{

	public class SerialDeferred
	{

		private const _resolveHandlerMap : Object = {};

		private static const PENDING : uint = 0;

		private static const RESOLVED : uint = 1;

		private static const REJECTED : uint = 2;

		private static const ABORTED : uint = 3;

		private var deferredList : Object;

		private var deferredCount : int;

		private var completeCount : int;

		private var _outcome : Deferred;

		private var _state : uint = PENDING;

		private var _resolveHandler : Function;

		public function SerialDeferred()
		{
			super();

			_outcome = new Deferred();
		}

		public function add( promise : IPromise ) : void
		{
			if ( promise == null )
				return;

			deferredCount++;

			_state = PENDING;
			
			promise.thenFinally( handleFinally );
		}

		public function resolveOn( outcomeProcessor : Function = null ) : SerialDeferred
		{
			_resolveHandler = outcomeProcessor;
			
			if ( completeCount >= deferredCount )
				_state = RESOLVED;
			
			onResolve();

			return this;
		}

		private function onResolve() : void
		{
			if ( _state == RESOLVED )
			{
				if ( _resolveHandler != null )
				{
					_outcome.resolve( _resolveHandler());
				}
				else
				{
					_outcome.resolve();
				}
				clear();
			}
		}

		private function handleFinally() : void
		{
			if ( ++completeCount >= deferredCount )
			{
				_state = RESOLVED;
				onResolve();
			}
		}

		public function promise() : IPromise
		{
			return _outcome;
		}

		private function clear() : void
		{
			_resolveHandler = null;
			_outcome = null;
		}

	}
}
