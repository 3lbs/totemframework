/*******************************************************************************
 * PushButton Engine
 * Copyright (C) 2009 PushButton Labs, LLC
 * For more information see http://www.pushbuttonengine.com
 *
 * This file is licensed under the terms of the MIT license, which is included
 * in the License.html file at the root directory of this SDK.
 ******************************************************************************/
package totem.animation
{
    import flash.utils.Dictionary;
    
    import totem.core.TotemComponent;
	
    /**
     * Component for animating any value on its owner.
     */
    public class AnimatorComponent extends TotemComponent
    {
        /**
         * A list of all the animation that can be played by this component.
         */
        public var animations:Dictionary = null;

        /**
         * Whether or not to start the animation when the component is registered.
         */
        [EditorData(defaultValue="true")]
        public var autoPlay:Boolean = true;

        /**
         * The name of the animation to automatically start playing when the component
         * is registered.
         */
        public var defaultAnimation:String = "Idle";
		
        /**
         * A reference to the property that will be animated.
         */
        //public var reference:PropertyReference = null;

        private var _currentAnimation:Animator = null;

		/**
         * @inheritDoc
         */
        public function onFrame(elapsed:Number):void
        {
            if (_currentAnimation)
            {
                _currentAnimation.animate(elapsed);                               
                //owner.setProperty(reference, _currentAnimation.currentValue);
            }
        }

        /**
         * Plays an animation that is on this component.
         *
         * @param animation The name of the animation in the Animations dictionary
         * to play.
         * @param startValue The value to start at. If this is null (the default), the
         * start value won't be changed.
         */
        public function play(animation:String, startValue:* = null):void
        {
        	if (_currentAnimation && _currentAnimation.isAnimating)
        		   _currentAnimation.stop();
        	
            _currentAnimation = animations[animation];
            if (!_currentAnimation)
                return;

            if (startValue)
                _currentAnimation.startValue = startValue;

            _currentAnimation.reset();
            _currentAnimation.play();
        }

        /**
         * @inheritDoc
         */
        protected function onReset():void
        {
            if (!autoPlay || _currentAnimation)
                return;

            play(defaultAnimation);
        }
    }
}