package totem.core.command.utils 
{
    import totem.core.command.Command;
    
    public class Trace extends Command
    {
        public var message:String;
        
        public function Trace(message:String) 
        {
            this.message = message;
        }
        
        override public function execute():void 
        {
            trace(message);
            complete();
        }
    }
}