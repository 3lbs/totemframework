package totem3d.resource.away3d
{
	import away3d.events.AssetEvent;
	import away3d.events.ParserEvent;
	import away3d.loaders.parsers.AWDParser;
	import away3d.loaders.parsers.ParserBase;

	import flash.utils.ByteArray;

	import totem3d.resource.MeshResource;

	public class AwayAWDResource extends MeshResource
	{
		private var _parser : ParserBase;

		private var _valid : Boolean;

		public function AwayAWDResource()
		{
			super();
		}

		override public function initialize( data : * ) : void
		{
			if ( data is ByteArray )
			{
				// convert ByteArray data to a string
				data = ( data as ByteArray ).readUTFBytes(( data as ByteArray ).length );
			}

			_parser = new AWDParser();

			_parser.addEventListener( ParserEvent.PARSE_COMPLETE, onParseComplete );
			_parser.addEventListener( AssetEvent.ASSET_COMPLETE, onAssetComplete );
			_parser.parseAsync( String( data ));

			//Logger.print ( this, "Got type error parsing XML: " + e.toString () );
			//_valid = false;

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
				_parser.removeEventListener( AssetEvent.ASSET_COMPLETE, onAssetComplete );
			}
		}

		/**
		 * @inheritDoc
		 */
		override protected function onContentReady( content : * ) : Boolean
		{
			return _valid;
		}

		protected function onAssetComplete( event : AssetEvent ) : void
		{

			/*if ( event.asset.assetType == AssetType.ANIMATION_SET )
			{
				_animationSet = event.asset as SkeletonAnimationSet;
				_animator = new SkeletonAnimator( animationSet, skeleton );

				_mesh.animator = animator;
			}
			else if ( event.asset.assetType == AssetType.SKELETON )
			{
				_skeleton = event.asset as Skeleton;
			}
			else if ( event.asset.assetType == AssetType.MESH )
			{
				_mesh = event.asset as Mesh;
			}*/

		}
	}
}
