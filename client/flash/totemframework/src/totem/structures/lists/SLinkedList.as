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

	public class SLinkedList extends AbstractList implements IList
	{
		protected var _first : Node;

		protected var _last : Node;

		public function SLinkedList( ... elements )
		{
			_size = 0;
			_first = _last = null;

			if ( elements.length > 0 )
			{
				append.apply( this, elements );
			}
		}

		public function add( element : * ) : Boolean
		{
			return append( element );
		}

		override public function append( ... elements ) : Boolean
		{
			var l : int = elements.length;

			if ( l < 1 )
				return false;
			var node : Node = new Node( elements[ 0 ]);

			if ( _first )
			{
				_last.next = node;
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
					_last = node;
				}
			}

			_size += l;
			return true;
		}

		public function clear() : void
		{
			var node : Node = _first;
			_first = null;

			var next : Node;

			while ( node )
			{
				next = node.next;
				node.next = null;
				node = next;
			}
			_size = 0;
		}

		/**
		 * @inheritDoc
		 */
		public function clone() : *
		{
			var list : SLinkedList = new SLinkedList();
			list.addAll( this );
			return list;
		}

		override public function contains( element : * ) : Boolean
		{
			if ( _size < 1 )
			{
				return false;
			}

			var node : Node = _first;

			while ( node )
			{
				if ( node.data === element )
				{
					return true;
				}
				node = node.next;
			}
			return false;
		}

		public function dump() : String
		{
			var s : String = toString();
			var node : Node = _first;
			var i : int = 0;

			while ( node )
			{
				s += "\n[" + i + ":" + node.data + "]";

				if ( node.next )
				{
					s += " > ";
				}
				node = node.next;
				i++;
			}

			return s;
		}

		public function equals( collection : ICollection ) : Boolean
		{
			if ( collection is SLinkedList )
			{
				var l : SLinkedList = SLinkedList( collection );
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
				node.next = current;
				_size++;

				return true;
			}
		}

		public function get iterator() : ITotemIterator
		{
			var iter : ListIterator = new ListIterator( this );
			return iter;
		}

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

		public function prepend( ... elements ) : Boolean
		{
			var l : int = elements.length;

			if ( l < 1 )
				return false;
			var node : Node = new Node( elements[ int( l - 1 )]);

			if ( _first )
			{
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
					node.next = _first;
					_first = node;
				}
			}

			_size += l;
			return true;
		}

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
				_size--;
				return node.data;
			}
		}

		public function removeFirst() : *
		{
			if ( _size < 1 )
				return null;

			var node : Node = _first;

			if ( _first.next == null )
			{
				_last = null;
			}
			_first = _first.next;
			_size--;
			return node.data;
		}

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
				var prev : Node = _first;

				while ( prev.next != _last )
				{
					prev = prev.next;
				}

				_last = prev;
				prev.next = null;
			}

			_size--;
			return node.data;
		}

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
				var prev : Node;
				var i : int = 0;

				if ( index == 0 )
				{
					node.next = _first.next;
					_first = node;
				}
				else if ( index == _size - 1 )
				{
					while ( i < _size - 2 )
					{
						current = current.next;
						prev = current;
						i++;
					}
					current = _last;
					node.next = null;
					_last = node;
					prev.next = _last;
				}
				else
				{
					while ( i < index )
					{
						prev = current;
						current = current.next;
						i++;
					}

					prev.next = node;
					node.next = current.next;
				}

				return current.data;
			}
		}

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

class Node
{
	public var data : *;

	public var next : Node;

	public function Node( d : * )
	{
		data = d;
		next = null;
	}
}
