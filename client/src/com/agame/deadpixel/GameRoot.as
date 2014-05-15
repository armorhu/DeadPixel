package com.agame.deadpixel
{
	import com.agame.deadpixel.screen.play.classic.ClassicScreen;
	import com.agame.deadpixel.screen.play.sixty.SixtyScreen;
	import com.agame.deadpixel.screen.play.speed.SpeedScreen;
	import com.agame.deadpixel.screen.result.ResultScreen;
	import com.agame.deadpixel.screen.start.StartScreen;
	import com.agame.deadpixel.text.Lang;
	import com.agame.deadpixel.text.TID;
	import com.agame.utils.Cookies;
	import com.greensock.TimelineMax;
	import com.greensock.TweenLite;

	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.media.SoundTransform;
	import flash.system.Capabilities;

	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.motion.transitions.ScreenFadeTransitionManager;
	import feathers.themes.MetalWorksMobileTheme;

	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.AssetManager;

	public class GameRoot extends Sprite
	{
		public var scale:Number;
		public const NON_SCALE_STAGE_WIDTH:Number=640;
		public var stageWidth:Number;
		public var stageHeight:Number;

		public var fontName:String='fonts';
		public var assets:AssetManager;
		public var resultScreen:ResultScreen;

		public var XXL:int=120;
		public var XL:int=100;
		public var L:int=60;
		public var S:int=40;


		public const red:uint=0xd4551e;
		public const blue:uint=0x02bcc7;
		public const grey:uint=0x718392;
		public const grey2:uint=0xb0bbc5;
		public var withe:uint=0xffffff;
		public var black:uint=0x0;
		public var green:uint=0x009900;

		public function GameRoot()
		{
			super();
			Game=this;
			addEventListener(starling.events.Event.ADDED_TO_STAGE, addedToStageHandler)
		}

		private function addedToStageHandler():void
		{
			// TODO Auto Generated method stub
			initliaze();
		}

		public function initliaze():void
		{
			new MetalWorksMobileTheme(stage);
			stage.color=0x0;
			this.stageWidth=stage.stageWidth;
			this.stageHeight=stage.stageHeight;
			scale=this.stageHeight / 960;

			assets=new AssetManager;
			assets.enqueue(File.applicationDirectory.resolvePath('res'));
			assets.loadQueue(assetsProgressing);
		}

		private function assetsProgressing(percent:Number):void
		{
			DeadPixel.loadingBar.txt.text='LOADING...' + int(percent * 100) + '%';
			if (percent == 1)
			{
				assetsReady();
			}
		}


		private var screenNavigator:ScreenNavigator;
		private var screenTransitionManager:ScreenFadeTransitionManager;
		public var admobSize:Number=100;
		public var screenArea:Rectangle;

		public function assetsReady():void
		{
			Cookies.initialize('DeadPixel');
			TID.init(Capabilities.language);
			admobSize=100 * scale;
			screenArea=new Rectangle(0, 0, stageWidth, stageHeight);
			screenNavigator=new ScreenNavigator;
			addChild(screenNavigator);

			screenNavigator.addScreen(ResultScreen.SCREEN_ID, new ScreenNavigatorItem(resultScreen=new ResultScreen));
			screenNavigator.addScreen(StartScreen.SCREEN_ID, new ScreenNavigatorItem(new StartScreen));
			screenNavigator.addScreen(ClassicScreen.SCREEN_ID, new ScreenNavigatorItem(new ClassicScreen));
			screenNavigator.addScreen(SpeedScreen.SCREEN_ID, new ScreenNavigatorItem(new SpeedScreen));
			screenNavigator.addScreen(SixtyScreen.SCREEN_ID, new ScreenNavigatorItem(new SixtyScreen));

			screenTransitionManager=new ScreenFadeTransitionManager(screenNavigator);
			DeadPixel.loadingBar.parent.removeChild(DeadPixel.loadingBar);
			screenNavigator.showScreen(StartScreen.SCREEN_ID);
		}

		public function createTextfiled(text:String='', width:Number=128, height:Number=64, size:int=30, color:uint=0x0):TextField
		{
			var result:TextField=new TextField(width * scale, height * scale, text, Game.fontName, size * scale, color);
			result.autoScale=true;
			return result;
		}

		public function saveGameData():void
		{
			Cookies.flush();
		}

		public var beep:String='beep';
		public var cheer:String='cheer';
		public var error:String='error';
		public var tick:String='tick';
		public var touch:String='touch';
		public var quest_complete:String='quest_complete';
		private var transfrom:SoundTransform;

		public function playSound(name:String, loops:int):void
		{
			if (name == touch)
			{
				if (transfrom == null)
					transfrom=new SoundTransform(2);
				assets.playSound(name, 0, loops, transfrom);
			}
			else
				assets.playSound(name, 0, loops);
		}


		public function showScreen(screenID:String):void
		{
			screenNavigator.showScreen(screenID);
		}

		public function share():void
		{
			// TODO Auto Generated method stub
		}

		public function flashDisplayObject(quad:DisplayObject, dutartion:Number=2):void
		{
			var flashTimeline:TimelineMax=new TimelineMax();
			flashTimeline.append(TweenLite.to(quad, 0.1, {alpha: 0}));
			flashTimeline.append(TweenLite.to(quad, 0.1, {alpha: 1}));
			flashTimeline.repeat(dutartion / 0.2);
			flashTimeline.play();
		}

		public function newRecord():void
		{
			// TODO Auto Generated method stub
			resultScreen.bestScore.text=Lang(TID.tid_new_record);
			playSound(Game.cheer, 0);
			flashDisplayObject(Game.resultScreen.shareLabel);
		}
	}
}
