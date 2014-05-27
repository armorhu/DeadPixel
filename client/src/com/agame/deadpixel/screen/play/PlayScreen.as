package com.agame.deadpixel.screen.play
{
	import com.agame.deadpixel.Game;
	import com.agame.deadpixel.text.Lang;
	import com.agame.deadpixel.text.TID;
	import com.greensock.TimelineMax;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;

	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.utils.clearInterval;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;

	import feathers.controls.Screen;
	import feathers.display.TiledImage;

	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.extensions.PDParticleSystem;
	import starling.filters.ColorMatrixFilter;
	import starling.text.TextField;
	import starling.textures.Texture;

	public class PlayScreen extends Screen
	{
		//最上面是效果层
		protected var effect:Sprite;
		protected var noteLabel:TextField;
		protected var cheerPaticle:PDParticleSystem;

		//中间是ui层
		protected var ui:Sprite;

		//最下面是地图层
		protected var map:Sprite;
		protected var cell:TiledImage;
		protected var touchMeStartLabel:TextField;
		protected var canvas:TiledImage;

		protected var gray:int=8421504;
		protected var cellSize:Number=0;
		protected var cellInitSize:Number=0;
		public var randomArea:Rectangle;

		private var _isMoved:Boolean;
		private var touchPointID:int;
		private var touchTime:int;

		protected var colors:Array;
		protected var light:Array;
		protected var dark:Array;
		protected var titleHeight:Number;
		protected const NON_SCALE_TITLE_HEIGHT:Number=64;
		protected var preStartText:String='';

		protected var state:int;

		public static const PRE_START:int=0;
		public static const PLAYING:int=1;
		public static const END_GAME:int=2;

		public function PlayScreen()
		{
			super();
		}


		private var intervalID:int;

		public function note(msg:String, duration:Number=int.MAX_VALUE):void
		{
			noteLabel.text=msg;
			noteLabel.visible=true;
			noteLabel.y=Game.scale * 200;
			if (intervalID > 0)
			{
				clearInterval(intervalID);
				intervalID=0;
			}
			TweenLite.from(noteLabel, 0.5, {y: -100, onComplete: function():void
			{
				if (duration != int.MAX_VALUE)
					intervalID=setTimeout(clearNote, duration * 1000);
			}})
		}

		public function clearNote():void
		{
			if (intervalID > 0)
			{
				clearInterval(intervalID);
				intervalID=0;
			}
			noteLabel.visible=false;
		}

		override protected function initialize():void
		{
			super.initialize();
			this.titleHeight=NON_SCALE_TITLE_HEIGHT * Game.scale;
			this.light=[9079434, 9079433, 9079177, 9013641, 9013640, 9013384, 8947848, 8947847, 8947591, 8882055, 8882054, 8881798, 8816262, 8816261, 8816005, 8750469, 8750468, 8750212, 8684676, 8684675, 8684419, 8618883, 8618882, 8618626, 8553090];
			this.dark=[7763574, 7763575, 7763831, 7829367, 7829368, 7829624, 7895160, 7895161, 7895417, 7960953, 7960954, 7961210, 8026746, 8026747, 8027003, 8092539, 8092540, 8092796, 8158332, 8158333, 8158589, 8224125, 8224126, 8224382, 8289918];
			for (var i:int=0; i < 20; i++)
			{
				this.light.shift();
				this.dark.shift();
			}
			this.colors=[16711680, 16711935, 16711782, 13369599, 10027263, 6684927, 3342591, 13311, 26367, 39423, 52479, 65535, 3394611, 6736947, 10092339, 13434675, 16763955, 16750899, 16737792, 16724736, 6655, 65509, 32767, 65458, 65407, 65357, 65306, 5046016, 8388352, 11665152, 15007488, 16770304, 13382466, 13382517, 16724909, 16724959, 12006399, 8729599, 5046527, 1704191];
			cellInitSize=mmToPixels(4);
			cellSize=cellInitSize;

			//map
			map=new Sprite;
			addChild(map);

			//ui
			ui=new Sprite;
			addChild(ui);

			//effect....
			effect=new Sprite;
			addChild(effect);
			cheerPaticle=new PDParticleSystem(Game.assets.getXml('cheer_particle'), Game.assets.getTexture('particleTexture'));
			effect.addChild(cheerPaticle);
			Starling.juggler.add(cheerPaticle);

			noteLabel=Game.createTextfiled('', Game.NON_SCALE_STAGE_WIDTH, 128, 60, 0x0);
			noteLabel.x=Game.stageWidth / 2;
			noteLabel.y=Game.scale * 200;
			noteLabel.pivotX=noteLabel.width / 2;
			noteLabel.pivotY=noteLabel.height / 2;
			effect.addChild(noteLabel);

			updateRandomArea();

			touchMeStartLabel=Game.createTextfiled(Lang(TID.tid_note_touchme_start), cellInitSize * 4 / Game.scale, cellInitSize * 4 / Game.scale, 60, 0x0);
			touchMeStartLabel.x=randomArea.x + randomArea.width / 2 - touchMeStartLabel.width / 2;
			touchMeStartLabel.y=randomArea.y + randomArea.height / 2 + 100 * Game.scale;

			setTimeout(restartGame, 1);
			stage.addEventListener(TouchEvent.TOUCH, accessory_touchHandler);
		}

		public function updateRandomArea():void
		{
			// TODO Auto Generated method stub
			randomArea=Game.screenArea.clone();
			randomArea.top+=titleHeight;
			randomArea.bottom-=Game.admobSize;
			randomArea.x+=cellSize;
			randomArea.y+=cellSize;
			randomArea.width-=cellSize * 2;
			randomArea.height-=cellSize * 2;
		}

		override protected function screen_addedToStageHandler(event:Event):void
		{
			super.screen_addedToStageHandler(event);
			if (_isInitialized)
			{
				restartGame();
			}
		}

		private function restartGame():void
		{
			drawMap(7763574, colors[int(colors.length * Math.random())], 0);
			cellSize=this.cellInitSize;
			if (!map.contains(touchMeStartLabel))
				map.addChild(touchMeStartLabel);
			canvas.x=Game.screenArea.x;
			canvas.y=Game.screenArea.y + titleHeight;
			canvas.width=Game.screenArea.width;
			canvas.height=Game.screenArea.height - titleHeight;
			cell.width=touchMeStartLabel.width;
			cell.height=touchMeStartLabel.height;
			cell.x=touchMeStartLabel.x;
			cell.y=touchMeStartLabel.y;
			note(preStartText);
			state=PRE_START;
			updateRandomArea();
			resetScreen();
		}

		protected function resetScreen():void
		{
		}

		private function accessory_touchHandler(event:TouchEvent):void
		{
			if (this.touchPointID >= 0)
			{
				var touch:Touch=event.getTouch(stage, null, this.touchPointID);
				if (!touch)
					return;
				if (touch.phase == TouchPhase.ENDED)
				{
					//tiggered!
					if (_isMoved == false && getTimer() - touchTime < 500)
					{ //500毫秒内抬起，认为是click事件
						clickStageHandler(touch);
					}
					this.touchPointID=-1;
				}
				else if (touch.phase == TouchPhase.MOVED)
				{
					_isMoved=true;
				}
			}
			else //if we get here, we don't have a saved touch ID yet
			{
				touch=event.getTouch(stage, TouchPhase.BEGAN);
				if (touch)
				{
					_isMoved=false;
					touchTime=getTimer();
					this.touchPointID=touch.id;
				}
			}
		}

		private function clickStageHandler(touch:Touch):void
		{
			if (state == PLAYING)
			{
				touchHandler(touch);
			}
			else if (state == PRE_START)
			{
				if (getCellHitArea(cell).contains(touch.globalX, touch.globalY))
				{
					state=PLAYING;
					playCheer(touch.globalX, touch.globalY);
					clearNote();
					cell.width=cell.height=cellInitSize;
					touchMeStartLabel.removeFromParent();
					startGame();
				}
				else
				{
					Game.playSound(Game.error, 2);
					this.flashQuad(cell.bounds);
				}
			}
		}

		public function playCheer(px:Number, py:Number):void
		{
			Game.playSound(Game.quest_complete, 0);
			cheerPaticle.start(0.1);
			cheerPaticle.emitterX=px;
			cheerPaticle.emitterY=py;
		}

		protected function startGame():void
		{
		}

		protected function endGame(win:Boolean=true):void
		{
			state=END_GAME;
		}

		protected function touchHandler(touch:Touch):void
		{
		}

		/**
		 * 根据颜色值，生成texture.
		 * @param canvasColor
		 * @param colorizeValue
		 * @param colorizeBrightness
		 */
		/**
		 * 根据颜色值，生成texture.
		 * @param canvasColor
		 * @param colorizeValue
		 * @param colorizeBrightness
		 */
		private var _bitmapdata:BitmapData;
		private var _size:Number=32;

		public function drawMap(cellColor:uint, colorizeValue:uint, colorizeBrightness:Number=0):void
		{
			colorizeBrightness+=1;
			var cellShape:Shape=new Shape;
			cellShape.graphics.clear();
			cellShape.graphics.beginFill(cellColor);
			cellShape.graphics.drawRect(0, 0, _size, _size);
			cellShape.graphics.endFill();
			if (cell == null)
			{
				cell=new TiledImage(toTexture(cellShape));
				map.addChildAt(cell, 0);
			}
			else
			{
				cell.texture.dispose();
				cell.texture=toTexture(cellShape);
			}
			updateCellTexture(cell.texture);

			var canvasShape:Shape=new Shape;
			canvasShape.graphics.clear();
			canvasShape.graphics.beginFill(gray);
			canvasShape.graphics.drawRect(0, 0, _size, _size);
			canvasShape.graphics.endFill();
			if (canvas == null)
			{
				canvas=new TiledImage(toTexture(canvasShape));
				map.addChildAt(canvas, 0);
			}
			else
			{
				canvas.texture.dispose();
				canvas.texture=toTexture(canvasShape);
			}

			function toTexture(displayObject:Shape):Texture
			{
				TweenMax.to(displayObject, 0, {colorMatrixFilter: {colorize: colorizeValue, amount: 0.5, brightness: colorizeBrightness}});
				if (_bitmapdata == null)
					_bitmapdata=new BitmapData(_size, _size, true, 0x0);
				_bitmapdata.draw(displayObject);
				return Texture.fromBitmapData(_bitmapdata, false);
			}
		}

		protected function updateCellTexture(texture:Texture):void
		{
		}

		private static const sTmpMatrix2:Vector.<Number>=new Vector.<Number>;

		private function colorize(colorMartixFilter:ColorMatrixFilter, color:Number, amount:Number=1, brightness:Number=0):void
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
			colorMartixFilter.adjustBrightness(brightness);
			colorMartixFilter.concat(sTmpMatrix2);
		}

		/**
		 * Convert millimeters to pixels.
		 */
		public static function mmToPixels(mm:Number, dpi:uint=0):uint
		{
			if (dpi == 0)
				dpi=Capabilities.screenDPI;
			return Math.round(dpi * (mm / 25.4));
		}

		public function flashQuad(rect:Rectangle, duration:Number=0.6):void
		{
			var _failedTimeline:TimelineMax;
			var _quad:Quad;
			_quad=new Quad(1, 1, 0xffffff);
			map.addChild(_quad);
			_quad.width=rect.width;
			_quad.height=rect.height;
			_quad.x=rect.x;
			_quad.y=rect.y;
			_quad.color=0xffffff;
			_quad.visible=true;
			_failedTimeline=new TimelineMax({onComplete: function(quad:Quad):void
			{
				quad.removeFromParent(true);
			}, onCompleteParams: [_quad]});
			_failedTimeline.append(TweenLite.to(_quad, 0.1, {color: 0x0}));
			_failedTimeline.append(TweenLite.to(_quad, 0.1, {color: 0xffffff}));
			_failedTimeline.repeat(duration / 0.2);
			_failedTimeline.play();
		}

		private static const sHitArea:Rectangle=new Rectangle;

		public function getCellHitArea(cell:TiledImage):Rectangle
		{
			if (sHitArea.width == 0)
				sHitArea.width=sHitArea.height=100 * Game.scale;
			var bounds:Rectangle=cell.bounds;
			if (bounds.width > sHitArea.width)
				return bounds;
			else
			{
				sHitArea.x=bounds.x + bounds.width / 2 - sHitArea.width / 2;
				sHitArea.y=bounds.y + bounds.height / 2 - sHitArea.height / 2;
			}
			return sHitArea;
		}
	}
}
