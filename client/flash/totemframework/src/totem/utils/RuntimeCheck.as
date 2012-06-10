package totem.utils
{
	
	import flash.errors.IllegalOperationError;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	
	public class RuntimeCheck {
		
		/**
		 *   Runtime checks for abstract classes and methods
		 *   Checks if callee is a subclass and has defined indicated methods.
		 *   Should normally be called from the constructor of the abstract class.
		 *
		 *   Note: Abstract method checks only work for public functions
		 *
		 *   @param      instance                calling object (the 'this' keyword)
		 *   @param      abstractClass           the class name of the abstract class
		 *   @param      abstractMethodList      array of strings indicating the method names
		 *                                       of abstract methods
		 *   @exception  IllegalOperationError   if abstract class has not been subclassed or
		 *                                       indicated methods have not been defined in subclass
		 *   @author     Chandima Cumaranatunge
		 *   @version    0.1
		 *
		 *   Usage:
		 *    public class AbstractClass {
		 *       public function AbstractClass() {
		 *           RuntimeCheck.abstractClass(this, AbstractClass, ['abstractMethodOne', 'abstractMethodTwo']);
		 *       }
		 *       public function abstractMethodOne():void {}
		 *       public function abstractMethodTwo():void {}
		 *   }
		 */
		public static function abstractClass(instance:Object, abstractClass:Class, abstractMethodList:Array = null):void 
		{
			var instanceClassName:String = getQualifiedClassName(instance);
			if (instance.constructor === abstractClass) 
			{
				throw new IllegalOperationError("Abstract class '" + instanceClassName + "' must be subclassed and not instantiated.");
			}
			else 
			{
				var description:XML = describeType(instance);
				//trace(description);
				for each (var fnName:String in abstractMethodList) {
					var overridenFlag:Boolean = false;
					for (var pname:String in description.method) {
						if(description.method.@name[pname].toString() == fnName) {
							overridenFlag = (description.method.@declaredBy[pname].toString() === instanceClassName);
						}
					}
					if (!overridenFlag) {
						throw new IllegalOperationError("Abstract method '" + fnName + "' must be overridden and implemented in subclass.");
					}
				}
			}
		}
	}
}

