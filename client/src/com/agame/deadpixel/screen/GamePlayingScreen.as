package com.agame.deadpixel.screen
{
	import com.agame.deadpixel.Game;

	import flash.geom.Rectangle;

	import feathers.controls.Screen;

	import starling.display.Button;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.extensions.advancedjoystick.JoyStick;
	import starling.filters.ColorMatrixFilter;

	public class GamePlayingScreen extends Screen
	{
		public static const SCREEN_ID:String='GamePlayingScreen';

		private var joystick:JoyStick;
		private var button:Button;

		private var colors:Array;
		private var light:Array;
		private var dark:Array;

		private var level:int;

		private var cell:Quad;
		private var canvas:Quad;
		private var gray:int=8421504;
		public var colorTransfrom:ColorMatrixFilter;

		private var cellWidth:Number;
		private var cellHeihgt:Number;
		public var randomArea:Rectangle;

		public function GamePlayingScreen()
		{
			super();
		}

		override protected function initialize():void
		{
			// Initializing and adding Joystick with DEFAULT skin.
			joystick=new JoyStick(null, null, true, 2 / Game.scale);
			joystick.setPosition(joystick.minOffsetX, Game.stageHeight - joystick.minOffsetY);
			joystick.alpha=0.5;
			addChild(joystick);
			trace(joystick.minOffsetY * 2);

			button=new Button(joystick.getHolderTexture());
			button.pivotX=button.width / 2;
			button.pivotY=button.height / 2;
			button.x=Game.stageWidth - joystick.minOffsetX;
			button.y=Game.stageHeight - joystick.minOffsetY;
			button.addEventListener(Event.TRIGGERED, triggeredButtonHandler);
			addChild(button);

			this.light=[9079434, 9079433, 9079177, 9013641, 9013640, 9013384, 8947848, 8947847, 8947591, 8882055, 8882054, 8881798, 8816262, 8816261, 8816005, 8750469, 8750468, 8750212, 8684676, 8684675, 8684419, 8618883, 8618882, 8618626, 8553090];
			this.dark=[7763574, 7763575, 7763831, 7829367, 7829368, 7829624, 7895160, 7895161, 7895417, 7960953, 7960954, 7961210, 8026746, 8026747, 8027003, 8092539, 8092540, 8092796, 8158332, 8158333, 8158589, 8224125, 8224126, 8224382, 8289918];
			this.colors=[16711680, 16711935, 16711782, 13369599, 10027263, 6684927, 3342591, 13311, 26367, 39423, 52479, 65535, 3394611, 6736947, 10092339, 13434675, 16763955, 16750899, 16737792, 16724736, 6655, 65509, 32767, 65458, 65407, 65357, 65306, 5046016, 8388352, 11665152, 15007488, 16770304, 13382466, 13382517, 16724909, 16724959, 12006399, 8729599, 5046527, 1704191];

			cellWidth=cellHeihgt=16;

			canvas=new Quad(Game.screenArea.width, Game.screenArea.height);
			canvas.x=Game.screenArea.x, canvas.y=Game.screenArea.y;

			randomArea=Game.screenArea.clone();
			randomArea.x+=cellWidth;
			randomArea.y+=cellHeihgt;
			randomArea.width-=cellWidth * 2;
			randomArea.height-=cellHeihgt * 2;

			canvas.color=gray;
			canvas.filter=new ColorMatrixFilter;
			addChild(canvas);
			cell=new Quad(cellWidth, cellHeihgt, 0x0);
			cell.filter=new ColorMatrixFilter;
			addChild(cell);

			colorTransfrom=new ColorMatrixFilter();

			addEventListener(Event.ENTER_FRAME, onUpdate);
		}

		private function triggeredButtonHandler():void
		{
			// TODO Auto Generated method stub
			nextLevel();
		}

		private function onUpdate():void
		{
			// TODO Auto Generated method stub
			if (joystick.touched)
			{
				trace(joystick.velocityX, joystick.velocityY);
			}
			else
			{
			}
		}

		public function nextLevel():void
		{
			if (level == light.length * 2)
			{
				level=0;
				cell.width=cell.width / 2;
				cell.height=cell.height / 2;
			}

			if (level < light.length * 2)
			{
				var color:uint=colors[int(Math.random() * this.colors.length)];
				cell.x=int(Math.random() * randomArea.width) + randomArea.x;
				cell.y=int(Math.random() * randomArea.height) + randomArea.y;
				if (Math.random() > 0.5)
					cell.color=this.light[int(level / 2)];
				else
					cell.color=this.dark[int(level / 2)];
				colorize(cell.filter as ColorMatrixFilter, color, 0.5);
				colorize(canvas.filter as ColorMatrixFilter, color, 0.5);
				level++;
			}
		}

		private static const sTmpMatrix2:Vector.<Number>=new Vector.<Number>;

		public static function colorize(colorMartixFilter:ColorMatrixFilter, color:Number, amount:Number=1):void
		{
			if (isNaN(color))
			{
				return;
			}
			else if (isNaN(amount))
			{
				amount=1;
			}
			var r:Number=((color >> 16) & 0xff) / 255;
			var g:Number=((color >> 8) & 0xff) / 255;
			var b:Number=(color & 0xff) / 255;
			var inv:Number=1 - amount;
			sTmpMatrix2.length=0;
			sTmpMatrix2.push(inv + amount * r * 0.299, amount * r * 0.587, amount * r * 0.114, 0, 0, amount * g * 0.299, inv + amount * g * 0.587, amount * g * 0.114, 0, 0, amount * b * 0.299, amount * b * 0.587, inv + amount * b * 0.114, 0, 0, 0, 0, 0, 1, 0);
			colorMartixFilter.reset();
			colorMartixFilter.concat(sTmpMatrix2);
		}
	}
}
