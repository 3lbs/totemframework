package totem.monitors.promise
{

	import flash.utils.clearInterval;
	import flash.utils.setTimeout;

	public function wait( delay : int, ... args ) : IPromise
	{

		function doInlineCallback() : *
		{
			var func : Function = args.length ? args[ 0 ] as Function : null, result : * = null;

			if ( func != null )
			{
				// 1) Remove function element,
				// 2) Call function, save response, and
				// 3) Clear arguments

				args.shift();

				result = func.apply( null, args );
				args = [];
			}

			return result;
		}

		//var timer : uint = setTimeout( complete, delay );

		return new Deferred( function( dfd : Deferred ) : void
		{
			var timer : uint = setTimeout( function() : void
			{
				clearInterval( timer );

				// Call the specified function (if any)

				var response : * = doInlineCallback();

				// Since resolve() expects a resultVal == *, we use the .call() invocation

				dfd.resolve.apply( dfd, response ? [ response ] : args.length ? args : null );

			}, delay );
		})
	}
}
