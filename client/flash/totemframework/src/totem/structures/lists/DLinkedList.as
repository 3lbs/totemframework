//------------------------------------------------------------------------------
//
//     _______ __ __           
//    |   _   |  |  |--.-----. 
//    |___|   |  |  _  |__ --| 
//     _(__   |__|_____|_____| 
//    |:  1   |                
//    |::.. . |                
//    `-------'      
//                       
//   3lbs Copyright 2013 
//   For more information see http://www.3lbs.com 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package totem.structures.lists
{

	import totem.structures.ICollection;
	import totem.structures.ITotemIterator;
	import totem.utils.string.TabularText;

	/**
	 * A doubly linked list, i.e. a list in which every element not only keeps a link to
	 * it's next but also to it's previous element, hence making it possible to also
	 * traverse backward along the list.
	 */
	public class DLinkedList extends AbstractList implements IList
	{
		//-----------------------------------------------------------------------------------------
		// Properties
		//-----------------------------------------------------------------------------------------

		/** @private */
		protected var _first : Node;

		/** @private */
		protected var _last : Node;

		/**
		 * Creates a new DLinkedList instance.
		 *
		 * @param elements Optional elements which are added to the list.
		 */
		public function DLinkedList( ... elements )
		{
			_size = 0;
			_first = _last = null;

			if ( elements.length > 0 )
			{
				append.apply( this, elements );
			}
		}

		//-----------------------------------------------------------------------------------------
		// Modification Operations
		//-----------------------------------------------------------------------------------------

		/**
		 * Adds the specified element to the end of the list. This does the same like
		 * calling append() with only one parameter. It is recommended to use the append()
		 * method instead. This methods exists here merely for the purpose to follow the
		 * collection interface.
		 *
		 * @param element The element to add to the list.
		 * @return true if the element was added successfully.
		 */
		public function add( element : * ) : Boolean
		{
			return append( element );
		}

		/**
		 * @inheritDoc
		 */
		override public function append( ... elements ) : Boolean
		{
			var l : int = elements.length;

			if ( l < 1 )
				return false;

			var node : Node = new Node( elements[ 0 ]);

			if ( _first )
			{
				_last.next = node;
				node.prev = _last;
				_last = node;
			}
			else
			{
				_first = _last = node;
			}

			if ( l > 1 )
			{
				for ( var i : int = 1; i < l; i++ )
				{
					node = new Node( elements[ i ]);
					_last.next = node;
					node.prev = _last;
					_last = node;
				}
			}

			_size += l;
			return true;
		}

		//-----------------------------------------------------------------------------------------
		// Bulk Operations
		//-----------------------------------------------------------------------------------------

		/**
		 * @inheritDoc
		 */
		public function clear() : void
		{
			var node : Node = _first;
			_first = null;

			var next : Node;

			while ( node )
			{
				next = node.next;
				node.next = node.prev = null;
				node = next;
			}
			_size = 0;
		}

		/**
		 * @inheritDoc
		 */
		public function clone() : *
		{
			var list : DLinkedList = new DLinkedList();
			list.addAll( this );
			return list;
		}

		/**
		 * @inheritDoc
		 */
		override public function contains( element : * ) : Boolean
		{
			if ( _size < 1 )
				return false;

			var node : Node = _first;

			while ( node )
			{
				if ( node.data === element )
					return true;
				node = node.next;
			}
			return false;
		}

		/**
		 * @inheritDoc
		 */
		public function dump() : String
		{
			var s : String = toString() + "\n";
			var t : TabularText = new TabularText( 3, false, "  " );
			var node : Node = _first;
			var i : int = 0;

			while ( node )
			{
				t.add([( i < 10 ? " " : "" ) + "[" + i + ": " + node.data, "P:" + ( node.prev ? "[" + node.prev.data + "]" : "NULL" ), "N:" + ( node.next ? "[" + node.next.data + "]" : "NULL" ) + "]" ]);
				node = node.next;
				i++;
			}

			return s + "\n" + t;
		}

		/**
		 * @inheritDoc
		 */
		public function equals( collection : ICollection ) : Boolean
		{
			if ( collection is DLinkedList )
			{
				var l : DLinkedList = DLinkedList( collection );
				var i : int = l.size;

				if ( i != _size )
					return false;

				while ( i-- )
				{
					if ( l.getElementAt( i ) != getElementAt( i ))
					{
						return false;
					}
				}

				return true;
			}

			return false;
		}

		//-----------------------------------------------------------------------------------------
		// Query Operations
		//-----------------------------------------------------------------------------------------

		/**
		 * @inheritDoc
		 */
		override public function getElementAt( index : int ) : *
		{
			if ( index < 0 || index >= _size )
			{
				return throwIndexOutOfBoundsException( index );
			}
			else
			{
				var current : Node = _first;
				var i : int = 0;

				while ( i < index )
				{
					current = current.next;
					i++;
				}
				return current.data;
			}
		}

		/**
		 * @inheritDoc
		 */
		public function indexOf( element : * ) : int
		{
			var current : Node = _first;
			var i : int = 0;

			while ( i < _size )
			{
				if ( current.data === element )
					return i;
				current = current.next;
				i++;
			}
			return -1;
		}

		/**
		 * @inheritDoc
		 */
		override public function insert( index : int, element : * ) : Boolean
		{
			if ( index >= _size )
			{
				return append( element );
			}
			else if ( index <= 0 )
			{
				return prepend( element );
			}
			else
			{
				var node : Node = new Node( element );
				var current : Node = _first;
				var prev : Node;
				var i : int = 0;

				while ( i < index )
				{
					prev = current;
					current = current.next;
					i++;
				}

				prev.next = node;
				node.prev = prev;
				node.next = current;
				current.prev = node;

				_size++;
				return true;
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get iterator() : ITotemIterator
		{
			return new ListIterator( this );
		}

		/**
		 * @inheritDoc
		 */
		public function join( separator : String = "," ) : String
		{
			if ( _size < 1 )
				return null;

			var s : String = "";
			var node : Node = _first;
			var i : int = 0;

			while ( node )
			{
				s += "" + node.data;

				if ( i < _size - 1 )
				{
					s += separator;
				}
				node = node.next;
				i++;
			}
			return s;
		}

		/**
		 * @inheritDoc
		 */
		public function prepend( ... elements ) : Boolean
		{
			var l : int = elements.length;

			if ( l < 1 )
				return false;
			var node : Node = new Node( elements[ int( l - 1 )]);

			if ( _first )
			{
				_first.prev = node;
				node.next = _first;
				_first = node;
			}
			else
			{
				_first = _last = node;
			}

			if ( l > 1 )
			{
				for ( var i : int = l - 2; i >= 0; i-- )
				{
					node = new Node( elements[ i ]);
					_first.prev = node;
					node.next = _first;
					_first = node;
				}
			}

			_size += l;
			return true;
		}

		/**
		 * @inheritDoc
		 */
		override public function remove( element : * ) : *
		{
			if ( _size < 1 )
				return null;

			if ( element === _first.data )
			{
				return removeFirst();
			}
			else if ( element === _last.data )
			{
				return removeLast();
			}

			var node : Node = _first;
			var i : int = 0;

			while ( i < _size - 2 )
			{
				i++;
				node = node.next;

				if ( node.data === element )
				{
					return removeAt( i );
				}
			}

			return null;
		}

		/**
		 * @inheritDoc
		 */
		override public function removeAt( index : int ) : *
		{
			if ( _size < 1 )
				return null;

			if ( index < 0 || index >= _size )
			{
				return throwIndexOutOfBoundsException( index );
			}
			else if ( index == 0 )
			{
				return removeFirst();
			}
			else if ( index == _size - 1 )
			{
				return removeLast();
			}
			else
			{
				var current : Node = _first;
				var prev : Node;
				var i : int = 0;

				while ( i < index )
				{
					prev = current;
					current = current.next;
					i++;
				}

				var node : Node = current;
				prev.next = current.next;
				current.next.prev = prev;
				_size--;
				return node.data;
			}
		}

		/**
		 * @inheritDoc
		 */
		public function removeFirst() : *
		{
			if ( _size < 1 )
				return null;

			var node : Node = _first;

			if ( _first.next == null )
			{
				_first = _last = null;
			}
			else
			{
				_first.next.prev = null;
				_first = _first.next;
			}

			_size--;
			return node.data;
		}

		/**
		 * @inheritDoc
		 */
		public function removeLast() : *
		{
			if ( _size < 1 )
				return null;

			var node : Node = _last;

			if ( _first.next == null )
			{
				_first = null;
			}
			else
			{
				_last.prev.next = null;
				_last = _last.prev;
			}

			_size--;
			return node.data;
		}

		/**
		 * @inheritDoc
		 */
		override public function replace( index : int, element : * ) : *
		{
			if ( _size < 1 )
				return null;

			if ( index < 0 || index >= _size )
			{
				return throwIndexOutOfBoundsException( index );
			}
			else
			{
				var node : Node = new Node( element );
				var current : Node = _first;

				/* Replace first */
				if ( index == 0 )
				{
					node.next = _first.next;
					node.next.prev = node;
					_first = node;
				}
				/* Replace last */
				else if ( index == _size - 1 )
				{
					current = _last;
					node.prev = _last.prev;
					_last.prev.next = node;
					_last = node;
				}
				/* Replace somewhere between first and last */
				else
				{
					var prev : Node;
					var i : int = 0;

					while ( i < index )
					{
						prev = current;
						current = current.next;
						i++;
					}

					prev.next = node;
					node.prev = prev;
					node.next = current.next;
					node.next.prev = node;
				}

				return current.data;
			}
		}

		/**
		 * @inheritDoc
		 */
		public function toArray() : Array
		{
			var a : Array = [];
			var node : Node = _first;

			while ( node )
			{
				a.push( node.data );
				node = node.next;
			}
			return a;
		}
	}
}

// ------------------------------------------------------------------------------------------------
/**
 * Node Class for DLinkedList
 * @private
 */
final class Node
{
	public var data : *;

	public var next : Node;

	public var prev : Node;

	/**
	 * Constructs a new Node instance for the DLinkedList.
	 * @param d the content data for the Node object.
	 */
	public function Node( d : * )
	{
		data = d;
		next = prev = null;
	}
}
