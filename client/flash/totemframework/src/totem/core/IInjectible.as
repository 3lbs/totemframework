package totem.core
{
  import org.swiftsuspenders.Injector;
  
  public interface IInjectible 
  {
    function getInjector():Injector;
    function setInjector(injector:Injector):void;
  }
}