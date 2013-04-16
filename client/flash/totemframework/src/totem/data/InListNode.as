package totem.data
{
	import totem.core.Destroyable;

  public class InListNode extends Destroyable
  {
    /** @private */
    internal var prev:InListNode = null;
    
    /** @private */
    internal var next:InListNode = null;
    
    /** @private */
    internal var list:InList = null;
  }
}