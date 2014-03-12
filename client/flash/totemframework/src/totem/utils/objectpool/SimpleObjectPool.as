//------------------------------------------------------------------------------////     _______ __ __           //    |   _   |  |  |--.-----. //    |___|   |  |  _  |__ --| //     _(__   |__|_____|_____| //    |:  1   |                //    |::.. . |                //    `-------'      //                       //   3lbs Copyright 2014 //   For more information see http://www.3lbs.com //   All rights reserved. ////------------------------------------------------------------------------------//------------------------------------------------------------------------------////     _______ __ __           //    |   _   |  |  |--.-----. //    |___|   |  |  _  |__ --| //     _(__   |__|_____|_____| //    |:  1   |                //    |::.. . |                //    `-------'      //                       //   3lbs Copyright 2014 //   For more information see http://www.3lbs.com //   All rights reserved. ////------------------------------------------------------------------------------//------------------------------------------------------------------------------////     _______ __ __           //    |   _   |  |  |--.-----. //    |___|   |  |  _  |__ --| //     _(__   |__|_____|_____| //    |:  1   |                //    |::.. . |                //    `-------'      //                       //   3lbs Copyright 2014 //   For more information see http://www.3lbs.com //   All rights reserved. ////------------------------------------------------------------------------------//------------------------------------------------------------------------------////     _______ __ __           //    |   _   |  |  |--.-----. //    |___|   |  |  _  |__ --| //     _(__   |__|_____|_____| //    |:  1   |                //    |::.. . |                //    `-------'      //                       //   3lbs Copyright 2014 //   For more information see http://www.3lbs.com //   All rights reserved. ////------------------------------------------------------------------------------//------------------------------------------------------------------------------////     _______ __ __           //    |   _   |  |  |--.-----. //    |___|   |  |  _  |__ --| //     _(__   |__|_____|_____| //    |:  1   |                //    |::.. . |                //    `-------'      //                       //   3lbs Copyright 2013 //   For more information see http://www.3lbs.com //   All rights reserved. ////------------------------------------------------------------------------------package totem.utils.objectpool{	public class SimpleObjectPool	{		public var clean : Function;		public var create : Function;		public var minSize : int;		private var _size : int = 0;		private var disposed : Boolean = false;		private var length : int = 0;		private var list : Array = [];		public function SimpleObjectPool( create : Function = null, clean : Function = null, minSize : int = 0 )		{			this.create = create;			this.clean = clean;			this.minSize = minSize;			if ( create )				for ( var i : int = 0; i < minSize; i++ )					add();		}		public function add() : void		{			list[ length++ ] = create();			_size++;		}		public function checkIn( item : * ) : void		{			if ( clean != null )				clean( item );			list[ length++ ] = item;		}		public function checkOut() : *		{			if ( length == 0 )			{				if ( create )				{					_size++;					return create();				}				return null;			}			return list[ --length ];		}		public function dispose() : void		{			if ( disposed )				return;			disposed = true;			create = null;			clean = null;			while ( list.length > 0 )			{				list.pop(); //.destroy();			}			list.length = 0;			list = null;		}		public function get size() : int		{			return _size;		}	}}