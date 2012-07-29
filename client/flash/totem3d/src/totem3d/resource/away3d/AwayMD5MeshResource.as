package totem3d.resource.away3d
{
	import away3d.animators.SkeletonAnimationSet;
	import away3d.animators.SkeletonAnimator;
	import away3d.animators.data.Skeleton;
	import away3d.entities.Mesh;
	import away3d.events.AssetEvent;
	import away3d.events.ParserEvent;
	import away3d.library.assets.AssetType;
	import away3d.loaders.parsers.MD5MeshParser;

	import flash.utils.ByteArray;

	import totem3d.resource.MeshResource;

	public class AwayMD5MeshResource extends MeshResource
	{
		private var _mesh : Mesh;

		private var _valid : Boolean;

		private var _parser : MD5MeshParser;

		private var _animator : SkeletonAnimator;

		private var _animationSet : SkeletonAnimationSet;

		private var _skeleton : Skeleton;

		public function AwayMD5MeshResource()
		{
			super();
		}

		public function get mesh() : Mesh
		{
			return _mesh;
		}

		override public function initialize( data : * ) : void
		{
			if ( data is ByteArray )
			{
				// convert ByteArray data to a string
				data = ( data as ByteArray ).readUTFBytes(( data as ByteArray ).length );
			}

			_parser = new MD5MeshParser();

			_parser.addEventListener( ParserEvent.PARSE_COMPLETE, onParseComplete );
			_parser.addEventListener( AssetEvent.ASSET_COMPLETE, onAssetComplete );
			_parser.parseAsync( String( data ));

			//Logger.print ( this, "Got type error parsing XML: " + e.toString () );
			//_valid = false;

		}

		protected function onReadyForDependencies( event : ParserEvent ) : void
		{
			// TODO Auto-generated method stub

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

			if ( event.asset.assetType == AssetType.ANIMATION_SET )
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
			}

		}

		override public function destroy() : void
		{
			_mesh = null;

			removePaserListeners();
			
			_animator = null;
			_animationSet = null;
			_skeleton = null;
			_parser = null;
		}

		public function get animator():SkeletonAnimator
		{
			return _animator;
		}

		public function get animationSet():SkeletonAnimationSet
		{
			return _animationSet;
		}

		public function get skeleton():Skeleton
		{
			return _skeleton;
		}


	}
}

