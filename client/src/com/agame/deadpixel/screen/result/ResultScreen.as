package com.agame.deadpixel.screen.result
{
	import com.agame.deadpixel.Game;
	import com.agame.deadpixel.LabelButton;
	import com.agame.deadpixel.screen.start.StartScreen;
	import com.agame.deadpixel.text.Lang;
	import com.agame.deadpixel.text.TID;

	import feathers.controls.Screen;

	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;

	/**
	 * 游戏结束界面
	 * @author hufan
	 */
	public class ResultScreen extends Screen
	{
		public static const SCREEN_ID:String='GameResultScreen';

		public function ResultScreen()
		{
			super();
		}

		public var playScreenID:String='';

		public var bg:Quad;
		public var title:TextField;
		public var score:TextField;
		public var bestScore:TextField;

		public var lb:Sprite;
		public var backLabel:LabelButton;
		public var retryLabel:LabelButton;
		public var shareLabel:LabelButton;

		override protected function initialize():void
		{
			bg=new Quad(Game.stageWidth, Game.stageHeight);
			addChild(bg);

			title=Game.createTextfiled(Lang(TID.tid_classic) + ' ' + Lang(TID.tid_mode), Game.NON_SCALE_STAGE_WIDTH, 100, Game.L);
			title.pivotY=title.height / 2;
			title.y=Game.stageHeight / 5;
			addChild(title);

			score=Game.createTextfiled("   100.0″", Game.NON_SCALE_STAGE_WIDTH, 150, Game.XL);
			score.pivotY=title.height / 2;
			score.bold=true;
			score.y=Game.stageHeight / 3;
			addChild(score);

			bestScore=Game.createTextfiled(Lang(TID.tid_new_record), Game.NON_SCALE_STAGE_WIDTH, 100, Game.S);
			bestScore.pivotY=bestScore.height / 2;
			bestScore.y=score.y + score.height;
			addChild(bestScore);

			lb=new Sprite();
			lb.y=4 * Game.stageHeight / 5;
			addChild(lb);

			shareLabel=new LabelButton(Lang(TID.tid_share), 128, 64, Game.L);
			shareLabel.pivotX=shareLabel.width / 2;
			shareLabel.x=1 * Game.stageWidth / 5;
			lb.addChild(shareLabel);

			backLabel=new LabelButton(Lang(TID.tid_button_menu), 128, 64, Game.L);
			backLabel.pivotX=backLabel.width / 2;
			lb.addChild(backLabel);
			backLabel.x=2.5 * Game.stageWidth / 5;

			retryLabel=new LabelButton(Lang(TID.tid_button_replay), 128, 64, Game.L);
			retryLabel.pivotX=retryLabel.width / 2;
			retryLabel.x=4 * Game.stageWidth / 5;
			lb.addChild(retryLabel);


			lb.addEventListener(Event.TRIGGERED, triggeredHandler);
			setStyle(0);
		}

		private function triggeredHandler(event:Event):void
		{
			// TODO Auto Generated method stub
			var targetName:String=event.target['name'];
			if (targetName == Lang(TID.tid_button_menu))
			{
				Game.showScreen(StartScreen.SCREEN_ID);
			}
			else if (targetName == Lang(TID.tid_button_replay))
			{
				Game.showScreen(playScreenID);
			}
			else if (targetName == Lang(TID.tid_share))
			{
				Game.share();
			}
		}

		/**
		 * 0 胜利
		 * 1 点到白块失败
		 * 2 错过黑块失败
		 */
		public function setStyle(style:int):void
		{
			if (style == 0)
			{
				bg.color=Game.black;
				title.color=Game.grey;
				score.color=Game.blue;
				bestScore.color=Game.red;
				backLabel.textfiled.color=Game.grey2;
				retryLabel.textfiled.color=Game.grey2;
				shareLabel.textfiled.color=Game.grey2;
			}
			else if (style == 1)
			{
				bg.color=Game.black;
				title.color=Game.grey;
				score.color=Game.red;
				bestScore.color=Game.blue;
				backLabel.textfiled.color=Game.grey2;
				retryLabel.textfiled.color=Game.grey2;
				shareLabel.textfiled.color=Game.grey2;
			}
//			if (style == 0)
//			{
//				bg.color=Game.green;
//				title.color=Game.withe;
//				score.color=Game.black;
//				bestScore.color=Game.black;
//				backLabel.textfiled.color=Game.black;
//				retryLabel.textfiled.color=Game.black;
//				shareLabel.textfiled.color=Game.black;
//			}
//			else if (style == 1)
//			{
//				bg.color=Game.red;
//				title.color=Game.withe;
//				score.color=Game.black;
//				bestScore.color=Game.black;
//				backLabel.textfiled.color=Game.black;
//				retryLabel.textfiled.color=Game.black;
//				shareLabel.textfiled.color=Game.black;
//			}
//			else if (style == 2)
//			{
//				bg.color=Game.black;
//				title.color=Game.withe;
//				score.color=Game.withe;
//				bestScore.color=Game.withe;
//				backLabel.textfiled.color=Game.withe;
//				retryLabel.textfiled.color=Game.withe;
//				shareLabel.textfiled.color=Game.withe;
//			}
		}
	}
}
