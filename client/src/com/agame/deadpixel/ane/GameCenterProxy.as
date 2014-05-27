package com.agame.deadpixel.ane
{
	import com.adobe.ane.gameCenter.GameCenterAchievementEvent;
	import com.adobe.ane.gameCenter.GameCenterAuthenticationEvent;
	import com.adobe.ane.gameCenter.GameCenterController;
	import com.adobe.ane.gameCenter.GameCenterLeaderboardEvent;

	public class GameCenterProxy
	{
		public function GameCenterProxy()
		{
		}

		private static var gcController:GameCenterController;

		public static function setup():void
		{
			if (gcController == null)
			{
				if (GameCenterController.isSupported)
				{
					gcController=new GameCenterController;
					addListeners();
					if (!gcController.authenticated)
					{
						gcController.addEventListener(GameCenterAuthenticationEvent.PLAYER_AUTHENTICATED, authTrue);
						gcController.authenticate();
					}
				}
				else
				{
					log("gamecenter is not supported");
				}
			}
		}

		/**
		 * GameCenter可用，且已经登录成功，返回true
		 * @return
		 *
		 */
		public static function get isSetup():Boolean
		{
			return gcController != null && gcController.authenticated;
		}

		/**
		 * 显示排行榜
		 */
		public static function requestLeaderboardCategories():void
		{
			if (gcController)
				gcController.requestLeaderboardCategories();
		}

		/**
		 * 设置分数
		 */
		public static function submitScore(score:int, category:String=null, context:int=0):void
		{
			if (gcController)
				gcController.submitScore(score, category, context);
		}

		/**
		 * 查询分数
		 */
		public static function requestScores(numberOfScores:int=0, category:String=null, playerScope:String=null, timeScope:String=null, gameCenterPlayers:Array=null):void
		{
			if (gcController)
				gcController.requestScores(numberOfScores, category, playerScope, timeScope, gameCenterPlayers);
		}


		private static function addListeners():void
		{
			//Authenticate 
			gcController.addEventListener(GameCenterAuthenticationEvent.PLAYER_NOT_AUTHENTICATED, authFailed);
			gcController.addEventListener(GameCenterAuthenticationEvent.PLAYER_AUTHENTICATION_CHANGED, authChanged);
			//Leadership
			gcController.addEventListener(GameCenterLeaderboardEvent.LEADERBOARD_VIEW_FINISHED, leadViewFinished);
			gcController.addEventListener(GameCenterLeaderboardEvent.LEADERBOARD_CATEGORIES_LOADED, leaderboardeCategoriesLoaded);
			gcController.addEventListener(GameCenterLeaderboardEvent.LEADERBOARD_CATEGORIES_FAILED, leaderboardeCategoriesFailed);
//			//Achievements
//			gcController.addEventListener(GameCenterAchievementEvent.ACHIEVEMENTS_VIEW_FINISHED, achViewFinished);
//			gcController.addEventListener(GameCenterAchievementEvent.ACHIEVEMENTS_LOADED, achLoaded);
//			gcController.addEventListener(GameCenterAchievementEvent.ACHIEVEMENTS_FAILED, achFailed);
//			gcController.addEventListener(GameCenterAchievementEvent.SUBMIT_ACHIEVEMENT_SUCCEEDED, achSubmittedSuccess);
//			gcController.addEventListener(GameCenterAchievementEvent.SUBMIT_ACHIEVEMENT_FAILED, achSubmitFailed);
//			gcController.addEventListener(GameCenterAchievementEvent.RESET_ACHIEVEMENTS_SUCCEEDED, resetSuccess);
//			gcController.addEventListener(GameCenterAchievementEvent.RESET_ACHIEVEMENTS_FAILED, resetUnsuccess);
//			//FriendReuest
//			gcController.addEventListener(GameCenterFriendEvent.FRIEND_REQUEST_VIEW_FINISHED, friendRequestViewFinished);
//			gcController.addEventListener(GameCenterFriendEvent.FRIEND_LIST_LOADED, friendListLoaded);
//			gcController.addEventListener(GameCenterFriendEvent.FRIEND_LIST_FAILED, friendListFailed);
//			//scores
//			gcController.addEventListener(GameCenterLeaderboardEvent.SUBMIT_SCORE_SUCCEEDED, submitScoreSucceed);
//			gcController.addEventListener(GameCenterLeaderboardEvent.SUBMIT_SCORE_FAILED, submitScoreFailed);
//			gcController.addEventListener(GameCenterLeaderboardEvent.SCORES_LOADED, requestedScoresLoaded);
//			gcController.addEventListener(GameCenterLeaderboardEvent.SCORES_FAILED, requestedScoresFailed);
//			//MatchMaker
//			gcController.addEventListener(GameCenterMatchEvent.MATCH_STARTED, matchStarted);
//			gcController.addEventListener(GameCenterMatchEvent.MATCH_FAILED, matchFailed);
//			gcController.addEventListener(GameCenterMatchEvent.MATCH_CANCELLED, matchCancelled);
//			gcController.addEventListener(GameCenterMatchEvent.MATCH_PLAYER_CONNECTED, playerConnected);
//			gcController.addEventListener(GameCenterMatchEvent.MATCH_PLAYER_DISCONNECTED, playerDisconnected);
//			gcController.addEventListener(GameCenterMatchEvent.MATCH_PLAYERS_LOADED, playersLoaded);
//			gcController.addEventListener(GameCenterMatchEvent.MATCH_PLAYERS_FAILED, playerLoadingFailed);
//			gcController.addEventListener(GameCenterMatchEvent.MATCH_DATA_RECEIVED, dataRecieved);
//			gcController.addEventListener(GameCenterMatchEvent.MATCH_INVITE_RECEIVED, inviteRecieved);
//			gcController.addEventListener(GameCenterMatchEvent.SEND_MATCH_DATA_FAILED, dataSendingFailed);
//			gcController.addEventListener(GameCenterMatchEvent.SEND_MATCH_DATA_SUCCEEDED, dataSendingSuccess);
//			gcController.addEventListener(GameCenterMatchEvent.MATCH_VOICE_FAILED, voiceFailed);
		}

		protected static function authTrue(event:GameCenterAuthenticationEvent):void
		{
			log("" + GameCenterAuthenticationEvent.PLAYER_AUTHENTICATED);
			if (gcController.localPlayer != null)
				log("Localplayer:" + gcController.localPlayer.alias + "playerID:" + gcController.localPlayer.id + "playerIsFriend" + gcController.localPlayer.isFriend);
			else
				log("authTrue null");
		}

		protected static function achViewFinished(event:GameCenterAchievementEvent):void
		{

			log("" + GameCenterAchievementEvent.ACHIEVEMENTS_VIEW_FINISHED);
		}

		protected static function leaderboardeCategoriesFailed(event:GameCenterLeaderboardEvent):void
		{
			log("" + GameCenterLeaderboardEvent.LEADERBOARD_CATEGORIES_FAILED);

		}

		protected static function leaderboardeCategoriesLoaded(event:GameCenterLeaderboardEvent):void
		{
			log("" + GameCenterLeaderboardEvent.LEADERBOARD_CATEGORIES_LOADED);
			for each (var x:String in event.leaderboardCategories)
			{
				log("LeaderBoard Categories:" + x);
			}

		}

		protected static function leadViewFinished(event:GameCenterLeaderboardEvent):void
		{
			log("" + GameCenterLeaderboardEvent.LEADERBOARD_VIEW_FINISHED);

		}

		protected static function authChanged(event:GameCenterAuthenticationEvent):void
		{

			log("" + GameCenterAuthenticationEvent.PLAYER_AUTHENTICATION_CHANGED);
		}

		protected static function authFailed(event:GameCenterAuthenticationEvent):void
		{
			log("" + GameCenterAuthenticationEvent.PLAYER_NOT_AUTHENTICATED);

		}

		private static function log(msg:String):void
		{
			trace(msg);
		}
	}
}
