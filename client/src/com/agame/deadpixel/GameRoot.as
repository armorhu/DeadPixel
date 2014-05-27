package com.agame.deadpixel
{
	import com.agame.deadpixel.ane.GameCenterProxy;
	import com.agame.deadpixel.ane.WechatProxy;
	import com.agame.deadpixel.screen.play.PlayScreen;
	import com.agame.deadpixel.screen.play.classic.ClassicScreen;
	import com.agame.deadpixel.screen.play.sixty.SixtyScreen;
	import com.agame.deadpixel.screen.play.speed.SpeedScreen;
	import com.agame.deadpixel.screen.result.ResultScreen;
	import com.agame.deadpixel.screen.start.StartScreen;
	import com.agame.deadpixel.text.Lang;
	import com.agame.deadpixel.text.TID;
	import com.agame.utils.Cookies;
	import com.agame.utils.SystemUtil;
	import com.amgame.consts.SystemLanguageDefs;
	import com.amgame.utils.AppstoreUtils;
	import com.amgame.utils.BitmapdataUtils;
	import com.greensock.TimelineMax;
	import com.greensock.TweenLite;
	
	import flash.display.BitmapData;
	import flash.display.PNGEncoderOptions;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.media.SoundTransform;
	import flash.system.Capabilities;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.motion.transitions.ScreenFadeTransitionManager;
	
	import so.cuo.platform.admob.Admob;
	import so.cuo.platform.admob.AdmobPosition;
	import so.cuo.platform.admob.AdmobSize;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.AssetManager;

	public class GameRoot extends Sprite
	{
		public const APP_ID:String='874283385';
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
//			new MetalWorksMobileTheme(stage);
			var lang:String=Capabilities.language;
			if (lang != SystemLanguageDefs.ZH_CN && lang != SystemLanguageDefs.ZH_TW)
				lang=SystemLanguageDefs.EN;

			GameCenterProxy.setup();
			TID.init(lang);
			stage.color=0x0;
			this.stageWidth=stage.stageWidth;
			this.stageHeight=stage.stageHeight;
			scale=this.stageHeight / 960;

			assets=new AssetManager;
			assets.enqueue(File.applicationDirectory.resolvePath('res'));
			assets.enqueue(File.applicationDirectory.resolvePath('font/' + lang));
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
		public var admobSize:Number;
		private var _admobSize:AdmobSize;
		private var admob:Admob;
		public var admob_iphone:String='a153491819ad964';
		public var admob_ipad:String='a1534a7ec255c50';
		public var admob_android:String='a1534a7f76632ce';

//		public var admob_iphone:String='ca-app-pub-1942492060626934/7872095803';
//		public var admob_ipad:String='ca-app-pub-1942492060626934/7872095803';
//		public var admob_android:String='ca-app-pub-1942492060626934/4779028602';
		public var screenArea:Rectangle;

		public function assetsReady():void
		{
			Cookies.initialize('DeadPixel');
			WechatProxy.setup('wx55d0681a8a820382');

			admob=Admob.getInstance();
			if (admob.supportDevice)
			{
				admobSize=Admob.BANNER.height;
				_admobSize=Admob.BANNER;
				if (SystemUtil.isAndroid())
					admob.setKeys(admob_android);
				else if (SystemUtil.isIpad())
				{
					admobSize=Admob.IPAD_PORTRAIT.height;
					_admobSize=Admob.IPAD_PORTRAIT;
					admob.setKeys(admob_ipad);
				}
				else
					admob.setKeys(admob_iphone);
				admob.enableTrace=false;
				admobSize*=2;
				trace('admobSize....', admobSize);
				admob.showBanner(_admobSize, AdmobPosition.BOTTOM_CENTER);
			}
			else
			{
				admobSize=100 * Game.scale;
			}

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

		private var intersititialTimeOut:int;

		public function showScreen(screenID:String):void
		{
			if (screenID == ResultScreen.SCREEN_ID)
			{
				if (admob.isInterstitialReady())
					intersititialTimeOut=setTimeout(show, 2000);
				else
					admob.cacheInterstitial();
			}
			screenNavigator.showScreen(screenID);

			if (screenNavigator.activeScreen is PlayScreen)
			{
				if (intersititialTimeOut > 0)
				{
					clearTimeout(intersititialTimeOut);
					intersititialTimeOut=0;
				}
			}
		}


		public function show():void
		{
			admob.showInterstitial();
			admob.cacheInterstitial();
		}

		public function share():void
		{
			// TODO Auto Generated method stub
			WechatProxy.sendLink( //
				File.applicationDirectory.resolvePath('icon/icon72.png').nativePath, // 
				AppstoreUtils.getAppDownloadURL(APP_ID), '好虐心的游戏...眼已瞎!', '眼已瞎!', // 
				WechatProxy.SHARE_TO_ALL_FRIENDS);
		}

		public function shareScreenShot(msg:String='', title:String=''):void
		{
			var bmd:BitmapData=new BitmapData(stage.stageWidth, stage.stageHeight);
			this.stage.drawToBitmapData(bmd);
			var imgURL:String=File.applicationStorageDirectory.nativePath + File.separator + 'screen_shot.png';
			BitmapdataUtils.saveBitmapTo(imgURL, bmd, new PNGEncoderOptions);
			WechatProxy.sendImage(imgURL, title, msg, WechatProxy.SHARE_TO_ALL_FRIENDS);
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
