package totem.components
{

	import totem.core.TotemComponent;
	import totem.core.params.BaseParam;

	public class DataComponent extends TotemComponent
	{
		private var _entityParam : BaseParam;

		public function DataComponent( data : BaseParam, name : String = null )
		{
			super( name );

			_entityParam = data;
		}

		public function get entityParam() : BaseParam
		{
			return _entityParam;
		}
	}
}
