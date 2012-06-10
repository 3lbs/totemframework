package totem.core.state 
{
    
    
    public class StateSystem extends StateMachine //implements ISystem
    {
        
        public function StateSystem(initState:State = null) 
        {
            super(initState);
        }
        
        public function onAdd():void
        {
            
        }
    }
}