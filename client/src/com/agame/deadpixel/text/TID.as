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
					lang[tid_note_touchme_start]='Start';
					lang[tid_note_deadpixel_small]='NOTE:Polish your eyes,\nthe dead pixels became smaller!';

					lang[tid_mode]='Mode';
					lang[tid_title_deadpixel]='Dead Pixel';
					lang[tid_classic]='Classic';
					lang[tid_speed]='Speed';
					lang[tid_sixty]='   60″';
					lang[tid_leaderborad]='Leaderborad';
					lang[tid_share]='Share';
					lang[tid_rate]='Rate';
					lang[tid_moreGames]='MoreGame';
					lang[tid_life]='Life  ';
					lang[tid_level]='Level  '
					lang[tid_help]='Help';
					lang[tid_button_flaunt]='flaunt';
					lang[tid_button_menu]='Home';
					lang[tid_button_replay]='Replay';
					lang[tid_new_record]='New Record!';
					lang[tid_best_score]='Best ';
					lang[tid_failed]='Failed!!';
					break;
				}
				case SystemLanguageDefs.ZH_CN:
				{
					lang[tid_note_classic]='<Number>次机会\n没有时间限制!'
					lang[tid_note_speed]='屏幕上有<Number>个坏点!\n用最短的时间把它们找出来!';
					lang[tid_note_sixty]='你有<Number>″!\n 看看你能找到多少坏点!';
					lang[tid_note_touchme_start]='开始';
					lang[tid_note_deadpixel_small]='注意：擦亮你的眼睛,\n坏点变的更小了!';

					lang[tid_mode]='模式';
					lang[tid_title_deadpixel]='坏点';
					lang[tid_classic]='经典';
					lang[tid_speed]='竞速';
					lang[tid_sixty]='   60″';
					lang[tid_leaderborad]='排名';
					lang[tid_share]='推荐';
					lang[tid_rate]='评分';
					lang[tid_moreGames]='更多游戏';
					lang[tid_life]='Life  ';
					lang[tid_level]='Level  '
					lang[tid_help]='求助';
					lang[tid_button_flaunt]='炫耀';
					lang[tid_button_menu]='首页';
					lang[tid_button_replay]='重来';
					lang[tid_new_record]='新纪录!';
					lang[tid_best_score]='最佳 ';
					lang[tid_failed]='败了!!';
					break;
				}
				case SystemLanguageDefs.ZH_TW:
				{
					lang[tid_note_classic]='<Number>次機會\n沒有時間限制!'
					lang[tid_note_speed]='屏幕上有<Number>個壞點!\n用最短的時間把它們找出來!';
					lang[tid_note_sixty]='妳有<Number>″!\n 看看妳能找到多少壞點!';

					lang[tid_note_touchme_start]='開始';
					lang[tid_note_deadpixel_small]='註意：擦亮妳的眼睛,\n壞點變的更小了!';

					lang[tid_mode]='模式';
					lang[tid_title_deadpixel]='壞點';
					lang[tid_classic]='經典';
					lang[tid_speed]='競速';
					lang[tid_sixty]='   60″';
					lang[tid_leaderborad]='排名';
					lang[tid_share]='推薦';
					lang[tid_rate]='評分';
					lang[tid_moreGames]='更多遊戲';
					lang[tid_life]='Life  ';
					lang[tid_level]='Level  '
					lang[tid_help]='求助';
					lang[tid_button_flaunt]='炫耀';
					lang[tid_button_menu]='首頁';
					lang[tid_button_replay]='重來';
					lang[tid_new_record]='新紀錄!';
					lang[tid_best_score]='最佳 ';
					lang[tid_failed]='敗了!!';
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
