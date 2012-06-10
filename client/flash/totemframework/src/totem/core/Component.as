package totem.core
{
	
  public class Component extends TotemObject implements IComponent
  {
    public function getOwner():TotemEntity
    {
      return getInstance(TotemEntity);
    }
    
    public function getSibling(ComponentClass:Class):*
    {
      return getInstance(ComponentClass);
    }
    
    public function Component()
    { }
    
    public function onAdded():void
    { }
    
    public function onRemoved():void
    { }
  }
}
