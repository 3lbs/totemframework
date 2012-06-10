package totem.core
{
    import totem.totem_internal;
    
    use namespace totem_internal
    
    /**
     * SmashSet provides safe references to one or more SmashObjects. When the
     * referenced SmashObjects are destroy()ed, then they are automatically removed
     * from any SmashSets. 
     */
    public class TotemSet extends TotemObject
    {
        protected var items:Vector.<TotemObject> = new Vector.<TotemObject>;
        
        public function TotemSet(_name:String = null)
        {
            super(_name);
        }

        /**
         * Add a SmashObject to the set. 
         */
        public function add(object:TotemObject):void
        {
            items.push(object);
            object.noteSetAdd(this);
        }
        
        /**
         * Remove a SmashObject from the set.
         */
        public function remove(object:TotemObject):void
        {
            var idx:int = items.indexOf(object);
            if(idx == -1)
                throw new Error("Requested SmashObject is not in this SmashSet.");
            items.splice(idx, 1);
            object.noteSetRemove(this);
        }
        
        /**
         * Does this SmashSet contain the specified object? 
         */
        public function contains(object:TotemObject):Boolean
        {
            return (items.indexOf(object) != -1);
        }
        
        /**
         * How many objects are in the set?
         */
        public function get length():int
        {
            return items.length;
        }
        
        /**
         * Return the object at the specified index of the set.
         */
        public function getSmashObjectAt(index:int):TotemObject
        {
            return items[index];
        }
    }
}