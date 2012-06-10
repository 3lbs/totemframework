package totem.core.command.utils 
{
    import totem.core.command.Command;
    
    public class Wait extends Command
    {
        private var _time:Number;
        
        public function Wait(time:Number) 
        {
            _time = time;
        }
        
        override public function update(dt:Number):void 
        {
            _time -= dt;
            if (_time <= 0) complete();
        }
    }
}