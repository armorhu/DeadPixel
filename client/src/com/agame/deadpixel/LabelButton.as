package com.agame.deadpixel
{
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;

	public class LabelButton extends Sprite
	{
		public var textfiled:TextField;
		public var tiggerHandler:Function;

		public function LabelButton(text:String='', width:Number=128, height:Number=64, size:int=30, color:uint=0x0)
		{
			super();
			textfiled=Game.createTextfiled(text, width, height, size, color);
			addChild(textfiled);
			this.addEventListener(TouchEvent.TOUCH, accessory_touchHandler);
			this.name=text;
		}

		/**
		 * @private
		 */
		protected function accessory_touchHandler(event:TouchEvent):void
		{
			if (this.touchPointID >= 0)
			{
				var touch:Touch=event.getTouch(this, TouchPhase.ENDED, this.touchPointID);
				if (!touch)
					return;
				Game.playSound(Game.touch, 0);
				if (tiggerHandler != null)
					tiggerHandler();
				dispatchEventWith(Event.TRIGGERED, true);
				this.touchPointID=-1;
			}
			else //if we get here, we don't have a saved touch ID yet
			{
				touch=event.getTouch(this, TouchPhase.BEGAN);
				if (touch)
				{
					this.touchPointID=touch.id;
				}
			}
		}

		private var _touchPointID:int=-1;

		protected function get touchPointID():int
		{
			return _touchPointID;
		}

		protected function set touchPointID(value:int):void
		{
			_touchPointID=value;
		}

	}
}
