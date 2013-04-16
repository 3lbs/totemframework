package totem.utils
{
	
	final public class VectorUtil
	{
		
		/**
		 Returns the first element that matches <code>match</code> for the property <code>key</code>.
		
		 @param inArray: Array to search for an element with a <code>key</code> that matches <code>match</code>.
		 @param key: Name of the property to match.
		 @param match: Value to match against.
		 @return Returns matched item; otherwise <code>null</code>.
		 */
		public static function getItemByKey( iterable:*, key : String, match : * ) : *
		{
			for each ( var item : * in iterable )
				if ( item.hasOwnProperty ( key ) )
					if ( item[ key ] == match )
						return item;
			
			return null;
		}
		
		/**
		 Returns every element that matches <code>match</code> for the property <code>key</code>.
		
		 @param inArray: Array to search for object with <code>key</code> that matches <code>match</code>.
		 @param key: Name of the property to match.
		 @param match: Value to match against.
		 @return Returns all the matched items.
		 */
		public static function getItemsByKey( iterable:*, key : String, match : * ) : Array
		{
			var t : Array = new Array ();
			
			for each ( var item : * in iterable )
				if ( item.hasOwnProperty ( key ) )
					if ( item[ key ] == match )
						t.push ( item );
			
			return t;
		}
		
		public static function convertVectorToArray( iterable:* ) : Array
		{
			var t : Array = new Array ();
			
			for each ( var item : * in iterable )
					t.push ( item );
			
			return t;
		}
	}
}

