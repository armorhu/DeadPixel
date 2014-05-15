package com.agame.deadpixel.text
{
	import com.amgame.consts.SystemLanguageDefs;


	public class TID
	{
		public function TID()
		{
		}
		private static const lang:Object={};

		public static const tid_mode:String='Mode';
		public static const tid_title_deadpixel:String='Dead Pixel';
		public static const tid_classic:String='Classic';
		public static const tid_speed:String='Speed';
		public static const tid_sixty:String='   60″';
		public static const tid_leaderborad:String='Leaderborad';
		public static const tid_share:String='Share';
		public static const tid_rate:String='Rate';
		public static const tid_moreGames:String='MoreGame';
		public static const tid_life:String='Life  ';
		public static const tid_level:String='Level  '
		public static const tid_help:String='Help';

		public static const tid_button_flaunt:String='flaunt';
		public static const tid_button_menu:String='Home';
		public static const tid_button_replay:String='Replay';
		public static const tid_new_record:String='New Record!';
		public static const tid_note_classic:String='tid_note_classic';
		public static const tid_note_touchme_start:String='tid_note_touchme_start';
		public static var tid_note_deadpixel_small:String='tid_note_deadpixel_small';
		public static var tid_note_speed:String='tid_note_speed';
		public static var tid_note_sixty:String='tid_note_sixty';
		public static var tid_best_score:String='Best ';
		public static var tid_failed:String='Failed!!';


		public static function init(language:String):void
		{
			switch (language)
			{
				case SystemLanguageDefs.EN:
				{
					lang[tid_note_classic]='<Number> Life \n no time limit';
					lang[tid_note_speed]='There are <Number> Dead Pixel in the Screen!\n found out them as fast as you can!';
					lang[tid_note_sixty]='You have <Number>″!\n found more Dead Pixel!';


					lang[tid_note_touchme_start]='Move Curser\nClick Me to Start';
					lang[tid_note_deadpixel_small]='NOTE:Polish your eyes,\nthe dead pixels became smaller!';
					break;
				}
				case SystemLanguageDefs.ZH_CN:
				{
					lang[tid_note_classic]='<Number>次机会\n没有时间限制!'
					lang[tid_note_speed]='屏幕上有<Number>个坏点!\n用最短的时间把它们找出来!';
					lang[tid_note_sixty]='你有<Number>″!\n 看看你能找到多少坏点!';

					lang[tid_note_touchme_start]='移动光标\n点我开始';
					lang[tid_note_deadpixel_small]='注意：擦亮你的眼睛,\n坏点变的更小了!';
					break;
				}
				case SystemLanguageDefs.ZH_TW:
				{
					lang[tid_note_classic]='<Number>次機會\n沒有時間限制!'
					lang[tid_note_speed]='屏幕上有<Number>個壞點!\n用最短的時間把它們找出來!';
					lang[tid_note_sixty]='妳有<Number>″!\n 看看妳能找到多少壞點!';

					lang[tid_note_touchme_start]='移動光標\n點我開始';
					lang[tid_note_deadpixel_small]='註意：擦亮妳的眼睛,\n壞點變的更小了!';
					break;
				}
				default:
				{
					break;
				}
			}
		}

		public static function getTextOf(tid:String):String
		{
			if (lang.hasOwnProperty(tid))
				return lang[tid];
			else
				return tid;
		}
	}
}
