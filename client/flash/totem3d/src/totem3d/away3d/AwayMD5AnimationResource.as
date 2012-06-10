package totem3d.away3d
{
	import away3d.animators.data.SkeletonAnimationSequence;
	import away3d.events.AssetEvent;
	import away3d.events.ParserEvent;
	import away3d.loaders.parsers.MD5AnimParser;
	
	import flash.utils.ByteArray;
	
	import totem.resource.Resource;
	
	public class AwayMD5AnimationResource extends Resource
	{
		public var sequence : SkeletonAnimationSequence;
		
		private var _valid : Boolean;
		
		private var _parser : MD5AnimParser;
		
		public function AwayMD5AnimationResource()
		{
			super ();
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
				data = ( data as ByteArray ).readUTFBytes ( ( data as ByteArray ).length );
			}
			
			_parser = new MD5AnimParser ();
			
			_parser.addEventListener ( ParserEvent.PARSE_COMPLETE, onParseComplete );
			//_parser.addEventListener ( AssetEvent.ASSET_COMPLETE, onAssetComplete );
			_parser.addEventListener ( AssetEvent.ANIMATION_COMPLETE, onAssetComplete );
			/*_parser.addEventListener ( AssetEvent.ANIMATOR_COMPLETE, onAssetComplete );
			_parser.addEventListener ( AssetEvent.SKELETON_COMPLETE, onAssetComplete );
			_parser.addEventListener ( AssetEvent.SKELETON_POSE_COMPLETE, onAssetComplete );*/
			
			_parser.parseAsync ( String ( data ) );
		
		}
		
		protected function onParseComplete( event : ParserEvent = null ) : void
		{
			removePaserListeners ();
			_valid = true;
			
			onLoadComplete ();
		}
		
		private function removePaserListeners() : void
		{
			if ( _parser )
			{
				_parser.removeEventListener ( ParserEvent.PARSE_COMPLETE, onParseComplete );
				//_parser.removeEventListener ( AssetEvent.ASSET_COMPLETE, onAssetComplete );
				_parser.removeEventListener ( AssetEvent.ANIMATION_COMPLETE, onAssetComplete );
				/*_parser.removeEventListener ( AssetEvent.ANIMATOR_COMPLETE, onAssetComplete );
				_parser.removeEventListener ( AssetEvent.SKELETON_COMPLETE, onAssetComplete );
				_parser.removeEventListener ( AssetEvent.SKELETON_POSE_COMPLETE, onAssetComplete );*/
			}
		}
		
		private function onAssetComplete( event : AssetEvent ) : void
		{
			if ( event.asset is SkeletonAnimationSequence )
			{
				sequence = event.asset as SkeletonAnimationSequence;		
					//sequence.name = event.asset.assetNamespace;
			}
		}
		
		override public function destroy():void
		{
			super.destroy();
			
			if ( sequence )
			{			
				sequence = null;
			}
			
			removePaserListeners();
			_parser = null;
		}
	
	}
}

