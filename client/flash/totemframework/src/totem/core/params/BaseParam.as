package totem.core.params
{
	import flash.utils.getQualifiedClassName;
	
	import org.casalib.util.StringUtil;

	/**
	 *
	 * @author eddie
	 */
	public class BaseParam
	{
		private var _id : String;

		private var _type : Object;

		private var _name : String;

		private var _empty : Boolean;

		/**
		 *
		 */
		public function BaseParam()
		{
			_name = getQualifiedClassName( this ).split( "::" )[ 1 ] + "_" + StringUtil.createRandomIdentifier( 3 );
			_id = _name + StringUtil.createRandomIdentifier( 4 );
		}

		/**
		 *
		 * @return Game ID
		 */
		public function get id() : String
		{
			return _id;
		}

		/**
		 *
		 * @param value
		 */
		public function set id( value : String ) : void
		{
			_id = value;
		}

		/**
		 *
		 * @param value
		 */
		public function set type( value : Object ) : void
		{
			_type = value;
		}

		/**
		 *
		 * @return Object type
		 */
		public function get type() : Object
		{
			return _type;
		}

		/**
		 *
		 * @return Object Instance human readable name
		 */
		public function get name() : String
		{
			return _name;
		}

		/**
		 *
		 * @param value
		 */
		public function set name( value : String ) : void
		{
			_name = value;
		}


		/**
		 *
		 * @return
		 */
		public function isEmpty() : Boolean
		{
			return _empty;
		}

	}
}

