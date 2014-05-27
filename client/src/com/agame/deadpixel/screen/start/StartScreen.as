package com.agame.deadpixel.screen.start
{
	import com.agame.deadpixel.Game;
	import com.agame.deadpixel.LabelButton;
	import com.agame.deadpixel.ane.GameCenterProxy;
	import com.agame.deadpixel.screen.play.classic.ClassicScreen;
	import com.agame.deadpixel.screen.play.sixty.SixtyScreen;
	import com.agame.deadpixel.screen.play.speed.SpeedScreen;
	import com.agame.deadpixel.text.Lang;
	import com.agame.deadpixel.text.TID;
	import com.amgame.utils.AppstoreUtils;

	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	import feathers.controls.LayoutGroup;
	import feathers.controls.Screen;
	import feathers.layout.VerticalLayout;

	import starling.text.TextField;

	/**
	 * 开始游戏界面
	 * @author hufan
	 *
	 */
	public class StartScreen extends Screen
	{
		public static const SCREEN_ID:String='GameStartScreen';


		public function StartScreen()
		{
			super();
		}

		private var _menuGroup:LayoutGroup;

		override protected function initialize():void
		{
			var title:TextField=Game.createTextfiled(Lang(TID.tid_title_deadpixel), Game.NON_SCALE_STAGE_WIDTH, 128, 100, Game.red);
			addChild(title);

			var yOffset:Number=title.height + 110 * Game.scale;
			createModeLabel(TID.tid_classic, startClassic, 0, yOffset);
			yOffset+=createModeLabel(TID.tid_speed, startSpeed, Game.stageWidth / 2, yOffset).height;
//			yOffset+=createModeLabel(TID.tid_sixty, startSixty, Game.stageWidth / 4, yOffset).height;

			var vLayout:VerticalLayout=new VerticalLayout;
			vLayout.gap=20 * Game.scale;
			_menuGroup=new LayoutGroup;
			_menuGroup.layout=vLayout;
			_menuGroup.y=yOffset + 110 * Game.scale;
			_menuGroup.height=Game.stageHeight - _menuGroup.y - Game.admobSize;
			addChild(_menuGroup);

			var color:uint=Game.grey2;
			var btnLeaderBoard:LabelButton=new LabelButton(Lang(TID.tid_leaderborad), Game.NON_SCALE_STAGE_WIDTH, 64, 48, color);
			btnLeaderBoard.tiggerHandler=showLeaderBoard;
			_menuGroup.addChild(btnLeaderBoard);

			var btnShared:LabelButton=new LabelButton(Lang(TID.tid_share), Game.NON_SCALE_STAGE_WIDTH, 64, 48, color);
			btnShared.tiggerHandler=sharedHandler;
			_menuGroup.addChild(btnShared);

			var btnRatingMe:LabelButton=new LabelButton(Lang(TID.tid_rate), Game.NON_SCALE_STAGE_WIDTH, 64, 48, color);
			btnRatingMe.tiggerHandler=function():void
			{
				navigateToURL(new URLRequest(AppstoreUtils.getAppRateURL(Game.APP_ID)));
			}
			_menuGroup.addChild(btnRatingMe);

			var btnMoreGames:LabelButton=new LabelButton(Lang(TID.tid_moreGames), Game.NON_SCALE_STAGE_WIDTH, 64, 48, color);
			btnMoreGames.tiggerHandler=function():void
			{
				navigateToURL(new URLRequest(AppstoreUtils.getArmorPage()));
			}
			_menuGroup.addChild(btnMoreGames);
		}

		private function showLeaderBoard():void
		{
			// TODO Auto Generated method stub
			GameCenterProxy.requestLeaderboardCategories();
		}

		private function sharedHandler():void
		{
			// TODO Auto Generated method stub
			Game.share();
		}

		private function startClassic():void
		{
			// TODO Auto Generated method stub
			Game.showScreen(ClassicScreen.SCREEN_ID);
		}

		private function startSpeed():void
		{
			// TODO Auto Generated method stub
			Game.showScreen(SpeedScreen.SCREEN_ID);
		}

		private function startSixty():void
		{
			// TODO Auto Generated method stub
			Game.showScreen(SixtyScreen.SCREEN_ID);
		}

		private function createModeLabel(name:String, tiggeredHandler:Function, x:Number, y:Number):LabelButton
		{
			var labelButton:LabelButton=new LabelButton(Lang(name), Game.NON_SCALE_STAGE_WIDTH / 2, 164, 64, Game.blue);
			labelButton.x=x;
			labelButton.y=y;
			labelButton.tiggerHandler=tiggeredHandler;
			var mode:TextField=Game.createTextfiled(Lang(TID.tid_mode), Game.NON_SCALE_STAGE_WIDTH / 2, 32, 36, Game.grey);
			mode.x=x;
			mode.y=y + 120 * Game.scale;
			addChild(mode);
			addChild(labelButton);

			labelButton.name=name;
			return labelButton;
		}
	}
}
