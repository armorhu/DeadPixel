package com.agame.deadpixel.screen.play.classic
{
	import com.agame.deadpixel.Game;
	import com.agame.deadpixel.LabelButton;
	import com.agame.deadpixel.screen.play.PlayScreen;
	import com.agame.deadpixel.screen.result.ResultScreen;
	import com.agame.deadpixel.text.Lang;
	import com.agame.deadpixel.text.TID;
	import com.agame.deadpixel.text.TextPattern;
	import com.agame.utils.Cookies;

	import flash.utils.setTimeout;

	import starling.events.Touch;
	import starling.text.TextField;
	import starling.utils.HAlign;

	/**
	 * 经典模式，3条命闯关
	 * @author hufan
	 */
	public class ClassicScreen extends PlayScreen
	{
		public static const SCREEN_ID:String='ClassicScreen';

		private static const MAX_LIFE:int=3;
		private var level:int=0;
		private var levelDisplay:int=0;
		private var life:int=MAX_LIFE;


		private var lifeTf:TextField;
		private var levelTf:TextField;
		private var help:LabelButton;


		public function ClassicScreen()
		{
			super();
		}

		override protected function initialize():void
		{
			preStartText=Lang(TID.tid_note_classic).replace(TextPattern.NUMBER, MAX_LIFE);
			super.initialize();
			this.lifeTf=Game.createTextfiled(Lang(TID.tid_life) + life, Game.NON_SCALE_STAGE_WIDTH, NON_SCALE_TITLE_HEIGHT, 30, Game.blue);
			this.lifeTf.hAlign=HAlign.LEFT;
			ui.addChild(this.lifeTf);

			this.levelTf=Game.createTextfiled(Lang(TID.tid_level) + level, Game.NON_SCALE_STAGE_WIDTH, NON_SCALE_TITLE_HEIGHT, 30, Game.blue);
			ui.addChild(this.levelTf);

			this.help=new LabelButton(Lang(TID.tid_help), Game.NON_SCALE_STAGE_WIDTH, NON_SCALE_TITLE_HEIGHT, 30, Game.blue);
			help.tiggerHandler=Game.shareScreenShot;
			this.help.textfiled.hAlign=HAlign.RIGHT;
			ui.addChild(this.help);
		}

		override protected function touchHandler(touch:Touch):void
		{
			// TODO Auto Generated method stub
			if (this.life == 0)
				return;
			if (getCellHitArea(cell).contains(touch.globalX, touch.globalY))
			{
				playCheer(touch.globalX, touch.globalY);
				nextLevel();
			}
			else
			{
				Game.playSound(Game.error, 2);
				this.flashQuad(cell.bounds, 0.5);
				this.life--;
				this.lifeTf.text=Lang(TID.tid_life) + this.life;
				if (this.life == 0)
					setTimeout(endGame, 500, true);
			}
		}

		override protected function endGame(win:Boolean=true):void
		{
			super.endGame(win);
			Game.showScreen(ResultScreen.SCREEN_ID);
			var best:int=int(Cookies.getObject(SCREEN_ID));
			Game.resultScreen.title.text=Lang(TID.tid_classic) + Lang(TID.tid_mode);
			Game.resultScreen.score.text=levelDisplay + '';
			Game.resultScreen.playScreenID=SCREEN_ID;
			Game.resultScreen.setStyle(0);
			if (best < levelDisplay)
			{
				Cookies.setObject(SCREEN_ID, levelDisplay, 0, true);
				Game.newRecord();
			}
			else
			{
				Game.resultScreen.bestScore.text=Lang(TID.tid_best_score) + best;
			}
		}

		override protected function resetScreen():void
		{
			level=0
			levelDisplay=0;
			life=MAX_LIFE;
			this.levelTf.text=Lang(TID.tid_level) + level;
			this.lifeTf.text=Lang(TID.tid_life) + life;
		}

		override protected function startGame():void
		{
			nextLevel();
		}

		public function nextLevel():void
		{
			if (level == light.length * 2)
			{
				level=0;
				var w:int=cell.width * 0.75;
				var h:int=cell.height * 0.75;
				if (w < 1)
					w=1;
				if (h < 1)
					h=1;
				cell.width=w;
				cell.height=h;
				cellSize=w;
				updateRandomArea();
				note(Lang(TID.tid_note_deadpixel_small), 4);
			}

			if (level < light.length * 2)
			{
				var color:uint=colors[int(Math.random() * this.colors.length)];
				var brigness:Number=0.0 + level / (light.length * 5);
				var cellColor:uint;
				cell.x=int(Math.random() * randomArea.width) + randomArea.x;
				cell.y=int(Math.random() * randomArea.height) + randomArea.y;
				if (Math.random() > 0.5)
				{
					cellColor=this.light[int(level / 2)];
				}
				else
				{
					cellColor=this.dark[int(level / 2)];
				}
				drawMap(cellColor, color, brigness);
				level++;
				levelDisplay++;
				this.levelTf.text=Lang(TID.tid_level) + levelDisplay;
			}
		}
	}
}
