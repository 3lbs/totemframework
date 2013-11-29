/*
 Copyright (c) 2006 - 2010  Eric J. Feminella  <eric@ericfeminella.com>
 All rights reserved.

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is 
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in 
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN 
 THE SOFTWARE.
 
 @internal
 */

package com.ericfeminella.support.signals.binding
{
	import flash.utils.Dictionary;
	import org.osflash.signals.ISignal;
	
	/**
	 * 
	 * <code>SignalDataBinding</code> provides an API which allows for the creation 
	 * of pseudo data bindings for <code>Signal</code> instances against a property 
	 * of a host object.
	 * 
	 */	
	public class SignalDataBinding
	{
		/**
		 *
		 * <code>bindings</code> provides named references which are based on 
		 * the value of a unique <code>host.property</code> and the runtime 
		 * function which is bound to the specified <code>Signal</code> 
		 * against the <code>host.property</code>.
		 *  
		 */		
		protected var bindings:Dictionary = null;
		
		/**
		 *
		 * <code>allowOverwrites</code> determines if a new binding can be 
		 * defined for a previously defined binding. When set to false, which 
		 * is the default value, calls to <code>addBindableListener</code> 
		 * and <code>addOnceBindableListener</code> will result in an error.
		 * While when set to true, the existing binding between an object and
		 * it's property, and a <code>Signal</code> is removed and replaced 
		 * with a binding against the new <code>Signal</code>.
		 *  
		 */		
		protected var allowOverwrites:Boolean = false;
		
		/**
		 *
		 * <code>SignalDataBinding</code> constructor initiates the internal
		 * <code>bindings</code> map based on the values provided by the
		 * client.
		 *  
		 * @param Specifies if the bindings map is to use "weak" references 
		 * @param Specifies if binding overwrites are to be allowed.
		 * 
		 */		
		public function SignalDataBinding(useWeakReferences:Boolean = false, allowOverwrites:Boolean = false)
		{
			this.bindings = new Dictionary( useWeakReferences );
			this.allowOverwrites = allowOverwrites;
		}
		
		/**
		 *
		 * <code>addBindableListener</code> creates a data binding between
		 * the value associated with the specified <code>Signal</code> and 
		 * the <code>property</code> associated with the specified 
		 * <code>host</code>.
		 * 
		 * @example The following example demonstrates a typical implementation
		 * of <code>addBindableListener</code> between a view and an object.
		 * 
		 * <listing version="3.0">
		 * 
		 * // object, typically a model (i.e. Presentation Model, Domain Model, 
		 * // State etc.) however the object can be of any concern; that is, a
		 * // view or any other object.
		 * public final class Model
		 * {
		 * 		private var _bindings:SignalDataBinding = null;
		 * 		private var _messageChanged:Signal      = null;
		 * 		private var _message:String             = null;
		 * 	
		 * 		public function get message() : String 
		 * 		{ 
		 * 			return _message; 
		 * 		}
		 * 	
		 * 		public function set message(value:String) : void
		 * 		{
		 * 			_message = value;
		 * 			_messageChanged.dispatch( value );
		 * 		}
		 * 	    
		 *      // Model class provides an API for property specific bindings
		 *      // while not exposing the underlying binding mechanism, thus 
		 *      // allowing the data binding facility to be changed transparent 
		 *      // to that of a clients implementation.
		 * 		public function addMessageBinding(host:*, property:* ) : void
		 * 		{
		 * 			_bindings.addBindableListener( _messageChanged, host, property );
		 * 		}
		 * }
		 * 
		 * &lt;?xml version="1.0" encoding="utf-8"?&gt;
		 * &lt;s:Group xmlns:fx   = "http://ns.adobe.com/mxml/2009" 
		 * 		 xmlns:s    = "library://ns.adobe.com/flex/spark" 
		 * 		 initialize = "init();" &gt;
		 * 	&lt;fx:Script&gt;
		 * 		&lt;![CDATA[
		 *          // define the views presentation model instance
		 * 			private var _pm:TitleModel = null;
		 * 			
		 * 			protected function init() : void
		 * 			{
		 * 				_pm = new TitleModel();
		 *              // add binding to Presentation Models's 'title'
		 *              // property and views 'titleLabel.text' property.
		 *              // assignments to title will no be reflected in
		 *              // 'titleLabel.text'
		 * 				_pm.addTitleBinding( titleLabel, "text" );
		 * 			}
		 * 		]]&gt;
		 * 	&lt;/fx:Script&gt;
		 * 	&lt;s:Label id="titleLabel" /&gt;
		 * &lt;/s:Group&gt;
		 * 
		 * </listing>
		 *  
		 * @param  The <code>Signal</code> from which to add the binding.
		 * @param  The host object containing the property which is to be bound.
		 * @param  The property which is to be bound to the value associated
		 *         with the specific <code>Signal</code>.
		 * 
		 */		
		public function addBindableListener(signal:ISignal, host:*, property:*) : void
		{
			createBinding( signal, host, property );
		}
		
		/**
		 *
		 * <code>addOnceBindableListener</code> creates a one time data binding 
		 * between the value associated with the specified <code>Signal</code> 
		 * and the <code>property</code> associated of the specified 
		 * <code>host</code>.
		 *  
		 * @param  The <code>Signal</code> from which to add the binding.
		 * @param  The host object containing the property which is to be bound.
		 * @param  The property which is to be bound to the value associated
		 *         with the specific <code>Signal</code>.
		 * 
		 */		
		public function addOnceBindableListener(signal:ISignal, host:*, property:*) : void
		{
			createBinding( signal, host, property, false );
		}
		
		/**
		 *
		 * <code>hasBindableListener</code> determines if a binding currently exists 
		 * for the specified <code>host</code> and <code>property</code>.
		 * 
		 * @param  The host object containing the property which is to be bound.
		 * @param  The property which is to be bound to the value associated
		 *         with the specific <code>Signal</code>.
		 * @return true if the binding is currently registered, otherwise false.
		 * 
		 */		
		public function hasBindableListener(host:*, property:*) : Boolean
		{
			var id:String = host + property;
			var binding:SignalBinding = bindings[ id ];
			
			return binding != null && binding;
		}
		
		/**
		 *
		 * <code>removeBindableListener</code> removes a previously created 
		 * binding to a <code>Signal</code> from the <code>property</code> 
		 * associated of the specified <code>host</code>.
		 *   
		 * @param  The <code>Signal</code> from which to remove the binding.
		 * @param  The host object containing the property which is to be unbound.
		 * @param  The property which is to be released from future bindings against
		 *         the value associated with the specific <code>Signal</code>.
		 * 
		 */		
		public function removeBindableListener(signal:ISignal, host:*, property:*) : void
		{
			if ( hasBindableListener( host, property ) )
			{
				var id:String = host + property;
				var binding:SignalBinding = bindings[ id ];
				
				binding.signal.remove( binding.listener );
				binding = null;
				
				delete bindings[ id ];
			}
		}
		
		/**
		 *
		 * Creates a data binding between the value associated with the specified 
		 * <code>Signal</code> and the <code>property</code> associated with the 
		 * specified <code>host</code>.
		 * 
		 * <p>
		 * Bindings are uniquely identified by their fully qualified path of the
		 * <code>host</code> and <code>property</code>.
		 * </p>
		 *  
		 * @param  The <code>Signal</code> from which to add the binding.
		 * @param  The host object containing the property which is to be bound
		 * @param  The property which is to be bound to the value associated
		 *         with the specific <code>Signal</code>.
		 * @param  Determines if this is a <code>Signal.add</code> operation
		 *         or a <code>Signal.addOnce</code> operation. Default is
		 *         <code>Signal.add</code>
		 * 
		 */		
		protected function createBinding(signal:ISignal, host:*, property:*, add:Boolean = true) : void
		{
			var id:String = host + property;
			
			if ( bindings[ id ] != null && !allowOverwrites )
			{
				throw new Error( "Binding previously defined for " + id );
			}
			else
			{
				if ( hasBindableListener( host, property ) )
				{
					removeBindableListener( signal, host, property );
				}
				var listener:Function = createBindableListener( host, property );
				
				if ( add )
				{
					signal.add( listener );
				}
				else
				{
					signal.addOnce( listener );
				}
				bindings[ id ] = new SignalBinding( signal, listener );
			}
		}
		
		/**
		 *
		 * <code>createBindableListener</code> creates a runtime function which 
		 * assigns the value associated with the specified <code>Signal</code>
		 * to the <code>property</code> of the <code>host</code>.
		 *  
		 * @param  The host object containing the property which is to be bound
		 * @param  The property which is to be bound to the value associated
		 *         with the specific <code>Signal</code>.
		 * @return Function which contains the binding mechanism.
		 * 
		 */		
		protected function createBindableListener(host:*, property:*) : Function
		{
			return function listener(value:*) : void 
			{ 
				host[ property ] = value;
			}
		}
	}
}