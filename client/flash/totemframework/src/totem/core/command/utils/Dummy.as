package totem.core.command.utils 
{
	import totem.core.command.Command;
	
	public class Dummy extends Command
	{
        public function Dummy() 
        {
            
        }
        
        override public function execute():void 
        {
            complete();
        }
	}
}