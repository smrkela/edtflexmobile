package com.edt.mobile.views.home
{
	import com.edt.mobile.components.XAlertPopup;
	import com.edt.mobile.components.XNotificationPopup;
	import com.edt.mobile.utils.BasePresenter;
	import com.edt.mobile.utils.ServiceCall;
	import com.edt.mobile.utils.Sounds;
	import com.edt.mobile.views.dailytest.perform.DailyTestPerformView;
	import com.edt.mobile.views.dailytest.results.DailyTestResultsView;
	import com.edt.mobile.views.groups.GroupsView;
	import com.evola.driving.Session;
	import com.evola.driving.model.User;
	import com.evola.driving.util.ModelParser;
	
	import mx.collections.XMLListCollection;
	import mx.rpc.events.FaultEvent;

	public class HomePresenter extends BasePresenter
	{

		[Bindable]
		public var model:HomeModel=new HomeModel();

		public var view:HomeView;

		private var serviceLoadUser:ServiceCall=new ServiceCall("rest/user/getUser", onUserLoaded);
		private var serviceLoadExperience:ServiceCall=new ServiceCall("rest/statistics/loadUserExperience", onUserExperienceLoaded);
		private var serviceLoadModel:ServiceCall=new ServiceCall("rest/question/getAllQuestions", onModelLoaded);
		private var service:ServiceCall=new ServiceCall("rest/mobile/dailyTest/getDailyTestOverview", onDataLoaded, onFault);

		public function HomePresenter()
		{
		}

		public function viewShown():void
		{

			if (!model.userId)
			{
				model.currentLevel=0;
				model.currentProgress=0;
				model.experiencePoints=0;
				model.firstName="...";
				model.lastName="...";
				model.learnedQuestions=0;
				model.nextLevelPoints=0;
				model.testedQuestions=0;
				model.thisLevelPoints=0;
			}

			serviceLoadUser.send();
			serviceLoadExperience.send();
			serviceLoadModel.send();
			
			model.isLoading = true;
			
			service.send();
		}

		//***********************************************

		private function onUserLoaded(data:XML):void
		{

			Session.model.user = User.createFromXML(data);
			
			model.userId=data.@id;
			model.firstName=data.@firstName;
			model.lastName=data.@lastName;
			model.email=data.@email;
		}

		private function onUserExperienceLoaded(result:XML):void
		{

			var newLevel : Number = result.attribute("current-level");
			
			if(model.currentLevel && newLevel && newLevel > model.currentLevel)
				notifyNewLevel();
			
			model.currentLevel=newLevel;
			model.currentProgress=result.attribute("current-progress");
			model.experiencePoints=result.attribute("experience-points");
			model.learnedQuestions=result.attribute("learned-questions");
			model.testedQuestions=result.attribute("tested-questions");
			model.thisLevelPoints=result.attribute("current-level-experience-points");
			model.nextLevelPoints=result.attribute("next-level-experience-points");
		}
		
		private function onDataLoaded(result:XML):void
		{
			
			model.isLoading = false;
			
			model.isTodayTestDone = result.attribute("is-today-test-done") == "true";
			model.todayTestPoints = result.attribute("today-test-points");
			model.todayTestPosition = result.attribute("today-test-position");
			model.totalPointsEarned = result.attribute("total-points-earned");
			model.totalTests = result.attribute("total-tests");
			model.totalTestsDone = result.attribute("total-tests-done");
			model.currentPosition = result.attribute("current-position");
			model.totalTestUsers = result.attribute("total-test-users");
			model.totalTodayTestUsers = result.attribute("total-today-test-users");
			model.todayResults = new XMLListCollection(result.child('today-result'));
			model.todayTestId = result.attribute('today-test-id');
		}
		
		private function onFault(event : FaultEvent):void
		{
			
			model.isLoading = false;
			
			XAlertPopup.show(event);
			
		}
		
		private function notifyNewLevel():void
		{

			XNotificationPopup.show("Svaka čast! Uspešno pređen "+model.currentLevel+". nivo!");
			Sounds.playNewLevel();
		}
		
		private function onModelLoaded(result:XML):void
		{

			ModelParser.createModel(Session.model, result);
		}

		public function startLearningClicked():void
		{

			pushView(GroupsView, {type: "learning"});
		}

		public function startTestingClicked():void
		{

			pushView(GroupsView, {type: "testing"});
		}

		public function doTodayTest():void
		{
			
			pushView(DailyTestPerformView);
		}
		
		public function todayResultClicked():void
		{

			pushView(DailyTestResultsView, {testId: model.todayTestId, userId: Session.model.user.id});
		}
	}
}
