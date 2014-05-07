package com.agame.deadpixel
{
	import com.agame.deadpixel.screen.GamePlayingScreen;
	import com.agame.deadpixel.screen.GameResultScreen;
	import com.agame.deadpixel.screen.GameStartScreen;

	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;

	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.motion.transitions.ScreenFadeTransitionManager;
	import feathers.themes.MetalWorksMobileTheme;

	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.extension.starlingide.display.loader.StarlingLoader;
	import starling.extension.starlingide.display.movieclip.StarlingMovieClip;
	import starling.text.TextField;
	import starling.utils.AssetManager;

	public class GameRoot extends Sprite
	{
		public var scale:Number;
		public var stageWidth:Number;
		public var stageHeight:Number;

		public var fontName:String='fonts';
		public var assets:AssetManager;
		public var content:StarlingMovieClip;

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
			assets.enqueue('swf/DeadPixel_temp/DeadPixel_pack.swf');
			assets.loadQueue(assetsProgressing);
		}

		private function assetsProgressing(percent:Number):void
		{
			DeadPixel.loadingBar.txt.text='LOADING...' + int(percent * 100) + '%';
			if (percent == 1)
			{
				var ba:ByteArray=assets.getByteArray('DeadPixel_pack');
				var loader:StarlingLoader=new StarlingLoader;
				loader.loadBytes(ba);
				loader.addEventListener(Event.COMPLETE, assetsReady);
			}
		}


		private var screenNavigator:ScreenNavigator;
		private var screenTransitionManager:ScreenFadeTransitionManager;
		private var admobSize:Number=100;

		public var screenArea:Rectangle;

		public function assetsReady(evt:Event):void
		{
			var loader:StarlingLoader=evt.target as StarlingLoader;
			content=loader.context;
			addChild(content);
			content.width=stageWidth;
			content.height=stageHeight;
//			content.screen.y=admobSize;
			var boderSize:Number=content.scaleX * 20;
			screenArea=(content.screen as DisplayObject).getBounds(this);
			trace(screenArea);

			screenNavigator=new ScreenNavigator;
			addChild(screenNavigator);
//			content.addChildAt(screenNavigator, content.numChildren - 2);
			screenNavigator.addScreen(GamePlayingScreen.SCREEN_ID, new ScreenNavigatorItem(new GamePlayingScreen));
			screenNavigator.addScreen(GameResultScreen.SCREEN_ID, new ScreenNavigatorItem(new GameResultScreen));
			screenNavigator.addScreen(GameStartScreen.SCREEN_ID, new ScreenNavigatorItem(new GameStartScreen));
			screenTransitionManager=new ScreenFadeTransitionManager(screenNavigator);
			screenNavigator.showScreen(GamePlayingScreen.SCREEN_ID);
			DeadPixel.loadingBar.parent.removeChild(DeadPixel.loadingBar);
		}

		public function createTextfiled(text:String='', width:Number=128, height:Number=64, size:int=30, color:uint=0x0):TextField
		{
			var result:TextField=new TextField(width, height, text, Game.fontName, size, color);
			result.autoScale=true;
			return result;
		}
	}
}
