package totem.core.mvc.modular.mvcs
{
    import flash.events.Event;
    
    import totem.core.mvc.ContextDispatcher;
    import totem.core.mvc.modular.core.IModuleEventDispatcher;

    public class ModuleActor extends ContextDispatcher
    {
        /**
         * @private
         */
        protected var _moduleEventDispatcher:IModuleEventDispatcher;
        
        //---------------------------------------------------------------------
        //  Constructor
        //---------------------------------------------------------------------
        
        public function ModuleActor()
        {
        }
        
        //---------------------------------------------------------------------
        //  API
        //---------------------------------------------------------------------
        
        /**
         * @inheritDoc
         */
        public function get moduleEventDispatcher():IModuleEventDispatcher
        {
            return _moduleEventDispatcher;
        }
        
        [Inject]
        /**
         * @private
         */
        public function set moduleEventDispatcher(value:IModuleEventDispatcher):void
        {
            _moduleEventDispatcher = value;
        }
        
        protected function dispatchToModules(event:Event):Boolean
        {
            if(moduleEventDispatcher.hasEventListener(event.type))
               return moduleEventDispatcher.dispatchEvent(event);
            return true;
        }
		
		override public function destroy():void
		{
			super.destroy();
			
			_moduleEventDispatcher = null;
		}
    }
}