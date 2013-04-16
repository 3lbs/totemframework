package totem.core.action.utils
{
  import totem.core.action.Action;
	
  public class InvokeAction extends Action
  {
    public var func:Function;
    public var args:Array;
    
    public function InvokeAction(func:Function, ...args)
    {
      this.func = func;
      this.args = args;
      
      onStarted.addOnce(init);
    }
    
    private function init():void 
    {
      func.apply(null, args);
      complete();
    }
  }
}
