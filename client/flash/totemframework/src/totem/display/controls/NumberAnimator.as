//------------------------------------------------------------------------------
//
//     _______ __ __           
//    |   _   |  |  |--.-----. 
//    |___|   |  |  _  |__ --| 
//     _(__   |__|_____|_____| 
//    |:  1   |                
//    |::.. . |                
//    `-------'      
//                       
//   3lbs Copyright 2013 
//   For more information see http://www.3lbs.com 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package totem.display.controls
{

	import com.greensock.TweenLite;
	import com.greensock.plugins.TransformAroundCenterPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.text.TextField;
	
	import org.casalib.util.NumberUtil;
	
	import totem.events.RemovableEventDispatcher;

	public class NumberAnimator extends RemovableEventDispatcher
	{
		private var _number : Number = 8000;

		private var _numberObject : NumberTween;

		private var _textField : TextField;

		public function NumberAnimator( tf : TextField )
		{
			_textField = tf;

			_numberObject = new NumberTween();
		}

		public function get number() : Number
		{
			return _number;
		}

		public function set number( value : Number ) : void
		{
			if ( value == _number )
				return;

			_numberObject.number = _number;
			_number = value;

			startAnimation();
		}

		public function update() : void
		{
			_textField.text = NumberUtil.format( Math.round( _numberObject.number ));
		}

		private function startAnimation() : void
		{
			
			TweenPlugin.activate([TransformAroundCenterPlugin]);
			//var time : Number = 
			TweenLite.to( _numberObject, 2, { number : _number, onUpdate: update } );
		}
	}
}

internal class NumberTween
{
	public var number : Number = 0;
}
