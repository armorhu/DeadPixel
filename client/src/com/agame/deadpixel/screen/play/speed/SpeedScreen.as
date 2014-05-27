package com.agame.deadpixel.screen.play.speed
{
	import com.agame.deadpixel.Game;
	import com.agame.deadpixel.LabelButton;
	import com.agame.deadpixel.screen.play.PlayScreen;
	import com.agame.deadpixel.screen.result.ResultScreen;
	import com.agame.deadpixel.text.Lang;
	import com.agame.deadpixel.text.TID;
	import com.agame.deadpixel.text.TextPattern;
	import com.agame.utils.Cookies;

	import flash.geom.Point;
	import flash.utils.setTimeout;

	import feathers.display.TiledImage;

	import starling.animation.IAnimatable;
	import starling.core.Starling;
	import starling.events.Touch;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;


	/**
	 * 屏幕上有10个坏点，比谁先把它们找出来
	 * @author hufan
	 *
	 */
	public class SpeedScreen extends PlayScreen implements IAnimatable
	{
		public static const SCREEN_ID:String='SpeedScreen';
		private static const MAX_DEAD_PIXEL_NUM:int=10;

		private var _deadPixelNum:int=0;
		private var _timer:Number=0;

		private var labelDeadPixelNum:TextField;
		private var labelTimer:TextField;
		private var help:LabelButton;

		private var _cells:Vector.<TiledImage>;

		public function SpeedScreen()
		{
			super();
		}

		override protected function initialize():void
		{
			super.initialize();
			preStartText=Lang(TID.tid_note_speed).replace(TextPattern.NUMBER, MAX_DEAD_PIXEL_NUM);
			this.labelDeadPixelNum=Game.createTextfiled('', Game.NON_SCALE_STAGE_WIDTH, NON_SCALE_TITLE_HEIGHT, 30, Game.blue);
			this.labelDeadPixelNum.hAlign=HAlign.LEFT;
			ui.addChild(this.labelDeadPixelNum);

			this.labelTimer=Game.createTextfiled('', Game.NON_SCALE_STAGE_WIDTH, NON_SCALE_TITLE_HEIGHT, 30, Game.blue);
			ui.addChild(this.labelTimer);

			this.help=new LabelButton(Lang(TID.tid_help), Game.NON_SCALE_STAGE_WIDTH, NON_SCALE_TITLE_HEIGHT, 30, Game.blue);
			this.help.textfiled.hAlign=HAlign.RIGHT;
			help.tiggerHandler=Game.shareScreenShot;
			ui.addChild(this.help);
		}

		private function set deadPixelNum(value:int):void
		{
			_deadPixelNum=value;
			this.labelDeadPixelNum.text=Lang(TID.tid_title_deadpixel) + ' ' + value;
		}

		private function get deadPixelNum():int
		{
			return _deadPixelNum;
		}

		override protected function resetScreen():void
		{
			super.resetScreen();
			_timer=0;
			labelTimer.text=_timer.toFixed(2) + '″';
			deadPixelNum=MAX_DEAD_PIXEL_NUM;
			cell.visible=true;
		}

		override protected function updateCellTexture(texture:Texture):void
		{
			if (_cells == null)
			{
				_cells=new Vector.<TiledImage>;
				_cells.push(cell);
				var len:int=MAX_DEAD_PIXEL_NUM - 1;
				var t:TiledImage;
				for (var i:int=0; i < len; i++)
				{
					t=new TiledImage(texture);
					t.visible=false;
					_cells.push(t);
					map.addChildAt(t, 1);
				}
			}
			else
			{
				for (i=0; i < MAX_DEAD_PIXEL_NUM; i++)
					_cells[i].texture=texture;
			}
		}
		private var _cellColor:uint;
		private var _brightness:Number;

		override protected function startGame():void
		{
			super.startGame();
			cell.visible=true;
			Starling.juggler.add(this);
			//设置坏点的颜色
			_cellColor=dark[dark.length - 1];
			_brightness=0.4;
			drawMap(_cellColor, colors[int(colors.length * Math.random())], _brightness);
			//随机拜访
			cellSize=cellInitSize / 2;
			updateRandomArea();
			var result:Vector.<Point>=genrateRandomPoint(MAX_DEAD_PIXEL_NUM, cellSize);
			for (var i:int=0; i < MAX_DEAD_PIXEL_NUM; i++)
			{
				_cells[i].x=result[i].x;
				_cells[i].y=result[i].y;
				_cells[i].width=_cells[i].height=cellSize;
				_cells[i].visible=true;
			}
		}

		override protected function endGame(win:Boolean=true):void
		{
			super.endGame(win);
			for (var i:int=0; i < MAX_DEAD_PIXEL_NUM; i++)
				_cells[i].visible=false;
			Starling.juggler.remove(this);
			Game.resultScreen.playScreenID=SCREEN_ID;
			var best:Number=Number(Cookies.getObject(SCREEN_ID));
			if (win)
			{
				Game.showScreen(ResultScreen.SCREEN_ID);
				Game.resultScreen.title.text=Lang(TID.tid_speed) + Lang(TID.tid_mode);
				Game.resultScreen.setStyle(0);
				Game.resultScreen.score.text=_timer.toFixed(2) + '″';
				if (best >= _timer)
				{
					Cookies.setObject(SCREEN_ID, _timer, 0, true);
					Game.newRecord();
				}
				else
				{
					Game.resultScreen.bestScore.text=Lang(TID.tid_best_score) + best + '″';
				}
			}
			else
			{
				setTimeout(function():void
				{
					Game.showScreen(ResultScreen.SCREEN_ID);
					Game.resultScreen.title.text=Lang(TID.tid_speed) + Lang(TID.tid_mode);
					Game.resultScreen.setStyle(1);
					Game.resultScreen.score.text=Lang(TID.tid_failed);
					if (best > 0)
						Game.resultScreen.bestScore.text=Lang(TID.tid_best_score) + best + '″';
					else
						Game.resultScreen.bestScore.text='';
				}, 1000);
			}
		}


		private function genrateRandomPoint(count:int, size:Number):Vector.<Point>
		{
			var result:Vector.<Point>=new Vector.<Point>;
			var pt:Point;
			var result_len:int;
			var flag:Boolean;
			for (var i:int=0; i < count; i++)
			{
				pt=new Point;
				result_len=result.length;
				while (true)
				{
					pt.x=int(randomArea.x + randomArea.width * Math.random());
					pt.y=int(randomArea.y + randomArea.height * Math.random());

					flag=false;
					for (var j:int=0; j < result_len; j++)
					{
						if (Math.abs(pt.x - result[j].x) <= size + 1)
						{
							flag=true;
							break;
						}

						if (Math.abs(pt.y - result[j].y) <= size + 1)
						{
							flag=true;
							break;
						}
					}

					if (flag == false)
					{
						result.push(pt);
						break;
					}
				}
			}
			return result;
		}

		override protected function touchHandler(touch:Touch):void
		{
			var len:int=_cells.length;
			for (var i:int=0; i < len; i++)
			{
				if (_cells[i].visible && getCellHitArea(_cells[i]).contains(touch.globalX, touch.globalY))
				{
					playCheer(touch.globalX, touch.globalY);
					_cells[i].visible=false;
					deadPixelNum--;
					if (deadPixelNum == 0)
					{
						this.endGame();
					}
					else
					{
						drawMap(_cellColor, colors[int(colors.length * Math.random())], _brightness);
					}
					return;
				}
			}

			Game.playSound(Game.error, 2);
			for (i=0; i < len; i++)
				if (_cells[i].visible)
				{
					flashQuad(_cells[i].bounds);
				}
			this.endGame(false);
		}

		private var _timePast:Number=0.0;

		public function advanceTime(time:Number):void
		{
			// TODO Auto Generated method stub
			_timer+=time;
			_timePast+=time;
			if (_timePast > 0.15)
			{
				_timePast-=0.15;
				labelTimer.text=_timer.toFixed(2) + '″';
			}
		}
	}
}
