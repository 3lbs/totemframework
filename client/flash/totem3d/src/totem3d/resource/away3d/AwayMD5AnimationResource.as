package totem3d.resource.away3d
{
	import away3d.animators.SkeletonAnimationSet;
	import away3d.animators.SkeletonAnimationState;
	import away3d.events.AssetEvent;
	import away3d.events.ParserEvent;
	import away3d.library.assets.AssetType;
	import away3d.loaders.parsers.MD5AnimParser;

	import flash.utils.ByteArray;

	import totem3d.resource.AnimationResource;

	public class AwayMD5AnimationResource extends AnimationResource
	{

		private var _valid : Boolean;

		private var _parser : MD5AnimParser;

		public function AwayMD5AnimationResource()
		{
			super();
		}

		/**
		 * @inheritDoc
		 */
		override protected function onContentReady( content : * ) : Boolean
		{
			return _valid;
		}


		override public function initialize( data : * ) : void
		{
			if ( data is ByteArray )
			{
				// convert ByteArray data to a string
				data = ( data as ByteArray ).readUTFBytes(( data as ByteArray ).length );
			}

			_parser = new MD5AnimParser();

			_parser.addEventListener( ParserEvent.PARSE_COMPLETE, onParseComplete );
			//_parser.addEventListener ( AssetEvent.ASSET_COMPLETE, onAssetComplete );
			_parser.addEventListener( AssetEvent.ASSET_COMPLETE, onAssetComplete );
			/*_parser.addEventListener ( AssetEvent.ANIMATOR_COMPLETE, onAssetComplete );
			_parser.addEventListener ( AssetEvent.SKELETON_COMPLETE, onAssetComplete );
			_parser.addEventListener ( AssetEvent.SKELETON_POSE_COMPLETE, onAssetComplete );*/

			_parser.parseAsync( String( data ));

		}

		protected function onParseComplete( event : ParserEvent = null ) : void
		{
			removePaserListeners();
			_valid = true;

			onLoadComplete();
		}

		private function removePaserListeners() : void
		{
			if ( _parser )
			{
				_parser.removeEventListener( ParserEvent.PARSE_COMPLETE, onParseComplete );
				//_parser.removeEventListener ( AssetEvent.ASSET_COMPLETE, onAssetComplete );
				_parser.removeEventListener( AssetEvent.ASSET_COMPLETE, onAssetComplete );
				/*_parser.removeEventListener ( AssetEvent.ANIMATOR_COMPLETE, onAssetComplete );
				_parser.removeEventListener ( AssetEvent.SKELETON_COMPLETE, onAssetComplete );
				_parser.removeEventListener ( AssetEvent.SKELETON_POSE_COMPLETE, onAssetComplete );*/
			}
		}

		private var animationSet : SkeletonAnimationSet;

		private var _state : SkeletonAnimationState;

		private function onAssetComplete( event : AssetEvent ) : void
		{
			if ( event.asset.assetType == AssetType.ANIMATION_STATE )
			{

				_state = event.asset as SkeletonAnimationState;
				
				//trace( event.asset.assetNamespace );
				//animationSet.addState( event.asset.assetNamespace, state );

			}
		}

		override public function destroy() : void
		{
			super.destroy();

			removePaserListeners();
			_state = null;
			_parser = null;
		}

		public function get state():SkeletonAnimationState
		{
			return _state;
		}


	}
}

