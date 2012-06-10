/*
* Copyright 2007-2011 the original author or authors.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*      http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/
package org.as3commons.metadata.registry.impl {
	import org.as3commons.bytecode.reflect.ByteCodeType;
	import org.as3commons.bytecode.reflect.ByteCodeTypeProvider;
	import org.as3commons.lang.ClassUtils;
	import org.as3commons.reflect.Type;

	/**
	 * An <code>IMetadataProcessorRegistry</code> implementation that uses the as3commons-bytecode to retrieve
	 * a list of classnames that are decorated with any of the metadata names specified by the registered <code>IMetadataProcessors</code>.<br/>
	 * It uses as3commons-reflect to retrieve the type information that will be passed to the processors.<br/>
	 * This implementation assumes that before its <code>execute()</code> method is invoked <code>BytecodeType.metadataLookupFromLoader()</code> has been invoked.
	 * @author Roland Zwaga
	 */
	public class BytecodeMetadataProcessorRegistry extends AS3ReflectMetadataProcessorRegistry {

		/**
		 * Creates a new <code>BytecodeMetadataProcessorRegistry</code> instance.
		 */
		public function BytecodeMetadataProcessorRegistry() {
			super();
		}

		/**
		 * Loops through all of the registered metadata names and checks whether any class names were found by the BytecodeType parser that are annotated with any
		 * of the specified names. If so, the <code>Class</code> is retrieved for the class name and the <code>process()</code> method is invoked with it.
		 */
		public function execute():void {
			for (var metadataName:String in metadataLookup) {
				var classNames:Array = ByteCodeType.metaDataLookup[metadataName];
				for each (var className:String in classNames) {
					var clazz:Class = ClassUtils.forName(className, ByteCodeTypeProvider.currentApplicationDomain);
					process(clazz);
				}
			}
		}

		/**
		 * @inheritoDoc
		 */
		override public function process(target:Object, params:Array=null):* {
			var type:Type = Type.forClass(Class(target));
			processType(type, target, params);
		}
	}
}
