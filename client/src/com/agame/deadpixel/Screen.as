package com.agame.deadpixel
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;

	public class Screen extends Sprite
	{
		private var canvas:Bitmap;
		private var canvasBMD:BitmapData;
		private var grid:Shape;
		public var deadPixel:Point;
		private var cell:int=16;
		private var bmdWidth:int;
		private var bmdHeight:int;
		private var rightEvent:Event;
		private var wrongEvent:Event;
		private var screenEnable:Boolean=true;
		private var lvl:int=0;
		private var gray:int=8421504;
		private var light:Array;
		private var dark:Array;
		private var colors:Array;
		private var col:int;
		private var gridOn:Boolean;

		public function Screen()
		{
			this.light=[9079434, 9079433, 9079177, 9013641, 9013640, 9013384, 8947848, 8947847, 8947591, 8882055, 8882054, 8881798, 8816262, 8816261, 8816005, 8750469, 8750468, 8750212, 8684676, 8684675, 8684419, 8618883, 8618882, 8618626, 8553090];
			this.dark=[7763574, 7763575, 7763831, 7829367, 7829368, 7829624, 7895160, 7895161, 7895417, 7960953, 7960954, 7961210, 8026746, 8026747, 8027003, 8092539, 8092540, 8092796, 8158332, 8158333, 8158589, 8224125, 8224126, 8224382, 8289918];

			var len:int=this.light.length;
			var lightOffset:Array=[];
			var lightOffsetOffset:Array=[];
			var sixLight:Array=[];
			for (var i:int=0; i < len; i++)
			{
				sixLight.push(Number(light[i] - gray).toString(16));
				lightOffset.push(this.light[i] - gray);
				if (i > 0)
					lightOffsetOffset.push(lightOffset[i] - lightOffset[i - 1]);
			}

			trace(sixLight);
			trace(lightOffset);
			trace(lightOffsetOffset);


			this.colors=[16711680, 16711935, 16711782, 13369599, 10027263, 6684927, 3342591, 13311, 26367, 39423, 52479, 65535, 3394611, 6736947, 10092339, 13434675, 16763955, 16750899, 16737792, 16724736, 6655, 65509, 32767, 65458, 65407, 65357, 65306, 5046016, 8388352, 11665152, 15007488, 16770304, 13382466, 13382517, 16724909, 16724959, 12006399, 8729599, 5046527, 1704191];
			this.rightEvent=new Event("right");
			this.wrongEvent=new Event("wrong");
			this.bmdWidth=400 / this.cell;
			this.bmdHeight=300 / this.cell;
			this.deadPixel=new Point(int(Math.random() * this.bmdWidth), int(Math.random() * this.bmdHeight));
			this.rndCol();
			this.canvasBMD=new BitmapData(this.bmdWidth, this.bmdHeight, false, this.gray);
			this.mutateCol();
			this.canvasBMD.setPixel(this.deadPixel.x, this.deadPixel.y, this.col);
			this.colorize();
			this.canvas=new Bitmap(this.canvasBMD);
			var _loc_1:*=this.cell;
			this.canvas.scaleY=this.cell;
			this.canvas.scaleX=_loc_1;
			addChild(this.canvas);
			this.grid=this.drawGrid();
			addChild(this.grid);
			this.grid.visible=false;
			this.gridOn=this.grid.visible;
			addEventListener(MouseEvent.MOUSE_DOWN, this.spotPixel);
			addEventListener(MouseEvent.ROLL_OVER, this.onOver);
			addEventListener(MouseEvent.ROLL_OUT, this.onOut);
			return;
		} // end function

		private function colorize():void
		{
			var _loc_1:ColorTransform=new ColorTransform;
			var color:uint=this.colors[int(Math.random() * this.colors.length)];
			_loc_1.color=this.colors[int(Math.random() * this.colors.length)];
			_loc_1.alphaOffset=0.5;
			this.canvasBMD.colorTransform(this.canvasBMD.rect, _loc_1);
//			var filter:ColorMatrixFilter=new ColorMatrixFilter;
//			this.canvasBMD.applyFilter(this.canvasBMD, this.canvasBMD.rect, this.canvasBMD.rect.topLeft, _loc_1.filter);
			return;
		} // end function

		private function rndCol():void
		{
			this.col=this.gray;
			return;
		} // end function

		private function mutateCol():void
		{
			if (Math.random() > 0.5)
			{
				this.col=this.light[int(this.lvl / 2)];
			}
			else
			{
				this.col=this.dark[int(this.lvl / 2)];
			}
			return;
		} // end function

		private function onOver(event:MouseEvent):void
		{
			return;
		} // end function

		private function onOut(event:MouseEvent):void
		{
			return;
		} // end function

		public function getColor():uint
		{
			return this.canvasBMD.getPixel(int(mouseX / this.cell), int(mouseY / this.cell));
		} // end function

		private function spotPixel(event:MouseEvent):void
		{
			if (this.screenEnable)
			{
				if (int(mouseX / this.cell) == this.deadPixel.x && int(mouseY / this.cell) == this.deadPixel.y)
				{
					dispatchEvent(this.rightEvent);
				}
				else
				{
					dispatchEvent(this.wrongEvent);
				}
			}
//			if (cell != 8)
//				nextTier();
			nextLvl();
			return;
		} // end function

		public function nextLvl():void
		{
			trace(lvl);
			if (lvl == 50)
			{
				nextTier();
				lvl=0;
			}
			this.deadPixel.x=int(Math.random() * (this.bmdWidth - 2)) + 1;
			this.deadPixel.y=int(Math.random() * (this.bmdHeight - 2)) + 1;
			this.rndCol();
			this.canvasBMD.fillRect(this.canvasBMD.rect, this.col);
			this.mutateCol();
			this.canvasBMD.setPixel(this.deadPixel.x, this.deadPixel.y, this.col);
			this.colorize();
			lvl++;
			return;
		} // end function

		private function drawGrid():Shape
		{
			var _loc_1:*=new Shape();
			_loc_1.graphics.clear();
			_loc_1.graphics.lineStyle(1, 8355711, 0.5);
			var _loc_2:int=0;
			while (_loc_2 < this.bmdWidth)
			{

				_loc_1.graphics.moveTo(_loc_2 * this.cell, 0);
				_loc_1.graphics.lineTo(_loc_2 * this.cell, height);
				_loc_2++;
			}
			_loc_2=0;
			while (_loc_2 < this.bmdHeight)
			{

				_loc_1.graphics.moveTo(0, _loc_2 * this.cell);
				_loc_1.graphics.lineTo(width, _loc_2 * this.cell);
				_loc_2++;
			}
			return _loc_1;
		} // end function

		public function nextTier():void
		{
			this.lvl=0;
			this.cell=8;
			this.bmdWidth=width / this.cell;
			this.bmdHeight=height / this.cell;
			this.canvasBMD=new BitmapData(this.bmdWidth, this.bmdHeight, false, this.col);
			removeChild(this.canvas);
			this.canvas=new Bitmap(this.canvasBMD);
			addChild(this.canvas);
			var _loc_1:*=this.cell;
			this.canvas.scaleY=this.cell;
			this.canvas.scaleX=_loc_1;
			removeChild(this.grid);
			this.grid=this.drawGrid();
			addChild(this.grid);
			this.grid.visible=this.gridOn;
			return;
		} // end function

		public function toggleGrid():void
		{
			this.grid.visible=!this.grid.visible;
			this.gridOn=this.grid.visible;
			return;
		} // end function

		public function getCellSz():int
		{
			return this.cell;
		} // end function

		public function lockScreen():void
		{
			this.screenEnable=false;
			return;
		} // end function

		public function unlockScreen():void
		{
			this.screenEnable=true;
			return;
		} // end function

//		public function updateDiff():void
//		{
//			var _loc_1:String=this;
//			var _loc_2:*=this.lvl + 1;
//			_loc_1.lvl=_loc_2;
//			return;
//		} // end function
	}
}
